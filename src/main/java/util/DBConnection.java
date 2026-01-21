package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.net.URI;
import java.util.Objects;

public class DBConnection {
    public static Connection get() throws Exception {
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");
        if (url == null) throw new IllegalStateException("Database env not set");
        if (url.startsWith("postgres://") || url.startsWith("postgresql://")) {
            URI u = new URI(url);
            String host = u.getHost();
            int port = u.getPort() > 0 ? u.getPort() : 5432;
            String db = Objects.toString(u.getPath(), "");
            if (db.startsWith("/")) db = db.substring(1);
            String ui = u.getUserInfo();
            if ((user == null || user.isEmpty()) && ui != null) {
                int i = ui.indexOf(':');
                if (i >= 0) {
                    user = ui.substring(0, i);
                    if (pass == null || pass.isEmpty()) pass = ui.substring(i + 1);
                } else {
                    user = ui;
                }
            }
            url = "jdbc:postgresql://" + host + ":" + port + "/" + db;
        }
        if (user == null || pass == null) throw new IllegalStateException("Database env not set");
        return DriverManager.getConnection(url, user, pass);
    }
}
