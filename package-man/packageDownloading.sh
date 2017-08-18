#!/bin/bash
ts-node ./blfsPackages.ts | xargs -n1 -i wget {} -c -P '../tarballs'
