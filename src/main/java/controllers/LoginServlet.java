package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// This URL perfectly matches the 'action' in your login.jsp form!
@WebServlet("/loginRestaurant")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Capture the data typed into the HTML login form
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // 2. Print the login attempt to the console to prove the data arrived
        System.out.println("--- LOGIN ATTEMPT RECEIVED ---");
        System.out.println("Attempted Username: " + user);
        System.out.println("Attempted Password: " + pass);
        System.out.println("------------------------------");

        // 3. For now, we just assume the login is successful and send them to the dashboard.
        // (Later, we will check these credentials against a real database!)
        response.sendRedirect("index.jsp");
    }
}