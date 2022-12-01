#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    exit 255
fi

mkdir -p target/classes

printf -v NUM '%02d' $1

if [ Advent$NUM.scala -nt target/classes/Advent$NUM.class ]; then
  echo "Compiling Advent$NUM.scala..."
  scala3-compiler -deprecation -d target/classes AdventApp.scala Advent$NUM.scala
  if [ $? != 0 ]; then
      exit $?
  fi
fi

echo "Running Advent$NUM..."
COURSCACHE=$HOME/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2
SCALALIB3=$COURSCACHE/org/scala-lang/scala3-library_3/3.1.0/scala3-library_3-3.1.0.jar
SCALALIB2=$COURSCACHE/org/scala-lang/scala-library/2.13.7/scala-library-2.13.7.jar
time java -cp $SCALALIB3:$SCALALIB2:target/classes Advent$NUM
