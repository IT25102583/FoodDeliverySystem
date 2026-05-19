package services;

import models.MenuItem;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles all CRUD operations for menu items.
 *
 * All data is stored at: C:\FoodDeliveryData\menu.txt
 * Format: id|name|category|description|price|available|imageUrl  (one item per line)
 *
 * OOP Concept: Abstraction — file I/O details are hidden inside private methods.
 *              Instantiate directly: MenuItemService svc = new MenuItemService();
 */
public class MenuItemService {

    private static final String FILE_PATH = "C:\\FoodDeliveryData\\menu.txt";

    // ── Constructor ───────────────────────────────────────────────────────────

    /**
     * Creates the data file (and its parent directory) if they do not already exist.
     */
    public MenuItemService() {
        File file = new File(FILE_PATH);
        File dir  = file.getParentFile();
        if (dir != null && !dir.exists()) {
            dir.mkdirs();
        }
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("[MenuItemService] Could not create file: " + e.getMessage());
            }
        }
    }

    // ── Private I/O helpers ───────────────────────────────────────────────────

    private List<MenuItem> readAll() throws IOException {
        List<MenuItem> items = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    MenuItem item = MenuItem.fromFileString(line);
                    if (item != null) items.add(item);
                }
            }
        }
        return items;
    }

    private void writeAll(List<MenuItem> items) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (MenuItem item : items) {
                bw.write(item.toFileString());
                bw.newLine();
            }
        }
    }

    /** Generates a unique ID based on the current timestamp. */
    private String generateId() {
        return "MI" + System.currentTimeMillis();
    }

    // ── CREATE ────────────────────────────────────────────────────────────────

    public MenuItem create(MenuItem item) throws IOException {
        item.setId(generateId());
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            bw.write(item.toFileString());
            bw.newLine();
        }
        return item;
    }

    // ── READ ──────────────────────────────────────────────────────────────────

    public List<MenuItem> getAll() throws IOException {
        return readAll();
    }

    public MenuItem getById(String id) throws IOException {
        for (MenuItem item : readAll()) {
            if (item.getId().equals(id)) return item;
        }
        return null;
    }

    public List<MenuItem> search(String query) throws IOException {
        List<MenuItem> results = new ArrayList<>();
        String q = query.toLowerCase();
        for (MenuItem item : readAll()) {
            if (item.getName().toLowerCase().contains(q)
             || item.getCategory().toLowerCase().contains(q)
             || item.getDescription().toLowerCase().contains(q)) {
                results.add(item);
            }
        }
        return results;
    }

    public List<MenuItem> getByCategory(String category) throws IOException {
        List<MenuItem> results = new ArrayList<>();
        for (MenuItem item : readAll()) {
            if (item.getCategory().equalsIgnoreCase(category)) results.add(item);
        }
        return results;
    }

    public List<String> getAllCategories() throws IOException {
        List<String> cats = new ArrayList<>();
        for (MenuItem item : readAll()) {
            if (!cats.contains(item.getCategory())) cats.add(item.getCategory());
        }
        return cats;
    }

    // ── UPDATE ────────────────────────────────────────────────────────────────

    public boolean update(MenuItem updated) throws IOException {
        List<MenuItem> items = readAll();
        boolean found = false;
        for (int i = 0; i < items.size(); i++) {
            if (items.get(i).getId().equals(updated.getId())) {
                items.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeAll(items);
        return found;
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    public boolean delete(String id) throws IOException {
        List<MenuItem> items   = readAll();
        List<MenuItem> updated = new ArrayList<>();
        boolean removed = false;
        for (MenuItem item : items) {
            if (item.getId().equals(id)) { removed = true; }
            else                         { updated.add(item); }
        }
        if (removed) writeAll(updated);
        return removed;
    }
}
