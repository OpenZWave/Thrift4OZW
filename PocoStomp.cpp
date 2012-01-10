/*
Thrift4OZW - An Apache Thrift wrapper for OpenZWave
----------------------------------------------------
Copyright (c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>

SOFTWARE NOTICE AND LICENSE

Thrift4OZW is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

Thrift4OZW is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Thrift4OZW.  If not, see <http://www.gnu.org/licenses/>.

for more information on the LGPL, see:
http://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License
*/

//	PocoStomp.cpp
//  a STOMP (Simple Text Oriented Messaging Protocol) client for OZW
//  using the Poco library for platform interoperability

#include <stdlib.h>
#include <iostream>

#include "PocoStomp.h"

using namespace std;

void hexdump(const void *ptr, int buflen) {
    unsigned char *buf = (unsigned char*)ptr;
    int i, j;
    for (i=0; i<buflen; i+=16) {
        printf("%06x: ", i);
        for (j=0; j<16; j++) 
            if (i+j < buflen)
                printf("%02x ", buf[i+j]);
            else
                printf("   ");
        printf(" ");
        for (j=0; j<16; j++) 
            if (i+j < buflen)
                printf("%c", isprint(buf[i+j]) ? buf[i+j] : '.');
        printf("\n");
    }
}

namespace STOMP {
    
// ####################################################
// constructor
// ####################################################
PocoStomp::PocoStomp(const std::string& hostname, int port):
    m_hostname(hostname),
    m_port(port),
    m_connection(new Connection),
    m_ackmode(ACK_AUTO),
    m_fsm(* this)     // initialize the state machine
{
    m_connection->addr = NULL;
    m_connection->socket = NULL;
    // insert valid server commands in set
    m_stomp_server_commands.insert("CONNECTED");
    m_stomp_server_commands.insert("MESSAGE");
    m_stomp_server_commands.insert("RECEIPT");
    m_stomp_server_commands.insert("ERROR");
    // our custom thread error handler
    MyErrorHandler eh;
    //Poco::ErrorHandler* pOldEH = Poco::ErrorHandler::set(&eh);
    Poco::ErrorHandler::set(&eh);
    //
    m_initcond_mutex = new Poco::Mutex();
    m_initcond = new Poco::Condition();
    m_mutex = new Poco::Mutex();
    (m_thread = new Poco::Thread())->start(*this);
}

// ####################################################
//destructor
// ####################################################
PocoStomp::~PocoStomp()
{
    //TODO: signal thread to stop
    m_thread->join(1000);
    delete(m_thread);
    delete(m_connection);
    delete(m_mutex);
    delete(m_initcond);            
    delete(m_initcond_mutex);
}

// ####################################################
bool PocoStomp::socket_connect()
// ####################################################
{
    while (m_fsm.getState().getId() != StompFSM_map::SocketConnected.getId()) {
        try {
            m_connection->addr = new Poco::Net::SocketAddress(m_hostname, m_port);
            m_connection->socket = new Poco::Net::StompSocket(*(m_connection->addr));
            m_fsm.socket_connected();
        } catch (exception& e) {
            std::cerr << "Exception: " << e.what() << std::endl;
            m_fsm.socket_disconnected();
            sleep(3);
        } catch (...) {
            std::cerr << "other error in socket_connect()" << std::endl;
            m_fsm.socket_disconnected();
            sleep(3);
        }
    }
    return(m_fsm.getState().getId() == StompFSM_map::SocketConnected.getId());
}

// ####################################################
void PocoStomp::socket_shutdown()
// ####################################################
{
    if (m_connection->addr != NULL) {
            delete m_connection->addr;
            if (m_connection->socket != NULL) {
                    delete m_connection->socket;
            }
    }
}

// ####################################################
bool PocoStomp::connect()
// ####################################################
{
    bool result=socket_connect();
    m_mutex->lock();
    try {
        if (m_fsm.getState().getId() == StompFSM_map::SocketConnected.getId()) {
            //std::cout << "Sending CONNECT frame...";
            Frame _frame("CONNECT");
            //
            if (stomp_write(&_frame)) {    
                m_fsm.send_frame(&_frame);
            }
            //
        }
    } catch (exception& e) {
        std::cerr << "Exception: " << e.what() << std::endl;
        m_fsm.socket_disconnected();
        sleep(3);
    } catch (...) {
        std::cerr << "other error in connect()" << std::endl;
        m_fsm.socket_disconnected();
        sleep(3);
    }
    m_mutex->unlock();
    return(result);
}


// ####################################################
bool PocoStomp::subscribe(std::string& _topic, pfnOnStompMessage_t _callback)
// ####################################################
{
    bool result = true;
    //std::cout << "Sending SUBSCRIBE...";
    Frame _frame("SUBSCRIBE");
    _frame.headers["destination"] = _topic;
    //
    m_mutex->lock();
    {
        m_sendqueue.push(new Frame(_frame));
        m_subscriptions[_topic] = _callback;
    }
    m_mutex->unlock();
    return(result);
}

// ####################################################
bool PocoStomp::send ( std::string& _topic, std::map<std::string, std::string> _headers, std::string& _body)
// ####################################################
{
    bool result = true;
    Frame _frame("SEND");
    _frame.headers = _headers;
    _frame.body = _body;
    _frame.headers["destination"] = _topic;
    //
    m_mutex->lock();
    //
    m_sendqueue.push(new Frame(_frame));
    //
    m_mutex->unlock();
    return(result);
}


//incoming frame by STOMP server, notify all callbacks for this topic (header: "destination")
// ####################################################
void PocoStomp::notify_callbacks(PFrame _frame)
// ####################################################
{
    //get destination topic
    if (_frame->headers.find("destination") != _frame->headers.end()) {
        std::string* dest = new std::string(_frame->headers["destination"]);
        //std::cout << "notify_callbacks dest=" << dest << std::endl;
        //
        m_mutex->lock();
        pfnOnStompMessage_t callback_function = m_subscriptions[*dest];
        m_mutex->unlock();
        //
        if (callback_function != NULL) {
            callback_function(_frame);
        }
        //
        delete(dest);
    }
}

// 
// ####################################################
bool PocoStomp::stomp_read(PFrame *frame)
// ####################################################
{
    int bytes_read; //length, 
    const char* str;
    PFrame newframe;
    std::string line, key, val;
    size_t pos;
    // scan all incoming data for frames 
    while (m_connection->socket->incoming_data_waiting()) {
        //~ std::cout << "stomp_read awoken! ";
        // Step 1. Parse the server command, skipping past uninteresting lines
        if (m_connection->socket->receiveMessage(line)) {
            //~ std::cout << "line=" << line << "(" << line.length() << ")" << std::endl;
            //~ hexdump(line.c_str(), line.length());
            // check for valid command
            if (m_stomp_server_commands.find(line) != m_stomp_server_commands.end()) {
                str = line.c_str();
                //std::cout << endl << line.length() << " bytes in command:\n";
                //hexdump(line.c_str(), line.length());
                newframe = new Frame(line);
                    
                // Step 2. Parse the headers.
                while( 1 ) {
                     if (m_connection->socket->receiveMessage(line)) {
                        //std::cout << endl << line.length() << " bytes in header:\n ";
                        //hexdump(line.c_str(), line.length());
                        // Done with headers? (empty line separating headers and body?)
                        if (line.length() == 0) {
                            //cout << m_connection->socket->available() << " bytes still in receive queue" << endl;
                            break;
                        }
                        if ((pos = line.find(":")) == line.npos) throw("stomp_read(): no colon delimiter in header!");
                        // extract key, value from header line
                        key = line.substr(0, pos);
                        val = line.substr(pos+1);
                        //std::cout << "header key=" << key << " value=" << val << endl;
                        // Insert key/value into hash table.
                        newframe->headers[key] = val;
                     } else {
                        break;
                     }
                 }
                 
                // Step 3. Read body
                char *body;
                int bodylen;
                if (newframe->headers.find("content-length") != newframe->headers.end()) {
                    std::stringstream(newframe->headers["content-length"]) >> bodylen;
                    if (bodylen > 0) {
                        body = (char*) malloc(bodylen+1);
                        // NOTE: must use receiveRawBytes
                        bytes_read = m_connection->socket->receiveRawBytes(body, bodylen+1);
                        //~ std::cout << "stomp_read(): body by content-length: " << bodylen+1 << endl;
                        //~ hexdump(body, bytes_read);
                        if (bytes_read != bodylen+1) throw("stomp_read(): body shorter than content-length");
                        newframe->body = std::string(body);
                        free(body);
                    } else {
                        //~ std::cout << "\nempty body!\n";
                    }
                } else { 
                    // no content-length, read all available bytes till \0
                    m_connection->socket->receiveMessage(line, '\0');
                    if (line.length() > 0) {
                        //~ std::cout << "stomp_read(): " << line.length() << " bytes in body:\n";
                        //~ hexdump(line.c_str(), line.length());
                        newframe->body = line;
                    } else {
                        //~ std::cout << "\nempty body!\n";
                    }
                }
                (*frame) = newframe;
                return(true);
            }
        }
    }
    return(false);

}


// ####################################################
bool PocoStomp::stomp_write(PFrame frame) 
// ####################################################
{
   // step 1. Write the command.
//    const char* s;
    //int len;
    if (frame->command.length() > 0) {
        stomp_write_buffer(frame->command);
        stomp_write_buffer("\n", 1);
    } else {
        throw("stomp_write: command not set!!");
    }
    // step 2. Write the headers
    if( frame->headers.size() > 0) {
        string key, value;
        hdrmap::iterator it;
        for ( it=frame->headers.begin() ; it != frame->headers.end(); it++ ) {
            key = (*it).first;
            value = (*it).second;
            stomp_write_buffer(key);
            stomp_write_buffer(":", 1);
            stomp_write_buffer(value);
            stomp_write_buffer("\n", 1);
        }
    }
    // special header: content-length
    if(frame->body.length() > 0) {
        std::stringstream length_string;
        length_string << frame->body.length();
        stomp_write_buffer("content-length:", 15);
        stomp_write_buffer(length_string.str());
        stomp_write_buffer("\n", 1);
    }
    // write newline signifying end of headers
    stomp_write_buffer("\n", 1);

   // step 3. Write the body
   if( frame->body.length() > 0) {
      stomp_write_buffer(frame->body);
   }
   
   // write terminating NULL char
   stomp_write_buffer("\0", 1);
   return (true);
}

// ####################################################
bool PocoStomp::stomp_write_buffer(const char *data, int size)
// ####################################################
{
    int remaining = size;
    int sent = 0;
    size=0;
    while( remaining>0 ) {
        int length = remaining;
        sent = m_connection->socket->sendBytes(data,length);
        data += sent;
        remaining -= sent;
        if( length != sent) {
            return false;
        }
    }
    return true;
}

// ####################################################
bool PocoStomp::stomp_write_buffer(std::string s) 
// ####################################################
{
    return(stomp_write_buffer(s.c_str(), s.length()));
}

// ####################################################
void PocoStomp::debug_print(std::string message)
{
#ifdef DEBUG_POCOSTOMP
    std::cout << "FSM DEBUG: " << message << endl;
#endif
}

void PocoStomp::initialized()
{
    m_initcond->broadcast();
}

void PocoStomp::start_timer(PocoStompState* _state)
{
}

void PocoStomp::stop_timer()
{
}


// PocoStomp::run(): Main worker thread, watches the stomp socket for 
// subscription MESSAGEs, sends outgoing messages
// ####################################################
void  PocoStomp::run()
// ####################################################
{

    PFrame _frame;
    bool cond1, cond2;
    bool frame_popped = false;
    int state_id;
    //wait for stomp client initialization
    m_initcond_mutex->lock();
    m_initcond->wait(*m_initcond_mutex);
    m_initcond_mutex->unlock();
    // ok, stomp object is initialized, lets start.
    while (true) {
        //
        m_mutex->lock();
        //
        run_loop_start:
        try {
            // phase 1: read incoming frames, if any
            if (stomp_read(&_frame)) {
                m_fsm.receive_frame(_frame);
                //std::cout << "received frame:" << _frame->command << std::endl;
                free(_frame);
            } 
            //
            // phase 2: send first frame in queue, if any
            state_id = m_fsm.getState().getId();
            cond1 = (state_id == StompFSM_map::Ready.getId());
            cond2 = (m_sendqueue.size() > 0);
            if (cond1 && cond2) {
                _frame = m_sendqueue.front();
                m_sendqueue.pop();
                frame_popped = true;
                if (stomp_write(_frame)) {                        
                    m_fsm.send_frame(_frame);
                    //std::cout << "sent frame:" << _frame->command << std::endl;
                }
                free(_frame);
            }
        } catch (exception& e) {
            std::cerr << "Exception in PocoStomp::run(): " << e.what() << std::endl;
            if (frame_popped) m_sendqueue.push(_frame);
            m_fsm.socket_disconnected();
            sleep(3);
            connect();
            goto run_loop_start;
        } catch (...) {
            std::cerr << "default exception in PocoStomp::run()";
            exit(-1);
        };
        //
        m_mutex->unlock();
        //
        Poco::Thread::sleep(50);
    }
}

}