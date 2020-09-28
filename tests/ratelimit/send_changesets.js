var etherpad = require("../../src/node_modules/etherpad-cli-client");
var pad = etherpad.connect(process.argv[2]);
pad.on("connected", function(){

  setTimeout(function(){
    setInterval(function(){
      pad.append("1");
    }, process.argv[3]);
  },100); // wait 100ms because CLIENT_READY message is included in ratelimit

  setTimeout(function(){
    console.log("0");
    process.exit(0);
  },11000)
});
// in case of disconnect exit code 1
pad.on("message", function(message){
  if(message.disconnect == 'rateLimited'){
    console.log("1");
    process.exit(1);
  }
})
