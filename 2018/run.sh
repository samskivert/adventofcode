#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    exit 255
fi

mkdir -p target/classes

printf -v NUM '%02d' $1

DOTTY=$(dirname `which dotc`)
DOTTY=$(cd $DOTTY/.. ; pwd)

if [ Advent$NUM.scala -nt target/classes/Advent$NUM.class ]; then
  echo "Compiling Advent$NUM.scala..."
  dotc -deprecation -d target/classes AdventApp.scala Advent$NUM.scala
  if [ $? != 0 ]; then
      exit $?
  fi
fi

echo "Running Advent$NUM..."
DOTTYLIB=($DOTTY/lib/dotty-library*.jar)
SCALALIB=($DOTTY/lib/scala-library-*.jar)
time java -cp $DOTTYLIB:$SCALALIB:target/classes Advent$NUM
