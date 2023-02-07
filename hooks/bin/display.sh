#!/bin/bash

display()
{
  type=$1
  shift
  case $type in
      title)
          echo -ne "\e[1;33m$@\e[m : "
          ;;
      info)
          echo -e "\e[1;32m$@\e[m"
          ;;
      success)
          echo -e "\e[1;32m$@\e[m"
          ;;
      warning)
          echo -e "\e[1;33m$@\e[m"
          ;;
      error)
          echo -e "\e[1;31m$@\e[m"
          ;;
      *)
          echo -e "\e[1;31mUnknown display type\e[m"
          ;;
  esac
}
