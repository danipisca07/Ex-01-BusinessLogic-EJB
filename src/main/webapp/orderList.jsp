<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Set" %>
<%@ page import="it.distributedsystems.model.dao.*" %><%--
  Created by IntelliJ IDEA.
  User: Fisso
  Date: 24/01/2020
  Time: 23:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%!
    String printTableRow(OrderVoice orderVoice, String url) {
        StringBuffer html = new StringBuffer();
        Product product = orderVoice.getProduct();
        html
                .append("<tr>")
                .append("<td>")
                .append(product.getName())
                .append("</td>")

                .append("<td>")
                .append(product.getProductNumber())
                .append("</td>")

                .append("<td>")
                .append( (product.getProducer() == null) ? "n.d." : product.getProducer().getName() )
                .append("</td>")

                .append("<td>")
                .append( product.getPrice() + "€" )
                .append("</td>")

                .append("<td>")
                .append( orderVoice.getQuantity() )
                .append("</td>");

        html
                .append("</tr>");

        return html.toString();
    }

    String printTableRows(Set products, String url) {
        StringBuffer html = new StringBuffer();
        Iterator iterator = products.iterator();
        while ( iterator.hasNext() ) {
            html.append( printTableRow( (OrderVoice) iterator.next(), url ) );
        }
        return html.toString();
    }


%>
<html>
<head>
    <title>Orders List</title>
</head>
<body>
    <%
        DAOFactory daoFactory = DAOFactory.getDAOFactory(application.getInitParameter("dao"));
        PurchaseDAO purchaseDAO = daoFactory.getPurchaseDAO();
        CustomerDAO customerDAO = daoFactory.getCustomerDAO();

        List<Purchase> purchases;
        Object customerId = session.getAttribute("customerId");
        Customer customer = (customerId == null) ? null : customerDAO.findCustomerById((int)customerId);
        if(customer!= null) {
            purchases = purchaseDAO.findAllPurchasesByCustomer(customer);
            out.print("<a href=\"./newOrder.jsp\">New Order</a>");
            out.print("<a href=\"./logout.jsp\">Logout</a>");

        }
        else {
            purchases = purchaseDAO.getAllPurchases();
            out.print("<a href=\"./login.jsp\">Login</a>");
        }
    %>

    <div>
        <p>Orders:</p>
        <%
            Iterator purchasesIterator = purchases.iterator();
            while(purchasesIterator.hasNext()){
                Purchase purchase = (Purchase) purchasesIterator.next();
                %>
        <p>Order id:<%=purchase.getId()%> customer:<%=purchase.getCustomer().getName()%> purchaseNumber:<%=purchase.getPurchaseNumber()%> items:<%=purchase.getOrderVoices().size()%></p>
                <table border="1">
                    <tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th>Price</th><th>Quantity</th></tr>
                    <%= printTableRows( purchase.getOrderVoices(), request.getContextPath() ) %>
                </table>
        <%
            }
        %>

    </div>
</body>
</html>
