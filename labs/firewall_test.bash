#!/bin/bash

points=0

echo "Testing connectivity to 1.1.1.1..."
ping -c 2 1.1.1.1 > /dev/null
if [ $? -eq 0 ]
then
    echo "Connection to 1.1.1.1: Passed"
else
    echo "Connection to 1.1.1.1: Failed"
    points=$((points+1))
fi

echo "Testing connectivity to 8.8.8.8..."
ping -c 2 8.8.8.8 > /dev/null
if [ $? -eq 0 ]
then
    echo "Connection to 8.8.8.8: Passed"
else
    echo "Connection to 8.8.8.8: Failed"
    points=$((points+1))
fi

echo "You earned $points point(s) out of 1."
