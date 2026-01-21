<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shorten URL | Fast & Clean</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="main-container">
        <div class="card">
            <div class="header">
                <h1>Shorten Your Links</h1>
                <p class="subtitle">Paste a long URL below to create a short, shareable link instantly.</p>
            </div>
            
            <form method="post" action="/shorten" id="shortenForm">
                <div class="form-group">
                    <input type="url" name="longUrl" placeholder="Paste a long URL here..." required autofocus>
                    <button type="submit" class="btn" id="submitBtn">Shorten URL</button>
                </div>
            </form>

            <%
                Object err = request.getAttribute("error");
                if (err != null) {
            %>
                <div class="error-message visible">
                    <%= err.toString() %>
                </div>
            <%
                }
            %>
        </div>

        <div class="footer">
            Built with Java • Servlets • JSP • PostgreSQL • Deployed on Render
        </div>
    </div>

    <script>
        document.getElementById('shortenForm').addEventListener('submit', function(e) {
            const btn = document.getElementById('submitBtn');
            btn.disabled = true;
            btn.textContent = 'Shortening...';
            // Form continues to submit normally
        });
    </script>
</body>
</html>
