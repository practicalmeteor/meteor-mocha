import {MochaRunner, describe, it, before, after, beforeEach, afterEach, xdescribe, xit, specify, xspecify, context, xcontext} from "meteor/practicalmeteor:mocha"
import {expect} from "meteor/practicalmeteor:chai"
import TestCollection from "./TestCollection"

export default ()=> {


  console.log("------------------------------------------------");
  console.log("----------------PACKAGE VERSIONS----------------");
  console.log("practicalmeteor:mocha:", MochaRunner.VERSION);
  console.log("------------------------------------------------");
  console.log("------------------------------------------------");


  describe('1 - Array', function() {

    describe('1.1 - #indexOf()', function() {
      return it('should return -1 when the value is not present', function() {
        expect([1, 2, 3].indexOf(5)).to.equal(-1);
        return expect([1, 2, 3].indexOf(0)).to.equal(-1);
      });
    });

    describe('1.2 - length', function() {
      return it('should return length of array', function() {
        return expect([1, 2, 3].length).to.equal(3);
      });
    });

  });

  describe('2 - Async test', function() {

    it('should pass', function(done) {
      Meteor.setTimeout(function() {
        done();
      }, 1000);
    });

    it('should throw', function(done) {
      Meteor.setTimeout(function() {
        done("I'm throwing");
      }, 1000);
    });

  });

  describe('3 - Skipped test', function() {

    it.skip('3.1 - should skip test', function(done) {
      Meteor.setTimeout(function() {
        done();
      }, 1000);
    });

    it('3.2 - should skip test');
  });

  describe('4 - Uncaught exception suite', function() {

    it('should fail due to an uncaught exception', function(done) {
      setTimeout(function() {
        throw new Error("I'm an uncaught exception");
        done();
      }, 1000);
    });
  });

  describe('5 - All sync test suite', function() {

    before(function() {
      console.log('before');
    });

    after(function() {
      console.log('after');
    });

    beforeEach(function() {
      console.log('beforeEach');
    });

    afterEach(function() {
      console.log('afterEach');
    });

    it('passing', function() {
      expect(true).to.be["true"];
    });

    it('throwing', function() {
      expect(false).to.be["true"];
    });
  });

  describe('6 - All async test suite', function() {

    before(function(done) {
      this.keepContext = true;
      console.log('before');
      Meteor.defer(function() {
        done();
      });
    });

    after(function(done) {
      console.log('after');
      Meteor.setTimeout((function() {
        done();
      }), 500);
    });
    beforeEach(function(done) {
      console.log('beforeEach');
      Meteor.setTimeout((function() {
        done();
      }), 500);
    });
    afterEach(function(done) {
      console.log('afterEach');
      this.timeout(1000);
      Meteor.setTimeout((function() {
        done();
      }), 500);
    });

    this.timeout(5000);

    it('passing', function(done) {
      expect(this.keepContext).to.be["true"];
      Meteor.setTimeout((function() {
        done();
      }), 2500);
    });

    it('throwing', function(done) {
      Meteor.defer(function() {
        done(new Error('failing'));
      });
    });
  });

  describe('7 - implicit wait', function() {

    it('during findOne', function() {
      var doc;
      return doc = TestCollection.findOne({
        _id: 'xxx'
      });
    });

  });

  describe.skip('8 - skip suite', function() {
    it("this won't run", function() {
      throw new Error("This is an error");
    });
  });

  describe("9 -  before and after hooks errors", ()=> {

    before(()=> {
      throw new Error("Error from before");
    });

    it("It hooks with errors", ()=> {
      throw new Error("This will not throw")
    });

    after(()=> {
      throw new Error("Error from after");
    });

  });

  describe("10 - beforeEach and afterEach hooks errors", ()=> {

    beforeEach(()=> {
      throw new Error("Error from beforeEach");
    });

    it("It hooks with errors", ()=> {
      throw new Error("This will not throw")
    });

    afterEach(()=> {

      throw new Error("Error from afterEach");
    });

  });

  describe("11 - Specify", function() {

    specify("it works", function() {
      expect(true).to.be.true;
    });

    xspecify("Skip: This won't run", function() {
      throw new Error("This won't run")
    });

  });

  context("12 - Context test", function() {
    it("it works", function() {
      expect(true).to.be.true;
    });
  });

  xcontext("12 - Skip suite (xcontext)", function() {

    it("This won't run", function() {
      throw new Error("This won't run")
    })

  });

  describe("13 - Promises", ()=> {

    it("Handle promises", ()=> {
      return new Promise((resolve, reject) => {
        expect(true).to.be.true
        resolve(true)
      })
    });

    it('Handle promises errors', function() {
      return new Promise((resolve, reject) => {
        reject(new Error('fails-just-fine'))
      })
    })

  });
}