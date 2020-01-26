<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="it.distributedsystems.model.dao.*" %>
<%@ page import="java.util.HashSet" %><%--
  Created by IntelliJ IDEA.
  User: Fisso
  Date: 24/01/2020
  Time: 22:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    String printTableRow(Product product, String url) {
        StringBuffer html = new StringBuffer();
        html
                .append("<form><tr>")
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
                .append("<input name=\"quantity\" value=\"1\" type=\"text\">Add</button>")
                .append("</td>")

                .append("<td>")
                .append("<button name=\"addProduct\" value=\""+product.getId()+"\" type=\"submit\">Add</button>")
                .append("</td>");

        html
                .append("</tr></form>");

        return html.toString();
    }

    String printTableRows(List products, String url) {
        StringBuffer html = new StringBuffer();
        Iterator iterator = products.iterator();
        while ( iterator.hasNext() ) {
            html.append( printTableRow( (Product) iterator.next(), url ) );
        }
        return html.toString();
    }
%>
<html>
<head>
    <title>New orderVoice</title>
</head>
<body>
    <a href="logout.jsp">Logout</a>
    <%
        DAOFactory daoFactory = DAOFactory.getDAOFactory(application.getInitParameter("dao"));
        CustomerDAO customerDAO = daoFactory.getCustomerDAO();
        ProductDAO productDAO = daoFactory.getProductDAO();

        Purchase cart = (Purchase) session.getAttribute("cart");
        int customerId = (int) session.getAttribute("customerId");

        Customer customer = customerDAO.findCustomerById(customerId);
        if(customer == null){
            response.sendRedirect("login.jsp");
        }

        String prodId = request.getParameter("addProduct");
        String q = request.getParameter("quantity");
        if(prodId != null && q != null){
            int quantity = Integer.parseInt(q);
            int id = Integer.parseInt(prodId);
            Product prod = productDAO.findProductById(id);
            if(prod != null) {
                if(cart == null) {
                    cart = new Purchase();
                    cart.setCustomer(customer);
                    cart.setOrderVoices(new HashSet<OrderVoice>());
                }
                cart.getOrderVoices().add(new OrderVoice(cart, prod, quantity));
                session.setAttribute("cart", cart);
            }
        }

        String saveOrder = request.getParameter("saveCart");
        if(saveOrder != null && cart != null){
            PurchaseDAO purchaseDAO = daoFactory.getPurchaseDAO();
            purchaseDAO.insertPurchase(cart);
            session.removeAttribute("cart");
            response.sendRedirect("orderList.jsp");

        }
        out.print("<p>Welcome customer "+ customer.getName() +"("+customer.getId()+")</p>");

        if(cart != null) {
            out.println("<table border=\"1\"><tr><th>Product</th><th>Price</th><th>Quantity</th></tr>");
            Iterator orderIterator = cart.getOrderVoices().iterator();
            while(orderIterator.hasNext()){
                OrderVoice o = (OrderVoice) orderIterator.next();
    %>
    <tr><td><%=o.getProduct().getName()%></td><td><%=o.getProduct().getPrice()%>€</td><td><%=o.getQuantity()%></td></tr>
    <%
            }
            out.println("</table>");
            out.println("<form><button name=\"saveCart\" value=\"submit\" type=\"submit\">Save Order</button></form>");
        }
    %>

    <div>
        <p>Products:</p>
        <table border="1">
            <tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th>Price</th><th>Quantity</th><th></th></tr>
            <%= printTableRows( productDAO.getAllProducts(), request.getContextPath() ) %>
        </table>
    </div>
</body>
</html>
