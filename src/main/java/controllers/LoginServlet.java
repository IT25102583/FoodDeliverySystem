package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // New import for Sessions!

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/loginRestaurant")
public class LoginServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\FoodDeliveryData\\restaurants.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        boolean loginSuccess = false;
        String[] loggedInDetails = null; // Create a variable to hold the data when we find a match

        try {
            File file = new File(FILE_PATH);

            if (file.exists()) {
                BufferedReader br = new BufferedReader(new FileReader(file));
                String line;

                while ((line = br.readLine()) != null) {
                    String[] accountDetails = line.split(",");

                    if (accountDetails[0].equals(user) && accountDetails[1].equals(pass)) {
                        loginSuccess = true;
                        loggedInDetails = accountDetails; // Save the matched row of data!
                        break;
                    }
                }
                br.close();
            }
        } catch (IOException e) {
            System.out.println("Error reading the restaurant file!");
            e.printStackTrace();
        }

        if (loginSuccess) {
            System.out.println("--- LOGIN SUCCESSFUL for user: " + user + " ---");

            // --- NEW SESSION CODE ---
            // Create a VIP wristband (Session) and attach the specific restaurant's data to it
            HttpSession session = request.getSession();
            session.setAttribute("restaurantName", loggedInDetails[3]); // Index 3 is the Name
            session.setAttribute("contactNumber", loggedInDetails[4]); // Index 4 is the Phone
            session.setAttribute("restaurantAddress", loggedInDetails[5]); // Index 5 is the Address

            response.sendRedirect("index.jsp");
        } else {
            System.out.println("--- LOGIN FAILED: Invalid credentials ---");
            response.sendRedirect("login.jsp");
        }
    }
}