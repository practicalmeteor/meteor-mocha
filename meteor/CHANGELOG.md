# 2.4.5_6

- Add `ConsoleReporter` and `XunitReporter`.
- Run rests on `runTests` functions. Fixes [#59](https://github.com/practicalmeteor/meteor-mocha/issues/51)

# 2.4.5_5

- Fix bug when running on linux. [More details](https://github.com/practicalmeteor/meteor-mocha/issues/51)

# 2.4.5_4

- Fix bug related to firing 'end all' mocha runner event. [More details](https://github.com/practicalmeteor/meteor-mocha-console-runner/issues/6)

# 2.4.5_3

- Bug fixes (more details below) - [#42](https://github.com/practicalmeteor/meteor-mocha/issues/42), [#44](https://github.com/practicalmeteor/meteor-mocha/issues/44), [#45](https://github.com/practicalmeteor/meteor-mocha/issues/45),

- Add an acceptance test that includes most mocha test scenarios by verifying that the actual html produced by the reporter matches the expected one. The acceptance test runs both `meteor test`, `meteor test --full-app` and `meteor test-packages` and runs in ci.

- Move dependency on mocha to mocha-core, and depend on mocha's npm
package, instead of the forked source code - fixes [#23](https://github.com/practicalmeteor/meteor-mocha/issues/23) - conflict with dispatch:mocha-phantomjs

- Properly support promises returned from mocha functions - fixes [#44](https://github.com/practicalmeteor/meteor-mocha/issues/44)

- Only use meteor's node stubs client side - fixes [#45](https://github.com/practicalmeteor/meteor-mocha/issues/45)

- Wrap the server test results publication's added function with fibers support - fixes [#42](https://github.com/practicalmeteor/meteor-mocha/issues/42)
