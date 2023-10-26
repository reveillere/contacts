# Utiliser une image de base Debian
FROM debian:buster-slim

# Mettre à jour les paquets et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y wget gnupg

# Installer Node.js
RUN wget -qO- https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Installer MongoDB
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && apt-get install -y mongodb-org

# Créer un dossier pour la base de données MongoDB
RUN mkdir -p /data/db

# Configurer l'environnement de travail pour Node.js
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .

# Exposer les ports pour Node.js et MongoDB
EXPOSE 80 27017

# Commande pour démarrer MongoDB et Node.js (à adapter selon vos besoins)
CMD mongod --fork --logpath /var/log/mongod.log && npm run dev
