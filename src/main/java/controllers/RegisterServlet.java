package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Don't forget this new import!
import models.Restaurant;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;

@WebServlet("/registerRestaurant")
public class RegisterServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\FoodDeliveryData\\restaurants.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Capture the data
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String id = request.getParameter("restaurantId");
        String name = request.getParameter("restaurantName");
        String address = request.getParameter("address");
        String phone = request.getParameter("contactNumber");

        // 2. Create the Object
        Restaurant newRestaurant = new Restaurant(user, pass, id, name, phone, address, false);

        // 3. Save to a Text File
        try {
            File file = new File(FILE_PATH);
            file.getParentFile().mkdirs();

            FileWriter fw = new FileWriter(file, true);
            PrintWriter pw = new PrintWriter(fw);

            pw.println(newRestaurant.getUsername() + "," +
                    newRestaurant.getPassword() + "," +
                    newRestaurant.getRestaurantId() + "," +
                    newRestaurant.getRestaurantName() + "," +
                    newRestaurant.getContactNumber() + "," +
                    newRestaurant.getAddress());

            pw.close();
            System.out.println("Success! Saved restaurant to: " + FILE_PATH);

        } catch (IOException e) {
            System.out.println("Error saving to file!");
            e.printStackTrace();
        }

        // --- THE FIX: Create the Session Wristband! ---
        HttpSession session = request.getSession();
        session.setAttribute("restaurantName", newRestaurant.getRestaurantName());
        session.setAttribute("contactNumber", newRestaurant.getContactNumber());
        session.setAttribute("restaurantAddress", newRestaurant.getAddress());
        // We also set the default status so the Open/Closed button works immediately
        session.setAttribute("restaurantStatus", "CLOSED");

        // 4. Send them to the dashboard
        response.sendRedirect("index.jsp");
    }
}