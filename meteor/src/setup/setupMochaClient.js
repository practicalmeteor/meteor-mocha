import {meteorInstall} from "meteor/modules"

// Here we are creating stubs packages to be availabe on the client side.
// This must be called before require('mocha')
// See an example from https://goo.gl/us9YVR

export default ()=>{

  process.browser = true;
  
  require("meteor-node-stubs");

  meteorInstall({
    node_modules: {
      "tty.js": function (r, e, module) {
        module.exports = { isatty: ()=>{ return false}}
      }
    }
  });

  meteorInstall({
    node_modules: {
      "constants.js": function (r, e, module) {
        module.exports = {
          test: {'test':'test'}
        }
      }
    }
  });


}
