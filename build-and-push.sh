#!/bin/sh
docker build . -t swiftmade/laravel-test-container:8.1
docker push swiftmade/laravel-test-container:8.1
docker run --rm swiftmade/laravel-test-container:8.1 /bin/bash -c "php -v && echo $'\n' && composer --version && echo $'\n' && php -m"