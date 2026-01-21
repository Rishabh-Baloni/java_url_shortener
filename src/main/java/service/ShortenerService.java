package service;

import repository.UrlRepository;
import java.net.URL;

public class ShortenerService {
    private final UrlRepository repository;
    public ShortenerService(UrlRepository repository) {
        this.repository = repository;
    }
    public String createShortCode(String longUrl) throws Exception {
        if (longUrl == null || longUrl.trim().isEmpty()) throw new IllegalArgumentException("Invalid URL");
        try { new URL(longUrl.trim()); } catch (Exception e) { throw new IllegalArgumentException("Invalid URL"); }
        long id = repository.saveLongUrl(longUrl.trim());
        String code = Base62Encoder.encode(id);
        repository.updateShortCode(id, code);
        return code;
    }
    public String resolveAndIncrement(String shortCode) throws Exception {
        if (shortCode == null || shortCode.trim().isEmpty()) return null;
        String longUrl = repository.findLongUrlByCode(shortCode.trim());
        if (longUrl != null) repository.incrementClicks(shortCode.trim());
        return longUrl;
    }
}
