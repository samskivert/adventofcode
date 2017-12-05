#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    exit 255
fi

mkdir -p target/classes

printf -v NUM '%02d' $1

if [ Advent$NUM.scala -nt target/classes/Advent$NUM.class ]; then
  echo "Compiling Advent$NUM.scala..."
  scalac -deprecation -d target/classes AdventApp.scala Advent$NUM.scala
  if [ $? != 0 ]; then
      exit $?
  fi
fi

echo "Running Advent$NUM..."
time scala -cp target/classes Advent$NUM
