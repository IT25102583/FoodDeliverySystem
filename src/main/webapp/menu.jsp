<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.MenuItem" %>
<%@ page import="services.MenuItemService" %>
<%@ page import="java.util.List" %>
<%
    // ── Load all available menu items ──────────────────────────────────────────
    MenuItemService menuService = new MenuItemService();
    List<MenuItem>  menuItems;
    String          filterCat   = request.getParameter("category");
    String          searchQuery = request.getParameter("q");

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        menuItems = menuService.search(searchQuery.trim());
    } else if (filterCat != null && !filterCat.trim().isEmpty()) {
        menuItems = menuService.getByCategory(filterCat.trim());
    } else {
        menuItems = menuService.getAll();
    }

    List<String> categories = menuService.getAllCategories();
    String contextPath = request.getContextPath();

    // Only show available items to customers
    java.util.List<MenuItem> available = new java.util.ArrayList<>();
    for (MenuItem m : menuItems) {
        if (m.isAvailable()) available.add(m);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Menu | Food Delivery</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans min-h-screen">

<%-- ── HEADER ──────────────────────────────────────────────────────────────── --%>
<nav class="bg-black text-white p-4 shadow-md flex justify-between items-center sticky top-0 z-50">
    <div class="text-2xl font-bold tracking-tight">
        UberEats <span class="text-green-500">Menu</span>
    </div>
    <div class="flex items-center space-x-4">
        <a href="<%= contextPath %>/cart"
           class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded text-sm font-bold transition">
            🛒 View Cart
        </a>
    </div>
</nav>

<%-- ── FILTERS ────────────────────────────────────────────────────────────── --%>
<div class="max-w-6xl mx-auto px-6 pt-8 pb-4">
    <h1 class="text-3xl font-bold text-gray-900 mb-1">Our Menu</h1>
    <p class="text-gray-500 mb-6">Fresh food delivered to your door.</p>

    <%-- Search + Category filter form --%>
    <form method="get" action="menu.jsp" class="flex flex-wrap gap-3 mb-8">
        <input type="text" name="q" value="<%= searchQuery != null ? searchQuery : "" %>"
               placeholder="Search items…"
               class="border border-gray-300 rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-400 w-60"/>
        <select name="category"
                class="border border-gray-300 rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-400">
            <option value="">All Categories</option>
            <% for (String cat : categories) { %>
                <option value="<%= cat %>"
                    <%= cat.equals(filterCat) ? "selected" : "" %>><%= cat %></option>
            <% } %>
        </select>
        <button type="submit"
                class="bg-black text-white px-5 py-2 rounded-lg text-sm font-bold hover:bg-gray-800 transition">
            Search
        </button>
        <% if ((searchQuery != null && !searchQuery.isEmpty())
              || (filterCat  != null && !filterCat.isEmpty())) { %>
        <a href="menu.jsp"
           class="text-gray-500 hover:text-black text-sm flex items-center px-3 underline">
            Clear
        </a>
        <% } %>
    </form>

    <%-- ── MENU ITEMS GRID ─────────────────────────────────────────────────── --%>
    <% if (available.isEmpty()) { %>
        <div class="text-center py-20 text-gray-400">
            <div class="text-6xl mb-4">🍽️</div>
            <p class="text-xl font-semibold text-gray-600">No items found.</p>
            <a href="menu.jsp" class="mt-4 inline-block text-green-600 hover:underline text-sm">
                View all items
            </a>
        </div>
    <% } else { %>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <% for (MenuItem item : available) { %>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden
                    hover:shadow-lg hover:border-green-400 transition duration-200 flex flex-col">

            <%-- Item image / placeholder --%>
            <% if (item.getImageUrl() != null && !item.getImageUrl().trim().isEmpty()) { %>
                <img src="<%= item.getImageUrl() %>"
                     alt="<%= item.getName() %>"
                     class="w-full h-44 object-cover"
                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"/>
                <div class="w-full h-44 bg-gray-100 flex items-center justify-center text-5xl hidden">🍽️</div>
            <% } else { %>
                <div class="w-full h-44 bg-gray-100 flex items-center justify-center text-5xl">🍽️</div>
            <% } %>

            <%-- Card body --%>
            <div class="p-5 flex flex-col flex-1">
                <div class="flex items-start justify-between mb-2">
                    <div>
                        <h2 class="font-bold text-gray-900 text-lg leading-tight"><%= item.getName() %></h2>
                        <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold
                                     px-2 py-0.5 rounded-full mt-1"><%= item.getCategory() %></span>
                    </div>
                    <span class="text-green-600 font-extrabold text-lg whitespace-nowrap ml-2">
                        Rs. <%= String.format("%.2f", item.getPrice()) %>
                    </span>
                </div>

                <% if (item.getDescription() != null && !item.getDescription().trim().isEmpty()) { %>
                    <p class="text-gray-500 text-sm mb-4 flex-1"><%= item.getDescription() %></p>
                <% } else { %>
                    <div class="flex-1"></div>
                <% } %>

                <%--
                    ── ADD TO CART FORM ─────────────────────────────────────────
                    POSTs to CartServlet (/cart) with action=add.
                    CartServlet reads: name, price, quantity, category.
                --%>
                <form method="post" action="<%= contextPath %>/cart"
                      class="flex items-center gap-2 mt-auto">
                    <input type="hidden" name="action"   value="add"/>
                    <input type="hidden" name="name"     value="<%= item.getName() %>"/>
                    <input type="hidden" name="price"    value="<%= item.getPrice() %>"/>
                    <input type="hidden" name="category" value="<%= item.getCategory() %>"/>

                    <input type="number" name="quantity" value="1" min="1" max="20"
                           class="w-16 border border-gray-300 rounded-lg text-center text-sm
                                  py-2 focus:outline-none focus:ring-2 focus:ring-green-400"/>

                    <button type="submit"
                            class="flex-1 bg-black hover:bg-green-600 text-white font-bold
                                   py-2 px-4 rounded-lg text-sm transition">
                        + Add to Cart
                    </button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<%-- ── FOOTER ────────────────────────────────────────────────────────────── --%>
<div class="text-center mt-16 mb-8 text-sm text-gray-400">
    &copy; 2026 Food Delivery System. Built for SLIIT.
</div>

</body>
</html>
