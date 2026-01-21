# URL Shortener (Pure Java)

A clean, interview-ready Java web project that implements a URL shortener using Servlets + JSP, Embedded Tomcat, and PostgreSQL via JDBC. Clear, correct, and minimal by design.

## Problem Statement
- Input a long URL and generate a deterministic short code.
- Persist mappings in PostgreSQL and redirect short codes to original URLs.
- Track click count.
- Keep implementation simple and explainable.

## Tech Stack
- Java 17/21
- Servlets + JSP
- Embedded Tomcat
- PostgreSQL (managed)
- JDBC (pgJDBC)

## Features
- Shorten long URL to Base62 short code
- Redirect `/r/{shortCode}` to original URL
- Click counter increment on each redirect
- Clean JSP UI with modern gradient background, centered card, responsive layout
- Result page with copy-to-clipboard button and optional click count

## Architecture
- JSP (UI) → Servlet (Controller) → Service (Core Logic) → JDBC Repository → PostgreSQL
- Core logic is independent of web layer.

## Base62 Explained
- Store the long URL; DB generates a numeric `id`.
- Convert `id` to Base62 using characters `a–z A–Z 0–9`.
- This is deterministic and collision-free because each `id` maps to exactly one code.

## Project Layout
```
src/main/java/
  app/Main.java
  controller/ShortenServlet.java
  controller/RedirectServlet.java
  service/Base62Encoder.java
  service/ShortenerService.java
  repository/UrlRepository.java
  util/DBConnection.java
src/main/webapp/
  index.jsp
  result.jsp
  css/style.css
lib/  (generated during build; not tracked)
scripts/
  build-fat-jar.sh
  build-fat-jar.ps1
```

## Database Schema
Created automatically on startup by `UrlRepository.ensureSchema()`.

## Configuration (Environment Variables)
- `PORT` (Render sets this; defaults to 10000 locally)
- `DB_URL` (e.g. `jdbc:postgresql://<host>:5432/<db>`)
- `DB_USER`
- `DB_PASSWORD`

## Build and Run Locally
1) Dependencies
   - Downloaded automatically into `lib/` by the build scripts (not committed to repo)

2) Build fat JAR:
   - Windows:
     ```
     ./scripts/build-fat-jar.ps1
     ```
   - Linux/macOS:
     ```
     ./scripts/build-fat-jar.sh
     ```

3) Run:
   - Windows:
     ```
     set PORT=10000
     set DB_URL=jdbc:postgresql://<host>:5432/<db>
     set DB_USER=<user>
     set DB_PASSWORD=<password>
     java -cp "app.jar;lib/*" app.Main
     ```
   - Linux/macOS:
     ```
     export PORT=10000
     export DB_URL="jdbc:postgresql://<host>:5432/<db>"
     export DB_USER="<user>"
     export DB_PASSWORD="<password>"
     java -cp "app.jar:lib/*" app.Main
     ```
Open `http://localhost:10000/index.jsp`

## Render Deployment
- Build Command:
  ```
  ./scripts/build-fat-jar.sh
  ```
- Start Command:
  ```
  java -cp app.jar:lib/* app.Main
  ```
- Environment:
  - `PORT` provided by Render
  - `DB_URL`, `DB_USER`, `DB_PASSWORD` set from Render PostgreSQL service

## Error Handling
- Invalid URL input → shown on index page
- Short code not found → 404 with simple message
- DB connection failure → 500 with simple message

## Future Improvements
- Server-side validation with better messaging
- Basic stats page (top URLs, clicks)
- Input normalization and duplicate handling

## Notes
- No Spring or extra frameworks.
- Pure Java Servlets + JSP, Embedded Tomcat, JDBC.
