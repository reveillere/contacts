# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Install NodeJS
RUN apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg && \
    NODE_MAJOR=20 && echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs


# Install MongoDB
RUN apt-get install -y gnupg curl && curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && apt-get install -y mongodb-org jq && \
    mkdir -p /data/db && chown -R mongodb:mongodb /data/db

# Setup our app
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .

EXPOSE 80 27017

# Use a script to start mongod and node
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]