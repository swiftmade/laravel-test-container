#!/bin/sh
docker build . -t swiftmade/laravel-test-container:7.2
docker push swiftmade/laravel-test-container:7.2
docker run swiftmade/laravel-test-container:7.2 php -m