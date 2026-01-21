package controller;

import service.ShortenerService;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;

public class RedirectServlet extends HttpServlet {
    private final ShortenerService service;
    public RedirectServlet(ShortenerService service) {
        this.service = service;
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        String code = path != null && path.length() > 1 ? path.substring(1) : null;
        try {
            String longUrl = service.resolveAndIncrement(code);
            if (longUrl == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Short code not found");
            } else {
                resp.sendRedirect(longUrl);
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Server error");
        }
    }
}

