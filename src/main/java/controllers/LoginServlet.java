package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/loginRestaurant")
public class LoginServlet extends HttpServlet {

    // Must be the exact same path we used in the RegisterServlet!
    private static final String FILE_PATH = "C:\\FoodDeliveryData\\restaurants.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Capture the login attempt
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        boolean loginSuccess = false;

        // 2. Open the file and search for a match
        try {
            File file = new File(FILE_PATH);

            // Only try to read if the file actually exists
            if (file.exists()) {
                BufferedReader br = new BufferedReader(new FileReader(file));
                String line;

                // Read every single line until we hit the bottom of the file
                while ((line = br.readLine()) != null) {

                    // Split the line into an array using the comma as the divider
                    String[] accountDetails = line.split(",");

                    // accountDetails[0] is Username, accountDetails[1] is Password
                    if (accountDetails[0].equals(user) && accountDetails[1].equals(pass)) {
                        loginSuccess = true;
                        break; // We found a match, so stop searching!
                    }
                }
                br.close(); // Always close the reader to save memory
            }
        } catch (IOException e) {
            System.out.println("Error reading the restaurant file!");
            e.printStackTrace();
        }

        // 3. Direct traffic based on the result
        if (loginSuccess) {
            System.out.println("--- LOGIN SUCCESSFUL for user: " + user + " ---");
            response.sendRedirect("index.jsp"); // Let them into the dashboard
        } else {
            System.out.println("--- LOGIN FAILED: Invalid credentials ---");
            response.sendRedirect("login.jsp"); // Kick them back to the login page
        }
    }
}