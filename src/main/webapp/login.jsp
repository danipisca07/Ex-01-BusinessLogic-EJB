<%@ page import="it.distributedsystems.model.dao.DAOFactory" %>
<%@ page import="it.distributedsystems.model.dao.CustomerDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="it.distributedsystems.model.dao.Customer" %><%--
  Created by IntelliJ IDEA.
  User: Fisso
  Date: 24/01/2020
  Time: 21:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <%
        DAOFactory daoFactory = DAOFactory.getDAOFactory(application.getInitParameter("dao"));
        CustomerDAO customerDAO = daoFactory.getCustomerDAO();

        String login = request.getParameter("login");
        if(login != null && login.equals("submit")){
            int id = Integer.parseInt(request.getParameter("customer"));
            Customer customer = customerDAO.findCustomerById(id);
            if(customer != null){
                session.setAttribute("customerId", id);
                response.sendRedirect("newOrder.jsp");
            } else {
                out.print("<p>User NOT FOUND</p>");
            }
        }
    %>

    <%
        List customers = customerDAO.getAllCustomers();
        if (customers.size() > 0) {
     %>
        <form>
            Select user:    <select name="customer">
            <%
                Iterator iterator = customers.iterator();
                while(iterator.hasNext()){
                    Customer customer = (Customer) iterator.next();
            %>
                <option value="<%=customer.getId()%>"><%=customer.getName()%></option>
            <%
                }
            %>
            </select>
            <input type="submit" name="login" value="submit"/>
        </form>
    <%
        }
        else {
    %>
        <div>
            <p> No user registered.</p>
        </div>
    <%
        }
    %>
</html>
