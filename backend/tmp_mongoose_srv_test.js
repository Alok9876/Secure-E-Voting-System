const dns = require('dns');
const mongoose = require('mongoose');
require('dotenv').config();
(async()=>{
  try{
    dns.setServers(['8.8.8.8']);
    console.log('Using DNS servers:', dns.getServers());
    const cluster = 'secureevoting.3almt4h.mongodb.net';
    // Extract username/password from MONGO_URI
    const env = process.env.MONGO_URI || '';
    const m = env.match(/mongodb:\/\/(.*?):(.*?)@/);
    if(!m) throw new Error('Cannot parse credentials from MONGO_URI');
    const user = m[1];
    const pass = m[2];
    const srv = `mongodb+srv://${user}:${pass}@${cluster}/secure-evoting?authSource=admin&retryWrites=true&w=majority`;
    console.log('Attempting SRV connect to:', srv.replace(/:(.*)@/, ':<REDACTED>@'));
    await mongoose.connect(srv, { serverSelectionTimeoutMS: 8000 });
    console.log('✅ SRV Direct connect: SUCCESS');
    await mongoose.connection.close();
    process.exit(0);
  }catch(e){
    console.error('❌ SRV Direct connect error:', e && e.message ? e.message : e);
    process.exit(1);
  }
})();
