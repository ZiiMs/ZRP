const mongodb = require('mongodb');

const uri = GetConvar('mongo_uri', 'localhost')
const db = GetConvar('mongo_db', 'empty')

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

const Database = {
  Test: () => { 
    console.log("Test!?!")
  },
}

on('Proxy:Shared:RegisterReady', () => {
  console.log('Index.js Registering!?!?')
  exports['zrp-core']['RegisterComponent']('Database', Database)
})
