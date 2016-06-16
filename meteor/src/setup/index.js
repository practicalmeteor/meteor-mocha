import { mochaInstance } from "meteor/practicalmeteor:mocha-core"
import setupMochaClient from "./setupMochaClient"

if(Meteor.isClient){
  setupMochaClient()
}
if (Meteor.isServer){
  global.mocha = mochaInstance;
}