package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection get() throws Exception {
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");
        if (url == null || user == null || pass == null) throw new IllegalStateException("Database env not set");
        return DriverManager.getConnection(url, user, pass);
    }
}

