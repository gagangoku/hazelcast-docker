#!/bin/bash
set -x

echo "----------------------- Starting Hazelcast ---------------------------"

echo "cwd = $(pwd)"
echo "which java = $(which java)"
echo "ls"
ls

echo "PUBLIC_IP = $PUBLIC_IP"
echo "MEMBER_LIST = $MEMBER_LIST"
MEMBERS=""

IFS=","
for m in $MEMBER_LIST
do
  MEMBERS="$MEMBERS<member>$m</member>"
done
echo "MEMBERS=$MEMBERS"

# Replace the variables
echo "Replacing variables in place"
sed -i.bak "s/{PUBLIC_IP}/$PUBLIC_IP/" hazelcast.xml
sed -i.bak "s,{MEMBER_LIST},$MEMBERS," hazelcast.xml

JAVACMD="java"

echo "Server startup configuration: $DEFAULT_JVM_OPTS $JAVA_OPTS"

echo "$# CMD arguments received, values $@"
echo "Environment variables :  $env"

echo "------------------------------------------------------------------------------"
echo "$JAVACMD -server ${JAVA_OPTS} -cp hazelcast-all-$HZ_VERSION.jar com.hazelcast.core.server.StartServer"
echo "------------------------------------------------------------------------------"

$JAVACMD -server ${JAVA_OPTS} -cp hazelcast-all-$HZ_VERSION.jar com.hazelcast.core.server.StartServer
