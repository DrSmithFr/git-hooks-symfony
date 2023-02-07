<?php

use Symfony\Component\Dotenv\Dotenv;

require dirname(__DIR__) . '/vendor/autoload.php';

if (file_exists(dirname(__DIR__) . '/config/bootstrap.php')) {
    require dirname(__DIR__) . '/config/bootstrap.php';
} elseif (method_exists(Dotenv::class, 'bootEnv')) {
    (new Dotenv())->bootEnv(dirname(__DIR__) . '/.env');
}

// deletes the database and creates it again
if (isset($_ENV['BOOTSTRAP_RESET_DATABASE'])) {
    passthru(sprintf(
        'APP_ENV=%s symfony php "%s" doctrine:database:drop --force',
        $_ENV['BOOTSTRAP_RESET_DATABASE'],
        dirname(__DIR__) . '/bin/console'
    ), $return);

    if ($return !== 0) {
        exit($return);
    }

    passthru(sprintf(
        'APP_ENV=%s symfony php "%s" doctrine:schema:update --force --complete',
        $_ENV['BOOTSTRAP_RESET_DATABASE'],
        dirname(__DIR__) . '/bin/console'
    ), $return);

    if ($return !== 0) {
        exit($return);
    }

    passthru(sprintf(
        'APP_ENV=%s symfony php "%s" doctrine:fixtures:load -n',
        $_ENV['BOOTSTRAP_RESET_DATABASE'],
        dirname(__DIR__) . '/bin/console'
    ), $return);

    if ($return !== 0) {
        exit($return);
    }
}

if (isset($_ENV['BOOTSTRAP_CLEAR_CACHE_ENV'])) {
    // executes the "php bin/console cache:clear" command
    if (
        passthru(sprintf(
            'APP_ENV=%s symfony php "%s/../bin/console" cache:clear --no-warmup',
            $_ENV['BOOTSTRAP_CLEAR_CACHE_ENV'],
            __DIR__
        )) === false
    ) {
        exit(1);
    }
}
