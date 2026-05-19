package models;

/**
 * Represents a single food item in the restaurant menu.
 *
 * File format (pipe-delimited, one item per line):
 *   id|name|category|description|price|available|imageUrl
 *
 * Stored at: C:\FoodDeliveryData\menu.txt
 *
 * OOP Concept: Encapsulation — all fields are private with public getters/setters.
 */
public class MenuItem {

    private String  id;
    private String  name;
    private String  category;
    private String  description;
    private double  price;
    private boolean available;
    private String  imageUrl;

    public MenuItem() {}

    public MenuItem(String id, String name, String category, String description,
                    double price, boolean available, String imageUrl) {
        this.id          = id;
        this.name        = name;
        this.category    = category;
        this.description = description;
        this.price       = price;
        this.available   = available;
        this.imageUrl    = imageUrl;
    }

    // ── Serialisation ─────────────────────────────────────────────────────────

    /**
     * Converts this object to a single pipe-delimited line for file storage.
     * Example: MI001|Chicken Burger|Main Course|Juicy burger|850.0|true|
     */
    public String toFileString() {
        return id + "|" + name + "|" + category + "|" + description
             + "|" + price + "|" + available + "|" + imageUrl;
    }

    /**
     * Parses one line from menu.txt back into a MenuItem.
     * Returns null if the line is malformed (too few fields).
     */
    public static MenuItem fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 7) return null;
        return new MenuItem(
            p[0], p[1], p[2], p[3],
            Double.parseDouble(p[4]),
            Boolean.parseBoolean(p[5]),
            p[6]
        );
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public String  getId()                       { return id; }
    public void    setId(String id)              { this.id = id; }

    public String  getName()                     { return name; }
    public void    setName(String name)          { this.name = name; }

    public String  getCategory()                 { return category; }
    public void    setCategory(String category)  { this.category = category; }

    public String  getDescription()                       { return description; }
    public void    setDescription(String description)     { this.description = description; }

    public double  getPrice()                    { return price; }
    public void    setPrice(double price)        { this.price = price; }

    public boolean isAvailable()                          { return available; }
    public void    setAvailable(boolean available)        { this.available = available; }

    public String  getImageUrl()                 { return imageUrl; }
    public void    setImageUrl(String imageUrl)  { this.imageUrl = imageUrl; }
}
