package controllers;

import models.CartItem;
import services.CartService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Handles all HTTP traffic for the customer cart.
 *
 * URL: /cart
 *
 * GET  → loads cart from C:\FoodDeliveryData\cart.txt, forwards to cart.jsp
 * POST → dispatches based on hidden "action" parameter, then redirects (PRG pattern)
 *
 * POST actions:
 *   add    – add item (or increment qty if already in cart)
 *   update – change quantity of an existing item
 *   remove – remove a single item
 *   clear  – empty the entire cart
 *   order  – PLACE ORDER: writes to C:\FoodDeliveryData\orders.txt, clears cart
 *
 * No Spring annotations used. CartService is instantiated as a field.
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final String ORDERS_FILE = "C:\\FoodDeliveryData\\orders.txt";

    private final CartService cartService = new CartService();

    // ── GET ───────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<CartItem> items = cartService.getAllItems();
        double grandTotal    = cartService.getGrandTotal();

        req.setAttribute("cartItems",  items);
        req.setAttribute("grandTotal", grandTotal);

        // Flash attribute: did the user just place an order?
        HttpSession session  = req.getSession(false);
        boolean orderPlaced  = false;
        if (session != null) {
            Object flag = session.getAttribute("orderPlaced");
            if (Boolean.TRUE.equals(flag)) {
                orderPlaced = true;
                session.removeAttribute("orderPlaced"); // consume once
            }
        }
        req.setAttribute("orderPlaced", orderPlaced);

        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    // ── POST ──────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":    handleAdd(req);    break;
            case "update": handleUpdate(req); break;
            case "remove": handleRemove(req); break;
            case "clear":  cartService.clearCart(); break;
            case "order":  handleOrder(req);  break;
            default:
                System.err.println("[CartServlet] Unknown action: " + action);
        }

        // Post-Redirect-Get: always redirect after POST
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    // ── Action handlers ───────────────────────────────────────────────────────

    /** action=add: add item from menu.jsp form to cart. */
    private void handleAdd(HttpServletRequest req) {
        String name     = req.getParameter("name");
        String priceStr = req.getParameter("price");
        String qtyStr   = req.getParameter("quantity");
        String category = req.getParameter("category");

        if (name == null || name.trim().isEmpty() || priceStr == null) {
            System.err.println("[CartServlet] add: missing required params.");
            return;
        }

        try {
            double price    = Double.parseDouble(priceStr.trim());
            int    quantity = 1;
            if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                quantity = Integer.parseInt(qtyStr.trim());
            }
            if (quantity < 1) quantity = 1;

            cartService.addItem(new CartItem(
                name.trim(), price, quantity,
                category != null ? category.trim() : ""
            ));
        } catch (NumberFormatException e) {
            System.err.println("[CartServlet] add: bad number — " + e.getMessage());
        }
    }

    /** action=update: change quantity of an existing cart item. */
    private void handleUpdate(HttpServletRequest req) {
        String name   = req.getParameter("name");
        String qtyStr = req.getParameter("quantity");

        if (name == null || name.trim().isEmpty() || qtyStr == null) {
            System.err.println("[CartServlet] update: missing required params.");
            return;
        }

        try {
            int qty = Integer.parseInt(qtyStr.trim());
            if (qty < 1) qty = 1;
            cartService.updateQuantity(name.trim(), qty);
        } catch (NumberFormatException e) {
            System.err.println("[CartServlet] update: bad quantity — " + e.getMessage());
        }
    }

    /** action=remove: remove one item from the cart. */
    private void handleRemove(HttpServletRequest req) {
        String name = req.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            System.err.println("[CartServlet] remove: missing 'name' param.");
            return;
        }
        cartService.removeItem(name.trim());
    }

    /**
     * action=order: Place the order.
     *
     * Writes a block to C:\FoodDeliveryData\orders.txt in the format:
     *
     *   ORDER|<orderId>|<timestamp>
     *   ITEM|<name>|<price>|<qty>|<lineTotal>
     *   ...
     *   TOTAL|<grandTotal>
     *   ---
     *
     * Then clears the cart and sets the orderPlaced flash attribute in the session.
     */
    private void handleOrder(HttpServletRequest req) {
        List<CartItem> items = cartService.getAllItems();
        if (items.isEmpty()) return; // nothing to order

        double grandTotal = cartService.getGrandTotal();
        String timestamp  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String orderId    = "ORD" + System.currentTimeMillis();

        // ── Write to orders.txt ───────────────────────────────────────────────
        File file = new File(ORDERS_FILE);
        File dir  = file.getParentFile();
        if (dir != null && !dir.exists()) dir.mkdirs();

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write("ORDER|" + orderId + "|" + timestamp);
            bw.newLine();
            for (CartItem ci : items) {
                bw.write("ITEM|" + ci.getName()
                    + "|" + ci.getPrice()
                    + "|" + ci.getQuantity()
                    + "|" + String.format("%.2f", ci.getTotal()));
                bw.newLine();
            }
            bw.write("TOTAL|" + String.format("%.2f", grandTotal));
            bw.newLine();
            bw.write("---");
            bw.newLine();
            System.out.println("[CartServlet] Order written: " + orderId);
        } catch (IOException e) {
            System.err.println("[CartServlet] Failed to write order: " + e.getMessage());
        }

        // ── Clear cart ────────────────────────────────────────────────────────
        cartService.clearCart();

        // ── Set flash attribute ───────────────────────────────────────────────
        HttpSession session = req.getSession(true);
        session.setAttribute("orderPlaced", Boolean.TRUE);
    }
}
