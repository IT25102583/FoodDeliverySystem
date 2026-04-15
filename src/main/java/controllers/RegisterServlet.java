package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Restaurant;

import java.io.IOException;

// This URL perfectly matches the 'action' in your signup.jsp form!
@WebServlet("/registerRestaurant")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Capture the exact data typed into the HTML signup form
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String id = request.getParameter("restaurantId");
        String name = request.getParameter("restaurantName");
        String address = request.getParameter("address");
        String phone = request.getParameter("contactNumber");

        // 2. Apply your OOP! Create a brand new Restaurant object.
        // Note: We set the final boolean to 'false' because new restaurants should start out "closed"
        Restaurant newRestaurant = new Restaurant(user, pass, id, name, phone, address, false);

        // 3. Print the object's data to the IntelliJ console to prove the data arrived safely
        System.out.println("--- NEW RESTAURANT ACCOUNT CREATED ---");
        System.out.println("Account Username: " + newRestaurant.getUsername());
        System.out.println("Restaurant ID: " + newRestaurant.getRestaurantId());
        System.out.println("Restaurant Name: " + newRestaurant.getRestaurantName());
        System.out.println("Contact Number: " + newRestaurant.getContactNumber());
        System.out.println("--------------------------------------");

        // 4. Send the user to the main dashboard after they register
        response.sendRedirect("index.jsp");
    }
}