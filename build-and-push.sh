#!/bin/sh
docker build . -t swiftmade/laravel-test-container:7.4
docker push swiftmade/laravel-test-container:7.4
docker run swiftmade/laravel-test-container:7.4 php -m