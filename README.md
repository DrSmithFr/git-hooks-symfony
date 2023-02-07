# Git Hooks for Symfony

 Enforce coding standards and best practices in your Symfony project with Git Hooks.

## Installation 

  - Copy-Paste the repo content in your project root
  - Merge the content of `.gitignore` with your project `.gitignore`
  - Merge the content of Makefile with your project Makefile
  - Enable Git Hooks in your project using `make git_hooks`

## Coding style and Standards

- [PSR-2 coding standards](documentation/php/PSR/PSR-2-coding-style-guide.md) for all php files.
- [PHP mess detector](https://phpmd.org/rules/index.html).
- [PHPdoc standard](documentation/php/phpdoc.md).
- [functional programing](https://www.youtube.com/watch?v=BMUiFMZr7vk&list=PL0zVEGEvSaeEd9hlmCXrk5yUyqUag-n84) Avoid State mutation

## Auto-detection PHP version

  - Use SymfonyCLI (if installed) to detect the PHP version used by the project
  - Use .php-version file (if exists) to detect the PHP version used by the project (can be used with without SymfonyCLI)
  - Use .phpenv file (if exists) to detect the PHP version used by the project (if you use phpenv)
  - Fall back to the default PHP version

## Pre-commit checks

  - Check for forgotten merge conflicts
  - Check for forgotten `var_dump()` or `dump()` functions
  - Check for forgotten `console.log()` functions
  - Check for PHP syntax errors (if phpcs is installed)
  - Check for PHP logical errors (if phpmd is installed)
  - Run phpunit tests (if phpunit is installed)

## Pre-push checks

  - Run phpunit tests (if phpunit is installed)

## phpunit tests bootstrap

  -  Will reset the cache before each test
  -  Will reset the database before each test
  -  Will reload the fixtures before each test