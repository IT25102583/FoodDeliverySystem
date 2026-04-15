package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// This URL perfectly matches the 'href' we just put in index.jsp!
@WebServlet("/logoutRestaurant")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Grab the current session, but DO NOT create a new one if it doesn't exist (that is what the 'false' means)
        HttpSession session = request.getSession(false);

        // 2. If a session wristband exists, rip it up (invalidate it)!
        if (session != null) {
            session.invalidate();
            System.out.println("--- LOGOUT SUCCESSFUL: Session Destroyed ---");
        }

        // 3. Kick the user safely back to the login page
        response.sendRedirect("login.jsp");
    }
}