import { MongoClient } from 'mongodb';
import fetch from 'node-fetch';

const mongoURI = process.env.MONGO_URI;
const mongoDB = process.env.MONGO_DB;

if (!mongoURI || !mongoDB) {
    throw new Error("Please set the MONGO_URI and MONGO_DB environment variables.");
}

let client;

async function getClient() {
    if (!client) {
        client = new MongoClient(mongoURI);
        try {
            await client.connect();
        } catch (error) {
            console.error("Failed to connect to MongoDB:", error);
            throw error;
        } 
    }
    return client;
}

async function getUsers(req, res) {
    try {
        const client = await getClient();
        const db = client.db(mongoDB);
        const collection = db.collection('contacts');
        const users = await collection.find({}).toArray();
        res.send(`${users.map(u => u.name.first).join(', ') || 'No users found'}`);
    } catch (error) {
        console.error("Failed to retrieve contacts:", error);
        res.status(500).send("Internal Server Error");
    }
}

async function addUsers(req, res) {
    try {
        const client = await getClient();
        const db = client.db(mongoDB);
        const collection = db.collection('contacts');
        const count = parseInt(req?.body?.count) || 10;
        console.log(`Adding ${count} users`);
        const users = await fetch(`https://randomuser.me/api/?results=${count}`);
        const { results } = await users.json();
        const { insertedCount } = await collection.insertMany(results);
        res.send(`Added ${insertedCount} contacts`);
    } catch (error) {
        console.error("Failed to add contacts:", error);
        res.status(500).send("Internal Server Error");
    } 
}

export default { getUsers, addUsers }
