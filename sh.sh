#!/bin/bash
webdir = $1
if [ ! $1 ]; then
       webdir = "web"
fi
echo $webdir

