<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>URL Shortener</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>URL Shortener</h1>
        <form method="post" action="/shorten">
            <input type="url" name="longUrl" placeholder="Enter long URL" required>
            <button type="submit">Shorten</button>
        </form>
        <div class="message">
            <%
                Object err = request.getAttribute("error");
                if (err != null) {
                    out.print("<p class=\"error\">" + err.toString() + "</p>");
                }
            %>
        </div>
    </div>
</body>
</html>

