// Using the "wrapper package" version format
Package.describe({
  name: "test-package",
  summary: "Test package for the mocha package"
});


Package.onUse(function (api) {
  api.versionsFrom('1.3');

  api.use([
    'meteor',
    'mongo',
    'coffeescript',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    "ecmascript"
  ]);

  api.mainModule("index.js")

});

Package.onTest(function (api) {
  api.use([
    'coffeescript',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'practicalmeteor:mocha@=2.4.5-rc3.3',
    'ecmascript',
    'test-package'
  ]);

  api.addFiles('tests/server.test.js', 'server');
  api.addFiles('tests/client.test.js', 'client');
  api.addFiles('tests/both.test.js');
  api.addFiles('tests/globals.test.js');
});
