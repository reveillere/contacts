#!/bin/bash
mongod --fork --logpath /var/log/mongod.log
npm run dev
