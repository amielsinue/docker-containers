#!/bin/bash

MONGODB1=`ping -c 1 mongo | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB2=`ping -c 1 mongo-replica | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Server 1: ${MONGODB1}"
echo "Server 2: ${MONGODB2}"

echo "Waiting for mongo 1 startup.."
until curl http://${MONGODB1}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo "Waiting for mongo 2 startup.."
until curl http://${MONGODB2}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

if [ -n "$MONGODB1" ]; then


  mongo --host $MONGODB1 <<EOF
   var cfg = {
        "_id": "rs0",
        "version": 1,
        "members": [
            {"_id": 0,"host": "${HOSTIP}:27017"},
            {"_id": 1,"host": "${HOSTIP}:27018"}
        ]
   };
   rs.initiate( cfg, {force : true} );
   rs.reconfig(cfg, {force : true})
   rs.conf();

EOF

echo ${MONGODB1}

fi
