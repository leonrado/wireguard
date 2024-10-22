#!/bin/bash
iptables -D FORWARD -i wg0 -s 10.13.13.4/32 -d 192.168.56.11/32 -j ACCEPT
iptables -D FORWARD -i wg0 -j DROP
iptables -D FORWARD -o wg0 -j ACCEPT
iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE