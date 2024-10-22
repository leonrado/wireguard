#!/bin/bash
iptables -A FORWARD -i wg0 -s 10.13.13.4/32 -d 192.168.56.11/32 -j ACCEPT
iptables -A FORWARD -i wg0 -j DROP
iptables -A FORWARD -o wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
