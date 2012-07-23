global.isPro = true;
var cluster = require('cluster');
var numCPUs = require('os').cpus().length;

require("coffee-script");


if (cluster.isMaster) {
  // Fork workers.
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('death', function(worker) {
    console.log('worker ' + worker.pid + ' died');
  });
  console.log('Master PID:', process.pid);
} else {
  console.log('Worker PID:', process.pid);
  require("tower").run(process.argv);
}

