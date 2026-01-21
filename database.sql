CREATE TABLE IF NOT EXISTS urls (
  id SERIAL PRIMARY KEY,
  short_code VARCHAR(255) UNIQUE,
  long_url TEXT NOT NULL,
  clicks INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_urls_short_code ON urls(short_code);

