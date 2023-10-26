#!/bin/bash
docker run -p 3000:80 -p 27017:27017 -d -v $(pwd)/src:/app/src -e MONGO_URI=mongodb://localhost:27017/ -e MONGO_DB=mydb --restart=always web