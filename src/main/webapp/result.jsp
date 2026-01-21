<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Short URL</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Short URL</h1>
        <%
            String shortUrl = (String) request.getAttribute("shortUrl");
            if (shortUrl != null) {
        %>
            <p>Your short URL:</p>
            <p><a href="<%= shortUrl %>"><%= shortUrl %></a></p>
        <%
            } else {
        %>
            <p class="error">No URL generated</p>
        <%
            }
        %>
        <p><a href="/index.jsp">Create another</a></p>
    </div>
</body>
</html>

