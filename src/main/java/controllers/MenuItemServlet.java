package controllers;

import models.MenuItem;
import services.MenuItemService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Handles all CRUD operations for the restaurant's menu items.
 *
 * URL: /menuItems
 * GET  ?action=list    → forwards to WEB-INF/views/menuItem/list.jsp
 * GET  ?action=add     → forwards to WEB-INF/views/menuItem/add.jsp
 * GET  ?action=edit    → forwards to WEB-INF/views/menuItem/edit.jsp
 * GET  ?action=delete  → forwards to WEB-INF/views/menuItem/delete.jsp
 * GET  ?action=search  → search results in list.jsp
 * POST ?action=create  → create new item
 * POST ?action=update  → update existing item
 * POST ?action=delete  → delete item
 *
 * SESSION GUARD: Only a logged-in restaurant owner can access this servlet.
 * Unauthenticated requests are redirected to login.jsp.
 */
@WebServlet("/menuItems")
public class MenuItemServlet extends HttpServlet {

    private final MenuItemService service = new MenuItemService();

    // ── GET ───────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Protect: only logged-in restaurant owners may manage the menu
        if (!isLoggedIn(req)) { resp.sendRedirect("login.jsp"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "add":
                req.getRequestDispatcher("/WEB-INF/views/menuItem/add.jsp")
                   .forward(req, resp);
                break;

            case "edit": {
                String id = req.getParameter("id");
                MenuItem item = service.getById(id);
                if (item == null) { resp.sendRedirect("menuItems"); return; }
                req.setAttribute("item", item);
                req.getRequestDispatcher("/WEB-INF/views/menuItem/edit.jsp")
                   .forward(req, resp);
                break;
            }

            case "delete": {
                String id = req.getParameter("id");
                MenuItem item = service.getById(id);
                if (item == null) { resp.sendRedirect("menuItems"); return; }
                req.setAttribute("item", item);
                req.getRequestDispatcher("/WEB-INF/views/menuItem/delete.jsp")
                   .forward(req, resp);
                break;
            }

            case "search": {
                String q = req.getParameter("q");
                List<MenuItem> results = (q != null && !q.isBlank())
                        ? service.search(q) : service.getAll();
                req.setAttribute("items", results);
                req.setAttribute("query", q);
                req.setAttribute("categories", service.getAllCategories());
                req.getRequestDispatcher("/WEB-INF/views/menuItem/list.jsp")
                   .forward(req, resp);
                break;
            }

            default: { // "list" and anything else
                String category = req.getParameter("category");
                List<MenuItem> items = (category != null && !category.isBlank())
                        ? service.getByCategory(category) : service.getAll();
                req.setAttribute("items", items);
                req.setAttribute("categories", service.getAllCategories());
                req.getRequestDispatcher("/WEB-INF/views/menuItem/list.jsp")
                   .forward(req, resp);
            }
        }
    }

    // ── POST ──────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { resp.sendRedirect("login.jsp"); return; }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            case "create": {
                MenuItem item = buildFromRequest(req);
                service.create(item);
                resp.sendRedirect("menuItems?success=Item+added+successfully");
                break;
            }

            case "update": {
                MenuItem item = buildFromRequest(req);
                item.setId(req.getParameter("id"));
                service.update(item);
                resp.sendRedirect("menuItems?success=Item+updated+successfully");
                break;
            }

            case "delete": {
                service.delete(req.getParameter("id"));
                resp.sendRedirect("menuItems?success=Item+deleted+successfully");
                break;
            }

            default:
                resp.sendRedirect("menuItems");
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("restaurantName") != null;
    }

    private MenuItem buildFromRequest(HttpServletRequest req) {
        MenuItem item = new MenuItem();
        item.setName(req.getParameter("name"));
        item.setCategory(req.getParameter("category"));
        item.setDescription(req.getParameter("description"));
        item.setPrice(Double.parseDouble(req.getParameter("price")));
        item.setAvailable("on".equals(req.getParameter("available"))
                       || "true".equals(req.getParameter("available")));
        String imageUrl = req.getParameter("imageUrl");
        item.setImageUrl(imageUrl != null ? imageUrl : "");
        return item;
    }
}
