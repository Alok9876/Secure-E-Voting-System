const dns = require('dns');
dns.setServers(['8.8.8.8']);

const { MongoClient } = require('mongodb');

const uri = "mongodb+srv://aloksharma1322:Alok%409876@cluster0.ke6snza.mongodb.net/?appName=Cluster0";
const client = new MongoClient(uri);

async function run() {
  try {
    console.log("Connecting...");
    await client.connect();
    console.log("Connected successfully to server");
    const db = client.db("admin");
    const pingResult = await db.command({ ping: 1 });
    console.log("Ping result:", pingResult);
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
