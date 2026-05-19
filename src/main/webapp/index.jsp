<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*, java.text.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Dashboard | Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800 font-sans">

<nav class="bg-black text-white p-4 shadow-md flex justify-between items-center">
    <div class="text-2xl font-bold tracking-tight">UberEats <span class="text-green-500">Partner</span></div>
    <div class="flex items-center space-x-4">
        <span class="text-sm font-medium">Welcome, ${restaurantName}</span>
        <a href="logoutRestaurant" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded text-sm font-bold transition">Log Out</a>
    </div>
</nav>

<div class="flex min-h-screen">

    <%-- ── SIDEBAR ─────────────────────────────────────────────────────────── --%>
    <aside class="w-64 bg-white border-r border-gray-200 p-6 hidden md:block">
        <ul class="space-y-4 text-sm font-medium text-gray-600">
            <li><a href="index.jsp" class="block p-2 text-black bg-gray-100 font-bold rounded shadow-sm">Dashboard</a></li>
            <li><a href="editProfile.jsp" class="block p-2 hover:bg-gray-50 hover:text-black rounded transition">Edit Profile</a></li>

            <li><a href="menuItems" class="block p-2 hover:bg-gray-50 hover:text-black rounded transition">🍽️ Menu Management</a></li>
            <li>
                <a href="deleteAccount" onclick="return confirm('Are you absolutely sure you want to permanently delete your restaurant? This cannot be undone.');" class="block p-2 text-red-500 hover:bg-red-50 hover:text-red-600 font-bold rounded mt-8 transition">
                    Delete Account
                </a>
            </li>
        </ul>
    </aside>

    <%-- ── MAIN CONTENT ───────────────────────────────────────────────────── --%>
    <main class="flex-1 p-8">

        <%-- Status toggle --%>
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">Restaurant Dashboard</h1>
                <p class="text-gray-500 mt-1">Manage your incoming orders and restaurant status.</p>
            </div>
            <div class="flex items-center space-x-3 bg-white p-3 rounded-lg shadow-sm border border-gray-200">
                <span class="text-sm font-bold text-gray-700">Accepting Orders:</span>
                <form action="toggleStatus" method="POST" class="m-0">
                    <button type="submit" class="${(empty restaurantStatus || restaurantStatus == 'CLOSED') ? 'bg-red-100 text-red-800' : 'bg-green-100 text-green-800'} text-xs font-bold px-4 py-1.5 rounded-full hover:opacity-80 transition cursor-pointer shadow-sm">
                        ${(empty restaurantStatus || restaurantStatus == 'CLOSED') ? 'CLOSED' : 'OPEN'}
                    </button>
                </form>
            </div>
        </div>

        <%-- ── INCOMING ORDERS PANEL ────────────────────────────────────────── --%>
        <%
            String ordersFilePath = "C:\\FoodDeliveryData\\orders.txt";
            File ordersFile = new File(ordersFilePath);
            List<Map<String, Object>> orders = new ArrayList<>();
            if (ordersFile.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(ordersFile))) {
                    String line;
                    Map<String, Object> currentOrder = null;
                    while ((line = br.readLine()) != null) {
                        line = line.trim();
                        if (line.isEmpty()) continue;
                        if (line.startsWith("ORDER|")) {
                            String[] parts = line.split("\\|", -1);
                            currentOrder = new LinkedHashMap<>();
                            currentOrder.put("id",        parts.length > 1 ? parts[1] : "?");
                            currentOrder.put("timestamp", parts.length > 2 ? parts[2] : "?");
                            currentOrder.put("items",     new ArrayList<String>());
                            currentOrder.put("total",     "0.00");
                            orders.add(currentOrder);
                        } else if (line.startsWith("ITEM|") && currentOrder != null) {
                            String[] p = line.split("\\|", -1);
                            String itemName  = p.length > 1 ? p[1] : "?";
                            String itemPrice = p.length > 2 ? p[2] : "?";
                            String itemQty   = p.length > 3 ? p[3] : "?";
                            String itemTotal = p.length > 4 ? p[4] : "?";
                            String display   = itemName + " × " + itemQty + " @ Rs." + itemPrice + " = Rs." + itemTotal;
                            ((List<String>) currentOrder.get("items")).add(display);
                        } else if (line.startsWith("TOTAL|") && currentOrder != null) {
                            String[] p = line.split("\\|", -1);
                            currentOrder.put("total", p.length > 1 ? p[1] : "0.00");
                        } else if (line.equals("---")) {
                            currentOrder = null;
                        }
                    }
                } catch (IOException e) {
                    out.println("<p class='text-red-500'>Error reading orders: " + e.getMessage() + "</p>");
                }
            }
            Collections.reverse(orders);
        %>

        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 max-w-4xl">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-lg font-bold text-gray-800">📦 Incoming Orders</h2>
                <span class="text-sm text-gray-400">
                    <%= orders.isEmpty() ? "No orders yet" : orders.size() + " order(s)" %>
                </span>
            </div>

            <% if (orders.isEmpty()) { %>
                <div class="text-center py-12 text-gray-400">
                    <div class="text-5xl mb-3">🛒</div>
                    <p class="font-medium">No orders have been placed yet.</p>
                    <p class="text-sm mt-1">Orders will appear here once customers start buying.</p>
                </div>
            <% } else { %>
                <div class="space-y-4">
                <% for (Map<String, Object> order : orders) {
                       String orderId    = (String) order.get("id");
                       String timestamp  = (String) order.get("timestamp");
                       String total      = (String) order.get("total");
                       List<String> itemLines = (List<String>) order.get("items");
                %>
                    <div class="border border-gray-200 rounded-xl p-5 hover:border-green-400 transition">
                        <div class="flex items-center justify-between mb-3">
                            <div>
                                <span class="font-mono text-sm font-bold text-gray-700"><%= orderId %></span>
                                <span class="ml-3 text-xs text-gray-400"><%= timestamp %></span>
                            </div>
                            <span class="bg-green-100 text-green-700 font-bold text-sm px-3 py-1 rounded-full">Rs. <%= total %></span>
                        </div>
                        <ul class="text-sm text-gray-600 space-y-1 pl-2 border-l-2 border-gray-100">
                            <% for (String itemLine : itemLines) { %>
                                <li>• <%= itemLine %></li>
                            <% } %>
                        </ul>
                    </div>
                <% } %>
                </div>
            <% } %>
        </div>

    </main>
</div>
</body>
</html>