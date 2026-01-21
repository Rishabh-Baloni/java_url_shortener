# URL Shortener (Pure Java)

A clean, interview-ready Java web project that implements a URL shortener using Servlets + JSP, Embedded Tomcat, and PostgreSQL via JDBC. Clear, correct, and minimal by design.

## Problem Statement
- Input a long URL and generate a deterministic short code.
- Persist mappings in PostgreSQL and redirect short codes to original URLs.
- Track click count.
- Keep implementation simple and explainable.

## Tech Stack
- Java 8+
- Servlets + JSP
- Embedded Tomcat
- PostgreSQL (managed)
- JDBC (pgJDBC)

## Features
- Shorten long URL to Base62 short code
- Redirect `/r/{shortCode}` to original URL
- Click counter increment on each redirect
- Minimal JSP UI (index + result) with basic CSS

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
database.sql
lib/  (3rd-party jars downloaded here)
scripts/
  build-fat-jar.sh
  build-fat-jar.ps1
```

## Database Schema
Apply `database.sql` to your PostgreSQL database:
```
CREATE TABLE IF NOT EXISTS urls (
  id SERIAL PRIMARY KEY,
  short_code VARCHAR(255) UNIQUE,
  long_url TEXT NOT NULL,
  clicks INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_urls_short_code ON urls(short_code);
```

## Configuration (Environment Variables)
- `PORT` (required by Render; defaults to 8080 locally)
- `DB_URL` (e.g. `jdbc:postgresql://<host>:5432/<db>`)
- `DB_USER`
- `DB_PASSWORD`

## Build and Run Locally
1) Download deps to `lib/` (already included in this folder):
   - tomcat-embed-core, tomcat-embed-el, tomcat-embed-jasper, ecj, javax.servlet-api, postgresql

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
```
export PORT=8080
export DB_URL="jdbc:postgresql://<host>:5432/<db>"
export DB_USER="<user>"
export DB_PASSWORD="<password>"
java -jar app.jar
```
Open `http://localhost:8080/index.jsp`

## Render Deployment
- Build Command:
  ```
  ./scripts/build-fat-jar.sh
  ```
- Start Command:
  ```
  java -jar app.jar
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

