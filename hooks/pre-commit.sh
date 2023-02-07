#!/bin/bash

# loading all hooks helper
source ./hooks/bin/ask.sh
source ./hooks/bin/display.sh
source ./hooks/bin/git.sh
source ./hooks/bin/php_wrapper.sh

# get all modified files array
FILES=$(git_modified_files $(git_current_commit))


display title "Checking files for merge conflicts"
./hooks/src/check-merge-tags.sh ${FILES}
if [[ $? -ne 0 ]]
then
  display error "Your code need to be checked (Merge tags found)"
  exit 1
fi

display title "Checking files for forgotten dump()"
./hooks/src/check-dump.sh ${FILES}
if [[ $? -ne 0 ]]
then
  display error "Your code need to be checked (Dump tags found)"
  exit 1
fi

display title "Checking files for forgotten console.log()"
./hooks/src/check-console-log.sh ${FILES}
if [[ $? -ne 0 ]]
then
  display error "Your code need to be checked (Console.log found)"
  exit 1
fi

# getting all php files affected by commit
PHPs=$(git_modified_files_by_ext "php" ${FILES})

PHPCS=0
if [[ -f "./vendor/bin/phpcs" ]]
then
  if [[ "$PHPs" != "" ]]
  then
      # check php syntax
      display title "Checking phpcs" && \
      php_wrapper vendor/bin/phpcs --ignore=vendor,bin,public,documentation,migrations ${PHPs} && \
      display success "PSR-2 Syntax checked"
      PHPCS=$?
  fi
else
    display warning "phpcs not found, please install it with composer"
fi

if [[ ${PHPCS} -ne 0 ]]
then
  display error "Your code need to be checked (PSR-2 Syntax errors)"
  exit 1
fi

PHPMD=0
if [[ -f "./vendor/bin/phpmd" ]]
then
  if [[ "$PHPs" != "" && -f "./vendor/bin/phpmd" ]]
  then
      display title "Checking phpmd"
      for file in $(echo "$PHPs"); do
          prompt=$(php_wrapper vendor/bin/phpmd $file ansi phpmd.xml 2>&1)
          SUBMD=$?

          if [[ ${SUBMD} -ne 0 ]]
          then
              echo -e "\n$prompt"
              PHPMD=1
          fi

          if [[ $PHPMD -eq 0 ]]
          then
              PHPMD=$SUBMD
          fi
      done

      if [[ ${PHPMD} -ne 0 ]]
      then
        echo -e "\n=============================\n"
        display error "Your code need to be checked (PHP Mess Detector exited with code ${PHPMD})"
        exit 1
      fi

      display success "PHP Logic checked"
  fi
else
    display warning "phpmd not found, please install it with composer"
fi

# Unit Tests running
PHPUNIT=0
if [[ -f "./bin/phpunit" ]]
then
    display title "Running phpunit" && \
    php_wrapper bin/phpunit && \
    display success "Unit Tests passed"
    PHPUNIT=$?
else
    display warning "phpunit not found, please install it with composer"
fi
if [[ $PHPUNIT -ne 0 ]]
then
  display error "Your code need to be checked (PHPUnit exited with code ${PHPUNIT})"
  exit 1
fi

# Post checkup validation
./hooks/src/ask-validation.sh ${FILES}
exit $?
