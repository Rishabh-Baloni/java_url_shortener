package controller;

import service.ShortenerService;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;
import java.io.IOException;

public class ShortenServlet extends HttpServlet {
    private final ShortenerService service;
    public ShortenServlet(ShortenerService service) {
        this.service = service;
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String longUrl = req.getParameter("longUrl");
        try {
            String code = service.createShortCode(longUrl);
            String shortUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + "/r/" + code;
            req.setAttribute("shortUrl", shortUrl);
            RequestDispatcher rd = req.getRequestDispatcher("/result.jsp");
            rd.forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Invalid input or server error");
            RequestDispatcher rd = req.getRequestDispatcher("/index.jsp");
            rd.forward(req, resp);
        }
    }
}

