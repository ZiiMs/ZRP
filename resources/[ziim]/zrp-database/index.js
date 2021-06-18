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

}

on('Proxy:Shared:RegisterReady', () => {
  exports.zrp-core.RegisterComponent('Base', Database)
})