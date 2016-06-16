#!/bin/bash -x

export PHANTHOMJS_SCRIPT="$REPO_HOME/meteor/tests/phantomjs-script-tests.js"
export TEST_FILE="$REPO_HOME/meteor/tests/tests.html"
export SPACEJAM_COMMAND="--phantomjs-script $PHANTHOMJS_SCRIPT  --driver-package practicalmeteor:mocha"

function verifyStatus {
  EXIT_STATUS=0
  if [ "$1" -ne "0" ]
    then
    if [ -n "$TRAVIS_BUILD_DIR" ]
      then
      echo "Test failed printing compare file."
      cat "$TEST_FILE.compare"
      echo "End compare file."
    else
      echo "Test failed creating compare file."
      cat "$TEST_FILE.compare" >> "$(dirname $TEST_FILE)/$2".compare.html
    fi
    EXIT_STATUS="$1"
  fi
  return ${EXIT_STATUS}
}

cd $REPO_HOME
spacejam test-packages ./
EXIT_STATUS="$?"

cd "$REPO_HOME/meteor/test-app"
spacejam test $(echo $SPACEJAM_COMMAND)
EXIT_STATUS=$(verifyStatus "$?" "test-app-parallel")

cd "$REPO_HOME/meteor/test-app"
MOCHA_RUN_ORDER='serial'
spacejam test $(echo $SPACEJAM_COMMAND)
EXIT_STATUS=$(verifyStatus "$?" "test-app-parallel")

cd "$REPO_HOME/meteor/test-app"
MOCHA_RUN_ORDER='parallel'
spacejam test --full-app $(echo $SPACEJAM_COMMAND)
EXIT_STATUS=$(verifyStatus "$?" "test-app-parallel")

cd "$REPO_HOME/meteor/test-app"
MOCHA_RUN_ORDER='serial'
spacejam test --full-app $(echo $SPACEJAM_COMMAND)
EXIT_STATUS=$(verifyStatus "$?" "test-app-parallel")

cd "$REPO_HOME/meteor/test-app/packages/test-package"
MOCHA_RUN_ORDER='parallel'
spacejam test-packages $(echo $SPACEJAM_COMMAND) ./
EXIT_STATUS=$(verifyStatus "$?" "test-app-parallel")

cd "$REPO_HOME/meteor/test-app/packages/test-package"
MOCHA_RUN_ORDER='serial'
spacejam test-packages $(echo $SPACEJAM_COMMAND) ./
EXIT_STATUS=$(verifyStatus "$?" "test-app-parallel")

exit $EXIT_STATUS