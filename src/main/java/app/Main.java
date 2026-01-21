package app;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.StandardRoot;
import org.apache.catalina.webresources.JarResourceSet;
import controller.ShortenServlet;
import controller.RedirectServlet;
import repository.UrlRepository;
import service.ShortenerService;
import java.io.File;
import java.net.URLDecoder;

public class Main {
    public static void main(String[] args) throws Exception {
        int port = 8080;
        String p = System.getenv("PORT");
        if (p != null) {
            try { port = Integer.parseInt(p); } catch (Exception ignored) {}
        }
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        Context ctx = tomcat.addWebapp("", new File(".").getAbsolutePath());
        String jarPath = Main.class.getProtectionDomain().getCodeSource().getLocation().getPath();
        jarPath = URLDecoder.decode(jarPath, "UTF-8");
        StandardRoot resources = new StandardRoot(ctx);
        resources.addPreResources(new JarResourceSet(resources, "/", jarPath, "/src/main/webapp"));
        ctx.setResources(resources);
        UrlRepository repo = new UrlRepository();
        ShortenerService service = new ShortenerService(repo);
        Tomcat.addServlet(ctx, "ShortenServlet", new ShortenServlet(service));
        ctx.addServletMappingDecoded("/shorten", "ShortenServlet");
        Tomcat.addServlet(ctx, "RedirectServlet", new RedirectServlet(service));
        ctx.addServletMappingDecoded("/r/*", "RedirectServlet");
        tomcat.start();
        tomcat.getServer().await();
    }
}
