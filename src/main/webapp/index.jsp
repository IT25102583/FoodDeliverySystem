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

            <li><a href="index.jsp" class="block p-2 hover:bg-gray-50 hover:text-black rounded transition">Edit Profile</a></li>

            <%-- NEW: Link to Dilki's menu management module --%>
            <li><a href="menuItems" class="block p-2 hover:bg-gray-50 hover:text-black rounded transition">🍽️ Menu Management</a></li>

            <li>
                <a href="deleteAccount"
                   onclick="return confirm('Are you absolutely sure you want to permanently delete your restaurant? This cannot be undone.');"
                   class="block p-2 text-red-500 hover:bg-red-50 hover:text-red-600 font-bold rounded mt-8 transition">
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
                <p class="text-gray-500 mt-1">Manage your profile, menu and incoming orders.</p>
            </div>
            <div class="flex items-center space-x-3 bg-white p-3 rounded-lg shadow-sm border border-gray-200">
                <span class="text-sm font-bold text-gray-700">Accepting Orders:</span>
                <form action="toggleStatus" method="POST" class="m-0">
                    <button type="submit"
                            class="${(empty restaurantStatus || restaurantStatus == 'CLOSED') ? 'bg-red-100 text-red-800' : 'bg-green-100 text-green-800'} text-xs font-bold px-4 py-1.5 rounded-full hover:opacity-80 transition cursor-pointer shadow-sm">
                        ${(empty restaurantStatus || restaurantStatus == 'CLOSED') ? 'CLOSED' : 'OPEN'}
                    </button>
                </form>
            </div>
        </div>

        <%-- ── PROFILE EDIT FORM (original, unchanged) ──────────────────── --%>
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 max-w-2xl mb-10">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Edit Profile</h2>
            <form action="updateRestaurant" method="POST">
                <input type="hidden" name="restaurantName" value="${restaurantName}">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">New Password</label>
                        <input type="password" name="newPassword"
                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
                               title="Must contain at least 8 characters, including at least 1 number, 1 uppercase, and 1 lowercase letter."
                               placeholder="Enter new password"
                               class="w-full border border-gray-300 rounded-lg p-2.5 bg-white focus:ring-black focus:border-black" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Contact Number</label>
                        <input type="text" name="contactNumber" value="${contactNumber}"
                               pattern="^(\d{10})$"
                               title="Phone number must be exactly 10 digits."
                               class="w-full border border-gray-300 rounded-lg p-2.5 focus:ring-black focus:border-black" required>
                    </div>
                </div>
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Restaurant Address</label>
                    <input type="text" name="restaurantAddress" value="${restaurantAddress}"
                           class="w-full border border-gray-300 rounded-lg p-2.5 focus:ring-black focus:border-black" required>
                </div>
                <div class="flex justify-end">
                    <button type="submit" class="bg-black hover:bg-gray-800 text-white font-bold py-2 px-6 rounded-lg transition">Update Profile</button>
                </div>
            </form>
        </div>

        <%-- ══════════════════════════════════════════════════════════════════
             INCOMING ORDERS PANEL
             Reads C:\FoodDeliveryData\orders.txt and displays all orders.

             orders.txt format written by CartServlet:
               ORDER|<orderId>|<timestamp>
               ITEM|<name>|<price>|<qty>|<lineTotal>
               ...
               TOTAL|<grandTotal>
               ---
        ══════════════════════════════════════════════════════════════════ --%>
        <%
            // ── Parse orders.txt ───────────────────────────────────────────
            String ordersFilePath = "C:\\FoodDeliveryData\\orders.txt";
            File ordersFile = new File(ordersFilePath);

            // Each order is stored as a Map with keys: id, timestamp, total, items (List<String>)
            List<Map<String, Object>> orders = new ArrayList<>();

            if (ordersFile.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(ordersFile))) {
                    String line;
                    Map<String, Object> currentOrder = null;

                    while ((line = br.readLine()) != null) {
                        line = line.trim();
                        if (line.isEmpty()) continue;

                        if (line.startsWith("ORDER|")) {
                            // Start of a new order block
                            String[] parts = line.split("\\|", -1);
                            currentOrder = new LinkedHashMap<>();
                            currentOrder.put("id",        parts.length > 1 ? parts[1] : "?");
                            currentOrder.put("timestamp", parts.length > 2 ? parts[2] : "?");
                            currentOrder.put("items",     new ArrayList<String>());
                            currentOrder.put("total",     "0.00");
                            orders.add(currentOrder);

                        } else if (line.startsWith("ITEM|") && currentOrder != null) {
                            // e.g.  ITEM|Chicken Burger|850.0|2|1700.00
                            String[] p = line.split("\\|", -1);
                            String itemName  = p.length > 1 ? p[1] : "?";
                            String itemPrice = p.length > 2 ? p[2] : "?";
                            String itemQty   = p.length > 3 ? p[3] : "?";
                            String itemTotal = p.length > 4 ? p[4] : "?";
                            String display   = itemName + " × " + itemQty
                                             + " @ Rs." + itemPrice
                                             + " = Rs." + itemTotal;
                            ((List<String>) currentOrder.get("items")).add(display);

                        } else if (line.startsWith("TOTAL|") && currentOrder != null) {
                            String[] p = line.split("\\|", -1);
                            currentOrder.put("total", p.length > 1 ? p[1] : "0.00");

                        } else if (line.equals("---")) {
                            currentOrder = null; // end of order block
                        }
                    }
                } catch (IOException e) {
                    out.println("<p class='text-red-500'>Error reading orders: " + e.getMessage() + "</p>");
                }
            }

            // Show newest orders first
            Collections.reverse(orders);
        %>

        <%-- ── RENDER ORDERS TABLE ──────────────────────────────────────── --%>
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
                            <span class="bg-green-100 text-green-700 font-bold text-sm px-3 py-1 rounded-full">
                                Rs. <%= total %>
                            </span>
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
        <%-- ═══════════════════════ END OF ORDERS PANEL ═════════════════════ --%>

    </main>
</div>
</body>
</html>
