#!/bin/bash

# loading all hooks helper
source ./hooks/bin/display.sh
source ./hooks/bin/php_wrapper.sh

# Unit Tests running
PHPUNIT=0
php_wrapper bin/phpunit
PHPUNIT=$?

if [[ ${PHPUNIT} -ne 0 ]]
then
    display error "Your code need to be checked, PHPUnit failed (code ${PHPUNIT})"
    exit 1
fi
