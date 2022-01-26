#!/usr/bin/env bash
set -e
(cd _build/html && python3 -m http.server 8999)&
while inotifywait -e modify -e moved_to -e create -qr .; do make html; done
