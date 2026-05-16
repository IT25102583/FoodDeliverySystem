package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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

        // 1. Capture the data from the form
        String user    = request.getParameter("username");
        String pass    = request.getParameter("password");
        String id      = request.getParameter("restaurantId");
        String name    = request.getParameter("restaurantName");
        String address = request.getParameter("address");
        String phone   = request.getParameter("contactNumber");

        // 2. Create the Restaurant object (starts as CLOSED by default)
        Restaurant newRestaurant = new Restaurant(user, pass, id, name, phone, address, false);

        // 3. Save to file using toFileFormat() - Polymorphism in action!
        //    We call the overridden method from the User abstract class.
        try {
            File file = new File(FILE_PATH);
            file.getParentFile().mkdirs();

            FileWriter fw = new FileWriter(file, true);
            PrintWriter pw = new PrintWriter(fw);

            pw.println(newRestaurant.toFileFormat());

            pw.close();
            System.out.println("Success! Saved restaurant: " + newRestaurant.getRestaurantName());

        } catch (IOException e) {
            System.out.println("Error saving to file!");
            e.printStackTrace();
        }

        // 4. Create the session and store logged-in restaurant's details
        HttpSession session = request.getSession();
        session.setAttribute("restaurantName",    newRestaurant.getRestaurantName());
        session.setAttribute("contactNumber",     newRestaurant.getContactNumber());
        session.setAttribute("restaurantAddress", newRestaurant.getAddress());
        session.setAttribute("restaurantStatus",  "CLOSED");

        // 5. Redirect to the dashboard
        response.sendRedirect("index.jsp");
    }
}
