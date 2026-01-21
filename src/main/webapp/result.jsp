<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Short Link</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="main-container">
        <div class="card">
            <div class="header">
                <h1>Your Short Link</h1>
                <p class="subtitle">Copy and share your new short URL.</p>
            </div>
            <%
                String shortUrl = (String) request.getAttribute("shortUrl");
                Object clicksObj = request.getAttribute("clicks");
                if (shortUrl != null) {
            %>
            <div class="result-box">
                <a class="short-link" href="<%= shortUrl %>" target="_blank" rel="noopener"><%= shortUrl %></a>
                <button type="button" class="btn btn-copy" id="copyBtn">Copy</button>
                <%
                    if (clicksObj != null) {
                %>
                <p class="subtitle">Clicks: <%= clicksObj.toString() %></p>
                <%
                    }
                %>
            </div>
            <a class="btn btn-secondary" href="/index.jsp">Shorten another</a>
            <%
                } else {
            %>
            <div class="error-message visible">No URL generated</div>
            <a class="btn btn-secondary" href="/index.jsp">Back</a>
            <%
                }
            %>
        </div>
        <div class="footer">
            Built with Java • Servlets • JSP • PostgreSQL • Deployed on Render
        </div>
    </div>
    <script>
        (function () {
            var copyBtn = document.getElementById('copyBtn');
            if (!copyBtn) return;
            copyBtn.addEventListener('click', function () {
                var linkEl = document.querySelector('.short-link');
                if (!linkEl) return;
                var text = linkEl.href || linkEl.textContent;
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text).then(function () {
                        copyBtn.textContent = 'Copied!';
                        setTimeout(function(){ copyBtn.textContent = 'Copy'; }, 1500);
                    });
                } else {
                    var input = document.createElement('input');
                    input.value = text;
                    document.body.appendChild(input);
                    input.select();
                    try { document.execCommand('copy'); } catch (e) {}
                    document.body.removeChild(input);
                    copyBtn.textContent = 'Copied!';
                    setTimeout(function(){ copyBtn.textContent = 'Copy'; }, 1500);
                }
            });
        })();
    </script>
</body>
</html>
