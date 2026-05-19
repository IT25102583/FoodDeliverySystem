package services;

import models.CartItem;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles all cart persistence via plain file I/O.
 *
 * Cart data file: C:\FoodDeliveryData\cart.txt
 * Format: name|price|quantity|category  (one item per line)
 *
 * Instantiate directly: CartService svc = new CartService();
 */
public class CartService {

    private static final String FILE_PATH = "C:\\FoodDeliveryData\\cart.txt";

    // ── Read ──────────────────────────────────────────────────────────────────

    /** Returns all current cart items; empty list if file is absent or blank. */
    public List<CartItem> getAllItems() {
        List<CartItem> items = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) return items;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    try { items.add(CartItem.fromFileString(line)); }
                    catch (IllegalArgumentException e) {
                        System.err.println("[CartService] Skipping bad line: " + line);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("[CartService] Read error: " + e.getMessage());
        }
        return items;
    }

    // ── Write ─────────────────────────────────────────────────────────────────

    /**
     * Adds an item to the cart.
     * If an item with the same name already exists, quantity is incremented instead.
     */
    public void addItem(CartItem newItem) {
        List<CartItem> items = getAllItems();
        boolean found = false;
        for (CartItem ci : items) {
            if (ci.getName().equalsIgnoreCase(newItem.getName())) {
                ci.setQuantity(ci.getQuantity() + newItem.getQuantity());
                found = true;
                break;
            }
        }
        if (!found) items.add(newItem);
        saveAllItems(items);
    }

    /** Updates the quantity of the item identified by name. */
    public void updateQuantity(String name, int quantity) {
        List<CartItem> items = getAllItems();
        for (CartItem ci : items) {
            if (ci.getName().equals(name)) { ci.setQuantity(quantity); break; }
        }
        saveAllItems(items);
    }

    /** Removes the item identified by name from the cart. */
    public void removeItem(String name) {
        List<CartItem> items = getAllItems();
        items.removeIf(ci -> ci.getName().equals(name));
        saveAllItems(items);
    }

    /** Empties the cart entirely. */
    public void clearCart() {
        saveAllItems(new ArrayList<>());
    }

    /** Convenience method: returns the grand total of all items. */
    public double getGrandTotal() {
        double total = 0.0;
        for (CartItem ci : getAllItems()) total += ci.getTotal();
        return total;
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    /** Overwrites the cart file with the given list. Creates the directory if needed. */
    private void saveAllItems(List<CartItem> items) {
        File file = new File(FILE_PATH);
        File dir  = file.getParentFile();
        if (dir != null && !dir.exists()) {
            if (!dir.mkdirs()) {
                System.err.println("[CartService] Could not create: " + dir.getAbsolutePath());
                return;
            }
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            for (CartItem ci : items) { bw.write(ci.toFileString()); bw.newLine(); }
        } catch (IOException e) {
            System.err.println("[CartService] Write error: " + e.getMessage());
        }
    }
}
