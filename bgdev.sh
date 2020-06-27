#!/usr/bin/env bash

(cd _build/html && python3 -m http.server 8123)&
while inotifywait -r .; do make dash; done
