#!/bin/bash
read -p "Informe o IP do LoadBalancer: " IP_DO_LB
curl -v http://nginx.lab.local --resolve nginx.lab.local:80:$IP_DO_LB
