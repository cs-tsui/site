#!/bin/bash

rake watch &
python -m http.server 7000 -d ./site &
/usr/bin/open -a "/Applications/Firefox.app" 'http://localhost:7000'