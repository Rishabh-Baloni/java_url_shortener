package repository;

import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UrlRepository {
    public long saveLongUrl(String longUrl) throws Exception {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement("INSERT INTO urls(long_url, clicks) VALUES (?, 0) RETURNING id")) {
            ps.setString(1, longUrl);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new IllegalStateException("Insert failed");
    }
    public void updateShortCode(long id, String code) throws Exception {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement("UPDATE urls SET short_code = ? WHERE id = ?")) {
            ps.setString(1, code);
            ps.setLong(2, id);
            ps.executeUpdate();
        }
    }
    public String findLongUrlByCode(String code) throws Exception {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement("SELECT long_url FROM urls WHERE short_code = ?")) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        }
        return null;
    }
    public void incrementClicks(String code) throws Exception {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement("UPDATE urls SET clicks = clicks + 1 WHERE short_code = ?")) {
            ps.setString(1, code);
            ps.executeUpdate();
        }
    }
}

