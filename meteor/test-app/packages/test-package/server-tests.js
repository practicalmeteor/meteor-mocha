import {describe, it } from "meteor/practicalmeteor:mocha"
import {expect} from "meteor/practicalmeteor:chai"
export default ()=>{
  
  describe("Server Test", function(){

    it("this test is server side only", function(){
      expect(Meteor.isServer).to.be.true
      expect(Meteor.isClient).to.be.false
    });

    it("require('fs) === to Npm.require('fs')", function() {
      expect(require('fs')).to.equal(Npm.require('fs'))
    })
  });
}