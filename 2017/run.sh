#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    exit 255
fi

mkdir -p target/classes

printf -v NUM '%02d' $1

if [ Advent$NUM.scala -nt target/classes/Advent$NUM.class ]; then
  echo "Compiling Advent$NUM.scala..."
  dotc -deprecation -d target/classes AdventApp.scala Advent$NUM.scala
  if [ $? != 0 ]; then
      exit $?
  fi
fi

echo "Running Advent$NUM..."
IVYCACHE=$HOME/.ivy2/cache
DOTSCLIB=$IVYCACHE/ch.epfl.lamp/scala-library/jars/scala-library-0.5.0-RC1.jar
DOTTYLIB=$IVYCACHE/ch.epfl.lamp/dotty-library_0.5/jars/dotty-library_0.5-0.5.0-RC1.jar
SCALALIB=$IVYCACHE/org.scala-lang/scala-library/jars/scala-library-2.12.4.jar
time java -cp $DOTSCLIB:$DOTTYLIB:$SCALALIB:target/classes Advent$NUM
