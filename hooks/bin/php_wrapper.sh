#!/bin/bash

php_wrapper()
{
  if command -v symfony &> /dev/null
  then
      echo -ne "Using symfony php, "
      symfony php "$@"
      return $?
  fi

  if [[ -f ".php-version" ]]
  then
      version=$(cat .php-version)

      if [[ -f "/usr/bin/php$version" ]]
      then
          echo -ne "Using /usr/bin/php$version, "
          /usr/bin/php$version "$@"
          return $?
      fi

      if [[ -f "/usr/local/bin/php$version" ]]
      then
          echo -ne "Using /usr/local/bin/php$version, "
          /usr/local/bin/php$version "$@"
          return $?
      fi

      systemVersion=$(php -v 2>/dev/null | grep -o -E "PHP [0-9]+\.[0-9]+" | grep -o -E "[0-9]+\.[0-9]+")

      if [[ "$systemVersion" == "" ]]
      then
          echo -e "\n\e[1;31mphp: command not found, please install \e[1;33mphp$version\e[1;31m and try again.\e[m"
          return 127
      fi

      if [[ "$systemVersion" == "$version" ]]
      then
          echo -ne "Using system PHP, "
          php "$@"
          return $?
      else
          echo -e "\n\e[1;31mYour PHP system version is $systemVersion, please install \e[1;33mphp$version\e[1;31m and try again.\e[m"
          return 94
      fi
  fi

  if [[ -f ".phpenv" ]]
  then
      version=$(cat .phpenv)
      if command -v phpenv &> /dev/null
      then
          echo -ne "Using phpenv, "
          phpenv local $version

          systemVersion=$(php -v 2>/dev/null | grep -o -E "PHP [0-9]+\.[0-9]+\.[0-9]+" | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+")

          if [[ "$systemVersion" == "" ]]
          then
              echo -e "\n\e[1;31mphp: command not found, please install \e[1;33mphp$version\e[1;31m and try again.\e[m"
              return 127
          fi

          if [[ "$systemVersion" == "$version" ]]
          then
              echo -ne "Using php, "
              php "$@"
              return $?
          else
              echo -e "\n\e[1;31mYour PHP system version is $systemVersion, please install \e[1;33mphp$version\e[1;31m and try again.\e[m"
              return 1
          fi

          return 2
      fi

  fi
}
