var Service = require('node-windows').Service;
 
var svc = new Service({
  name:'Epiron - WebAppExecute Service',
  description: 'Service backend WebAppExecute',
  script: 'C:\\Epiron\\execute.back\\bin\\www'
});
 
svc.on('install',function(){
  svc.start();
});
 
svc.install();