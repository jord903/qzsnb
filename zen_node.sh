#!/bin/bash

PID_FILE='/home/jord903/.zen/zen_node.pid'

start() {
       touch $PID_FILE
       eval "/bin/su jord903 -c '/usr/bin/zend 2>&1 >> /dev/null'"
       PID=$(ps aux | grep zend | grep -v grep | awk '{print $2}')
       echo "Starting zend with PID $PID"
       echo $PID > $PID_FILE
}
stop () {
       pkill zend
       rm $PID_FILE
       echo "Stopping zend"
}

case $1 in
    start)
       start
       ;;
    stop)  
       stop
       ;;
     *)  
       echo "usage: zend {start|stop}" ;;
 esac
 exit 0