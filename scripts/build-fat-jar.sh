#!/usr/bin/env bash
set -euo pipefail
mkdir -p lib
download() {
  url="$1"; out="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$out"
  else
    mkdir -p build/downloader
    cat > build/downloader/Downloader.java <<'EOF'
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
public class Downloader {
  public static void main(String[] args) throws Exception {
    URL u = new URL(args[0]);
    try (InputStream in = u.openStream()) {
      Path p = Paths.get(args[1]);
      if (p.getParent() != null) Files.createDirectories(p.getParent());
      Files.copy(in, p, StandardCopyOption.REPLACE_EXISTING);
    }
  }
}
EOF
    javac -d build/downloader build/downloader/Downloader.java
    java -cp build/downloader Downloader "$url" "$out"
  fi
}
download https://repo1.maven.org/maven2/org/apache/tomcat/embed/tomcat-embed-core/9.0.112/tomcat-embed-core-9.0.112.jar lib/tomcat-embed-core-9.0.112.jar
download https://repo1.maven.org/maven2/org/apache/tomcat/embed/tomcat-embed-el/9.0.112/tomcat-embed-el-9.0.112.jar lib/tomcat-embed-el-9.0.112.jar
download https://repo1.maven.org/maven2/org/apache/tomcat/embed/tomcat-embed-jasper/9.0.112/tomcat-embed-jasper-9.0.112.jar lib/tomcat-embed-jasper-9.0.112.jar
download https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar lib/javax.servlet-api-4.0.1.jar
download https://repo1.maven.org/maven2/javax/annotation/javax.annotation-api/1.3.2/javax.annotation-api-1.3.2.jar lib/javax.annotation-api-1.3.2.jar
download https://repo1.maven.org/maven2/org/eclipse/jdt/ecj/3.40.0/ecj-3.40.0.jar lib/ecj-3.40.0.jar
download https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.9/postgresql-42.7.9.jar lib/postgresql-42.7.9.jar
mkdir -p build/classes
javac -encoding UTF-8 -cp "lib/*" -d build/classes $(find src/main/java -name '*.java')
rm -rf build/fat
mkdir -p build/fat
cp -r build/classes/* build/fat/
mkdir -p build/fat/src/main/webapp
cp -r src/main/webapp/* build/fat/src/main/webapp/
echo "Main-Class: app.Main" > build/manifest.mf
(cd build/fat && jar cfm ../../app.jar ../manifest.mf -C . .)
echo "Built app.jar"
