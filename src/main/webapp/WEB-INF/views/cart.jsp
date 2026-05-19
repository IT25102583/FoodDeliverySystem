<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.CartItem" %>
<%@ page import="java.util.List" %>
<%--
    cart.jsp  –  Customer cart view.

    MUST only be reached via CartServlet (GET /cart) which sets these attributes:
        cartItems   : List<CartItem>  – current cart contents
        grandTotal  : double          – sum of all line-totals
        orderPlaced : boolean         – true immediately after a successful order

    All mutations POST to /cart with a hidden "action" field (Post-Redirect-Get).
--%>
<%
    List<CartItem> cartItems   = (List<CartItem>) request.getAttribute("cartItems");
    double         grandTotal  = (Double)         request.getAttribute("grandTotal");
    boolean        orderPlaced = Boolean.TRUE.equals(request.getAttribute("orderPlaced"));

    int totalItems = 0;
    if (cartItems != null) {
        for (CartItem ci : cartItems) totalItems += ci.getQuantity();
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Your Cart | Food Delivery</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans min-h-screen pb-16">

<%-- ── HEADER ──────────────────────────────────────────────────────────────── --%>
<nav class="bg-black text-white p-4 shadow-md flex justify-between items-center sticky top-0 z-50">
    <div class="text-2xl font-bold tracking-tight">
        UberEats <span class="text-green-500">Cart</span>
    </div>
    <a href="<%= contextPath %>/menu.jsp"
       class="bg-white text-black hover:bg-gray-100 px-4 py-2 rounded text-sm font-bold transition">
        ← Back to Menu
    </a>
</nav>

<%-- ── SUCCESS OVERLAY ────────────────────────────────────────────────────── --%>
<% if (orderPlaced) { %>
<div class="fixed inset-0 bg-white/95 z-50 flex flex-col items-center justify-center text-center px-8">
    <div class="text-7xl mb-6">🎉</div>
    <h2 class="text-4xl font-extrabold text-green-600 mb-3">Order Placed!</h2>
    <p class="text-gray-500 text-lg mb-8">
        Your food is being prepared.<br/>Estimated delivery: 30–45 mins.
    </p>
    <a href="<%= contextPath %>/menu.jsp"
       class="bg-black text-white font-bold py-3 px-10 rounded-xl text-base hover:bg-green-600 transition">
        Order More Food
    </a>
</div>
<% } %>

<%-- ── MAIN ─────────────────────────────────────────────────────────────────── --%>
<div class="max-w-3xl mx-auto px-6 pt-10">

    <h1 class="text-3xl font-bold text-gray-900 mb-1">Your <span class="text-green-500">Cart</span></h1>
    <p class="text-gray-500 text-sm mb-8">Review your items and place your order.</p>

    <%-- ── SECTION HEADER ─────────────────────────────────────────────────── --%>
    <div class="flex items-center justify-between mb-4">
        <span class="text-xs font-bold uppercase tracking-widest text-gray-400">Order Items</span>
        <span class="bg-green-100 text-green-700 text-xs font-bold px-3 py-1 rounded-full">
            <%= totalItems %> item<%= totalItems != 1 ? "s" : "" %>
        </span>
    </div>

    <%-- ── EMPTY STATE ─────────────────────────────────────────────────────── --%>
    <% if (cartItems == null || cartItems.isEmpty()) { %>
    <div class="text-center py-24 text-gray-400">
        <div class="text-6xl mb-4">🛒</div>
        <p class="text-xl font-semibold text-gray-600 mb-2">Your cart is empty!</p>
        <a href="<%= contextPath %>/menu.jsp"
           class="mt-4 inline-block bg-black text-white font-bold py-3 px-8 rounded-xl hover:bg-green-600 transition text-sm">
            Browse Menu
        </a>
    </div>
    <% } else { %>

    <%-- ── CART ITEM LIST ─────────────────────────────────────────────────── --%>
    <% for (CartItem item : cartItems) {
           String name        = item.getName();
           double price       = item.getPrice();
           int    qty         = item.getQuantity();
           double lineTotal   = item.getTotal();
           int    decremented = Math.max(1, qty - 1);
           int    incremented = qty + 1;
    %>
    <div class="bg-white border border-gray-200 rounded-2xl p-5 mb-4 flex items-center gap-4
                hover:border-green-400 hover:shadow-md transition">

        <%-- Emoji placeholder --%>
        <div class="text-4xl flex-shrink-0">🍽️</div>

        <%-- Name + unit price --%>
        <div class="flex-1 min-w-0">
            <div class="font-bold text-gray-900 truncate"><%= name %></div>
            <div class="text-gray-400 text-xs mt-0.5">
                Rs. <%= String.format("%.2f", price) %> each
                &nbsp;·&nbsp; <%= item.getCategory() %>
            </div>
        </div>

        <%-- Qty stepper – each button is its own tiny form (avoids a JS dependency) --%>
        <div class="flex items-center border border-gray-200 rounded-xl overflow-hidden flex-shrink-0">
            <form method="post" action="<%= contextPath %>/cart" style="margin:0">
                <input type="hidden" name="action"   value="update"/>
                <input type="hidden" name="name"     value="<%= name %>"/>
                <input type="hidden" name="quantity" value="<%= decremented %>"/>
                <button type="submit" class="w-9 h-9 bg-gray-50 hover:bg-green-50 text-lg font-bold
                                             text-gray-600 hover:text-green-600 transition">−</button>
            </form>
            <span class="w-10 text-center font-bold text-gray-900 text-sm"><%= qty %></span>
            <form method="post" action="<%= contextPath %>/cart" style="margin:0">
                <input type="hidden" name="action"   value="update"/>
                <input type="hidden" name="name"     value="<%= name %>"/>
                <input type="hidden" name="quantity" value="<%= incremented %>"/>
                <button type="submit" class="w-9 h-9 bg-gray-50 hover:bg-green-50 text-lg font-bold
                                             text-gray-600 hover:text-green-600 transition">+</button>
            </form>
        </div>

        <%-- Line total --%>
        <div class="text-green-600 font-extrabold text-base min-w-[90px] text-right flex-shrink-0">
            Rs. <%= String.format("%.2f", lineTotal) %>
        </div>

        <%-- Remove button --%>
        <form method="post" action="<%= contextPath %>/cart" style="margin:0">
            <input type="hidden" name="action" value="remove"/>
            <input type="hidden" name="name"   value="<%= name %>"/>
            <button type="submit"
                    class="text-red-400 hover:text-red-600 text-xs font-bold flex-shrink-0
                           bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition">
                🗑 Remove
            </button>
        </form>
    </div>
    <% } %>

    <%-- ── BILL SUMMARY ────────────────────────────────────────────────────── --%>
    <div class="bg-white border border-gray-200 rounded-2xl p-6 mt-6 shadow-sm">
        <h2 class="text-xs font-bold uppercase tracking-widest text-green-600 mb-5">🧾 Bill Summary</h2>

        <div class="flex justify-between text-2xl font-extrabold text-gray-900 border-t-2 border-green-500 pt-4 mt-2">
            <span>Total</span>
            <span class="text-green-600">Rs. <%= String.format("%.2f", grandTotal) %></span>
        </div>

        <%--
            PLACE ORDER — POSTs to CartServlet with action=order.
            CartServlet writes to C:\FoodDeliveryData\orders.txt, clears the cart,
            then redirects back to GET /cart with orderPlaced flash flag.
        --%>
        <form method="post" action="<%= contextPath %>/cart" style="margin-top:20px">
            <input type="hidden" name="action" value="order"/>
            <button type="submit"
                    class="w-full bg-black hover:bg-green-600 text-white font-extrabold
                           py-4 rounded-xl text-lg transition">
                🚀 Place Order
            </button>
        </form>

        <%-- Optional: clear entire cart --%>
        <form method="post" action="<%= contextPath %>/cart" style="margin-top:12px;text-align:center">
            <input type="hidden" name="action" value="clear"/>
            <button type="submit"
                    class="text-gray-400 hover:text-gray-600 text-xs underline bg-transparent border-none cursor-pointer">
                Clear entire cart
            </button>
        </form>
    </div>

    <% } %>
</div>
</body>
</html>
