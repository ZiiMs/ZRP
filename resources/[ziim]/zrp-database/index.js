const mongodb = require('mongodb');

const uri = GetConvar('mongo_uri', '')
const dbName = GetConvar('mongo_db', '')

let db;

const RetrieveComponents = () => {
  Logger = exports['zrp-core']['FetchComponent']('Logger')
}

on('Core:Shared:Ready', () => {
  exports['zrp-core']['RequestDependencies']('Base', [
    'Logger',
  ], (e) => {
    if (e > 0) {
      console.log('Errors', e[1]);
      return;
    }
    RetrieveComponents()
  })
})

if (url != '' && dbName != '') {

} else {
  if (url == '') Logger.Error('MongoDB', `Convar "mongo_uri" not set`);
  if (dbName == '') Logger.Error('MongoDB', `Convar "mongo_db" not set`);
}

const Database = {
  Test: () => { 
    console.log("Test!?!")
  },
}

on('Proxy:Shared:RegisterReady', () => {
  console.log('Index.js Registering!?!?')
  exports['zrp-core']['RegisterComponent']('Database', Database)
})
