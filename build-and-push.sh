#!/bin/sh
docker build . -t swiftmade/laravel-test-container:7.4
docker push swiftmade/laravel-test-container:7.4
docker run --rm swiftmade/laravel-test-container:7.4 /bin/bash -c "php -v && echo $'\n' && composer --version && echo $'\n' && php -m"