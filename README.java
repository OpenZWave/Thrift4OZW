ekarak@ekarak-laptop:~/ozw/Thrift4OZW$ make java
cd gen-java/OpenZWave; javac -cp .:`find /home/ekarak/ozw/thrift/lib/java/build -name "*.jar" | tr "\n" ":"` *.java
Note: Some input files use unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
cd gen-java;  jar -cf OpenZWave.jar OpenZWave/*.class
ekarak@ekarak-laptop:~/ozw/Thrift4OZW$ ls -l gen-java/*.jar
-rw-rw-r-- 1 ekarak ekarak 3292661 ???   2 23:19 gen-java/OpenZWave.jar
ekarak@ekarak-laptop:~/ozw/Thrift4OZW$ 