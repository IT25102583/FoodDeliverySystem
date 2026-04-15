package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Restaurant;

import java.io.IOException;

// This URL must perfectly match the 'action' in your HTML form!
@WebServlet("/updateRestaurant")
public class RestaurantServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Capture the data typed into the HTML form
        String name = request.getParameter("restaurantName");
        String phone = request.getParameter("contactNumber");
        String address = request.getParameter("restaurantAddress");

        // 2. Apply your OOP! Create a new Restaurant object using the data.
        // (We use dummy data for the username/password for now since we haven't built the login page yet)
        Restaurant updatedRestaurant = new Restaurant("sanjit_owner", "pass123", "R001", name, phone, address, true);

        // 3. Prove the bridge works by printing the object's data to the IntelliJ console
        System.out.println("--- NEW RESTAURANT UPDATE RECEIVED ---");
        System.out.println("Name: " + updatedRestaurant.getRestaurantName());
        System.out.println("Phone: " + updatedRestaurant.getContactNumber());
        System.out.println("Address: " + updatedRestaurant.getAddress());
        System.out.println("--------------------------------------");

        // 4. Send the user back to the dashboard so they aren't staring at a blank screen
        response.sendRedirect("index.jsp");
    }
}