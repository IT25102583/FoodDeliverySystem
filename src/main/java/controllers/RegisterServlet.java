package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Restaurant;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;

@WebServlet("/registerRestaurant")
public class RegisterServlet extends HttpServlet {

    // Define exactly where the text file will be saved on your computer
    // (You might need to create the 'FoodDeliveryData' folder on your C: drive first!)
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

        // 3. Save to a Text File!
        try {
            // Make sure the directory exists
            File file = new File(FILE_PATH);
            file.getParentFile().mkdirs();

            // FileWriter with 'true' means it will APPEND to the file, not overwrite it
            FileWriter fw = new FileWriter(file, true);
            PrintWriter pw = new PrintWriter(fw);

            // Write the data as a single line separated by commas (CSV style)
            pw.println(newRestaurant.getUsername() + "," +
                    newRestaurant.getPassword() + "," +
                    newRestaurant.getRestaurantId() + "," +
                    newRestaurant.getRestaurantName() + "," +
                    newRestaurant.getContactNumber() + "," +
                    newRestaurant.getAddress());

            // Always close the writer to free up memory!
            pw.close();

            System.out.println("Success! Saved restaurant to: " + FILE_PATH);

        } catch (IOException e) {
            System.out.println("Error saving to file!");
            e.printStackTrace();
        }

        // 4. Send them to the dashboard
        response.sendRedirect("index.jsp");
    }
}