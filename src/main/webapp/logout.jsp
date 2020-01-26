<%--
  Created by IntelliJ IDEA.
  User: Fisso
  Date: 26/01/2020
  Time: 23:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logout</title>
</head>
<body>
    <%
        session.invalidate();
        response.sendRedirect("login.jsp");
    %>
</body>
</html>
