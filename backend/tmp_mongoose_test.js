require('dotenv').config();
const mongoose = require('mongoose');
(async()=>{
  try{
    const uri = process.env.MONGO_URI || '';
    console.log('Effective MONGO_URI (masked):', uri.replace(/:(.*)@/, ':<REDACTED>@'));
    await mongoose.connect(uri, { serverSelectionTimeoutMS: 8000 });
    console.log('✅ Direct connect: SUCCESS');
    await mongoose.connection.close();
    process.exit(0);
  } catch(e){
    console.error('❌ Direct connect error:', e && e.message ? e.message : e);
    process.exit(1);
  }
})();
