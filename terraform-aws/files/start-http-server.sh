#!/bin/bash
cnt=1 ; while true ; do echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n${cnt}\r\n$(ip a)"  | nc -l -k -p 8080 -q 1 ; cnt=$((cnt+1)) ; done
