import {MochaRunner, describe, it, before, after, beforeEach, afterEach, xdescribe, xit, specify, xspecify, context, xcontext} from "meteor/practicalmeteor:mocha"
import {expect} from "meteor/practicalmeteor:chai"

export default () =>{

  describe("Client Test", function(){

    it("this test is client side only", function(){
      expect(Meteor.isClient).to.be.true
      expect(Meteor.isServer).to.be.false
    })
  });

}