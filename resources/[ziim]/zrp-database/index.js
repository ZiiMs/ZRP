const RetrieveComponents = () => {
  Logger = exports.zrp-core.FetchComponent('Logger')
}

on('Core:Shared:Ready', () => {
  exports.zrp-core.RequestDependencies('Base', [
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
  exports['zrp-core']['RegisterComponent']()
  exports.zrp-core.RegisterComponent('Database', Database)
})

RegisterCommand('ret', (source, args, raw) => {
  // TODO: make a vehicle! fun!
  console.log("Running test")
  Database.Test();
}, false);