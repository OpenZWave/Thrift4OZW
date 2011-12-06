//-----------------------------------------------------------------------------
//
//	PocoStomp.h
//
//	a STOMP (Simple Text Oriented Messaging Protocol) client for OZW
//  using the Poco library for platform interoperability
//
//	Copyright (c) 2011 Elias Karakoulakis
//
//	SOFTWARE NOTICE AND LICENSE
//
//	This file is part of OpenZWave.
//
//	OpenZWave is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser General Public License as published
//	by the Free Software Foundation, either version 3 of the License,
//	or (at your option) any later version.
//
//	OpenZWave is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser General Public License for more details.
//
//	You should have received a copy of the GNU Lesser General Public License
//	along with OpenZWave.  If not, see <http://www.gnu.org/licenses/>.
//
//-----------------------------------------------------------------------------
#ifndef __POCOSTOMP_H_
#define __POCOSTOMP_H_

#include <string>
#include <sstream>
#include <iostream>
#include <queue>
#include <map>
#include <set>

#include "Poco/Net/SocketAddress.h"
#include "Poco/Net/Socket.h"
#include "Poco/HashMap.h"
#include "Poco/Mutex.h"
#include "Poco/Runnable.h"
#include "Poco/Thread.h"
#include "Poco/Timespan.h"
#include "Poco/Condition.h"
#include "Poco/ErrorHandler.h"

#include "StompSocket.h"

// helpers
namespace STOMP {
    
    // a STOMP connection
    typedef struct {
        Poco::Net::SocketAddress* addr;
        Poco::Net::StompSocket*  socket;
    } Connection;

    typedef std::map<std::string, std::string> hdrmap;
    
    // a STOMP frame
   class Frame {
       public:
            std::string command;
            hdrmap       headers;
            std::string  body;
        Frame(std::string cmd) : command(cmd) {};
        Frame(std::string cmd, hdrmap h) : command(cmd), headers(h) {};
        Frame(std::string cmd, hdrmap h, std::string b) : command(cmd), headers(h), body(b) {};
        Frame(Frame& other)  {
            command = other.command;
            headers = other.headers;
            body = other.body;
        };
    };
    typedef Frame* PFrame;

    typedef enum {
        ACK_AUTO=0, // implicit acknowledgment (no ACK is sent)
        ACK_CLIENT      // explicit acknowledgment (must ACK)
    } AckMode;
    
    typedef struct data_block_list {
       char data[1024];
       struct data_block_list *next;
    } data_block_list;

}
// the state machine must be included here (uses the structs above)
#include "Stomp_sm.h"

template <class T>
std::string to_string(T t, std::ios_base & (*f)(std::ios_base&))
{
  std::ostringstream oss;
  oss << f << t;
  return oss.str();
}

//


namespace STOMP {

    typedef void (*pfnOnStompMessage_t)( Frame* _frame );

    class MyErrorHandler: public Poco::ErrorHandler
    {
        public:
        void exception(const Poco::Exception& exc)
        {
            std::cerr << exc.displayText() << std::endl;
        }
        void exception(const std::exception& exc)
        {
            std::cerr << exc.what() << std::endl;
        }
        void exception()
        {
            std::cerr << "unknown exception" << std::endl;
        }
    };

    class PocoStomp: public Poco::Runnable
    {
        friend class StompFSM_map_Disconnected;
        friend class StompFSM_map_SocketConnected;
        friend class StompFSM_map_WaitingConnectionAck;
        friend class StompFSM_map_Ready;
        friend class StompFSM_map_ReceivingFrame;
        friend class StompFSM_map_SendingAck;
        friend class StompFSM_map_WaitingCommandAck;
        friend class StompFSM_map_Disconnecting;
        
        //instance variables
        protected:
            Connection*      m_connection;
            AckMode         m_ackmode;
            StompContext   m_fsm;
            //
            
            Poco::Thread*           m_thread;
            Poco::Mutex*             m_mutex;
            Poco::Mutex*            m_initcond_mutex;
            Poco::Condition*        m_initcond;
            std::queue<PFrame>    m_sendqueue;
            std::map<std::string, pfnOnStompMessage_t>   m_subscriptions;
            //
        //#########################
        //---- FILE: Stomp.cpp ----
        //#########################
        public:
            //initialization condition
            //~ apr_thread_cond_t*  m_initcond; 
        	//~ apr_thread_mutex_t* m_initcond_mutex;
            //
            PocoStomp(const std::string& hostname, int port);
            ~PocoStomp();
            // thread-safe methods called from outside the thread loop
            bool connect   ();
            bool subscribe ( std::string& _topic,  pfnOnStompMessage_t callback);
            bool send        ( std::string& _topic, hdrmap _headers, std::string& _body);
            //
            PocoStompState& get_state() { return m_fsm.getState(); };
            AckMode get_ackmode() { return m_ackmode; };
            //
        protected:
            //######################################
            //---- FILE: Stomp_fsmfunctions.cpp ----
            //######################################
            void initialized(); 
            void start_timer(PocoStompState* _state);
            void stop_timer();
            void debug_print(std::string message);
            void notify_callbacks(Frame* _frame);
        
            // IO methods called from the thread loop
            //
            bool stomp_read(STOMP::PFrame *frame);
            bool stomp_write(STOMP::PFrame frame);
            bool stomp_write_buffer(const char *data, int size);
            bool stomp_write_buffer(std::string s) ;
        
            // more methods called from the thread loop
            bool socket_connect(const std::string& hostname, int port);
            bool incoming_data_waiting();
        private:
            void run(); // Runnable::run(): Stomp worker thread implementation
            std::set<std::string> m_stomp_server_commands;
    }; //class
    
}
#endif