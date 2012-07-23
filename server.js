global.isPro = true;

var daemon = require('daemon');
require("coffee-script");
require("tower").run(process.argv);  

daemon.daemonize('tmp/stdout-and-stderr.log', 'tmp/shop.pid', function (err, pid) {
    //
    // We are now in the daemon process
    //
    if (err) {
      return console.log('Error starting daemon: ' + err);
    }

    console.log('Daemon started successfully with pid: ' + pid);
  });



