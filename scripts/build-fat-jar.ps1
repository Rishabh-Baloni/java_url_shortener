param(
  [string]$JavaHome = $env:JAVA_HOME
)
$ErrorActionPreference = 'Stop'
if (-not $JavaHome) { $JavaHome = (Get-Command javac -ErrorAction SilentlyContinue)?.Source -replace '\\bin\\javac.exe$','' }
$javac = Join-Path $JavaHome 'bin\javac.exe'
$jar = Join-Path $JavaHome 'bin\jar.exe'
if (!(Test-Path $javac) -or !(Test-Path $jar)) { throw "JDK tools not found. Set JAVA_HOME to a JDK path." }
New-Item -ItemType Directory -Force -Path build/classes | Out-Null
$src = Get-ChildItem -Recurse src/main/java -Filter *.java | % { $_.FullName }
& $javac -encoding UTF-8 -cp "lib/*" -d build/classes $src
Remove-Item -Recurse -Force build/fat -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path build/fat | Out-Null
Copy-Item -Recurse -Force build/classes/* build/fat/
Copy-Item -Recurse -Force src/main/webapp build/fat/src/main/webapp
$tmp = "build/tmpdeps"
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
Get-ChildItem lib -Filter *.jar | % { Expand-Archive -Force -LiteralPath $_.FullName -DestinationPath $tmp }
Copy-Item -Recurse -Force $tmp/* build/fat/
New-Item -ItemType Directory -Force -Path build | Out-Null
Set-Content -Path build/manifest.mf -Value "Main-Class: app.Main`n"
Push-Location build/fat
& $jar cfm ..\..\app.jar ..\manifest.mf -C . .
Pop-Location
Write-Host "Built app.jar"

