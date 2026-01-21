package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.net.URI;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
        } else if (url.startsWith("jdbc:postgresql://")) {
            String s = url.substring("jdbc:postgresql://".length());
            Pattern p = Pattern.compile("(?:(?<user>[^:/@]+)(?::(?<pass>[^@]+))@)?(?<host>[^/:]+)(?::(?<port>\\d+))?/(?<db>[^?]+)");
            Matcher m = p.matcher(s);
            if (m.matches()) {
                String host = m.group("host");
                String portStr = m.group("port");
                int port = portStr != null ? Integer.parseInt(portStr) : 5432;
                String db = m.group("db");
                String pu = m.group("user");
                String pp = m.group("pass");
                if ((user == null || user.isEmpty()) && pu != null) user = pu;
                if ((pass == null || pass.isEmpty()) && pp != null) pass = pp;
                url = "jdbc:postgresql://" + host + ":" + port + "/" + db;
            }
        }
        if (user == null || pass == null) throw new IllegalStateException("Database env not set");
        return DriverManager.getConnection(url, user, pass);
    }
}
