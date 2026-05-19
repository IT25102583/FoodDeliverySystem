package models;

/**
 * Represents a single item in the customer's shopping cart.
 *
 * File format (pipe-delimited, one item per line in cart.txt):
 *   name|price|quantity|category
 *
 * Stored at: C:\FoodDeliveryData\cart.txt
 *
 * OOP Concept: Encapsulation — all fields are private with public getters/setters.
 */
public class CartItem {

    private String name;
    private double price;
    private int    quantity;
    private String category;

    public CartItem() {}

    public CartItem(String name, double price, int quantity, String category) {
        this.name     = name;
        this.price    = price;
        this.quantity = quantity;
        this.category = category;
    }

    // ── Business logic ────────────────────────────────────────────────────────

    /** Returns the line-total for this cart item (unit price × quantity). */
    public double getTotal() {
        return price * quantity;
    }

    // ── Serialisation ─────────────────────────────────────────────────────────

    /**
     * Serialises this item to a single pipe-delimited line for cart.txt.
     * Example: "Fried Rice|350.0|2|Rice"
     */
    public String toFileString() {
        return name + "|" + price + "|" + quantity + "|" + category;
    }

    /**
     * Deserialises one line from cart.txt back into a CartItem.
     * Throws IllegalArgumentException if the line has fewer than 3 fields.
     */
    public static CartItem fromFileString(String line) {
        String[] p = line.split("\\|");
        if (p.length < 3) {
            throw new IllegalArgumentException(
                "Malformed cart line (need at least 3 pipe-fields): " + line);
        }
        CartItem ci = new CartItem();
        ci.setName(p[0].trim());
        ci.setPrice(Double.parseDouble(p[1].trim()));
        ci.setQuantity(Integer.parseInt(p[2].trim()));
        ci.setCategory(p.length > 3 ? p[3].trim() : "");
        return ci;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public String getName()             { return name; }
    public void   setName(String name)  { this.name = name; }

    public double getPrice()              { return price; }
    public void   setPrice(double price)  { this.price = price; }

    public int  getQuantity()               { return quantity; }
    public void setQuantity(int quantity)   { this.quantity = quantity; }

    public String getCategory()                { return category; }
    public void   setCategory(String category) { this.category = category; }

    @Override
    public String toString() {
        return "CartItem{name='" + name + "', price=" + price
             + ", qty=" + quantity + ", total=" + getTotal() + "}";
    }
}
