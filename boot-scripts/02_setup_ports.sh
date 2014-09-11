#!/bin/bash

## this will ensure we can access jenkins on port 80
if ! iptables -t nat -L | grep -q '^REDIRECT.*8080'; then
    iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
fi
