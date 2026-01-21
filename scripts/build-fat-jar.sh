#!/usr/bin/env bash
set -euo pipefail
mkdir -p build/classes
javac -encoding UTF-8 -cp "lib/*" -d build/classes $(find src/main/java -name '*.java')
rm -rf build/fat
mkdir -p build/fat
cp -r build/classes/* build/fat/
mkdir -p build/fat/src/main/webapp
cp -r src/main/webapp/* build/fat/src/main/webapp/
rm -rf build/tmpdeps
mkdir -p build/tmpdeps
# extract dependencies using JDK's jar tool (avoids relying on unzip)
for j in lib/*.jar; do
  bn=$(basename "$j")
  mkdir -p "build/tmpdeps/$bn"
  (cd "build/tmpdeps/$bn" && jar xf "$j")
done
cp -r build/tmpdeps/* build/fat/
echo "Main-Class: app.Main" > build/manifest.mf
(cd build/fat && jar cfm ../../app.jar ../manifest.mf -C . .)
echo "Built app.jar"
