package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/updateRestaurant")
public class UpdateServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\FoodDeliveryData\\restaurants.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("restaurantName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Capture the new data (Name comes from the hidden input!)
        String targetName = request.getParameter("restaurantName");
        String newPassword = request.getParameter("newPassword");
        String newPhone = request.getParameter("contactNumber");
        String newAddress = request.getParameter("restaurantAddress");

        List<String> fileLines = new ArrayList<>();

        try {
            File file = new File(FILE_PATH);
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");

                // If we find the correct restaurant, update Password (Index 1), Phone (Index 4), and Address (Index 5)
                if (details[3].equals(targetName)) {
                    line = details[0] + "," + newPassword + "," + details[2] + "," +
                            details[3] + "," + newPhone + "," + newAddress;
                }

                fileLines.add(line);
            }
            br.close();

            // Overwrite the file
            PrintWriter pw = new PrintWriter(new FileWriter(file, false));
            for (String finalLine : fileLines) {
                pw.println(finalLine);
            }
            pw.close();

            System.out.println("--- PROFILE AND PASSWORD UPDATED FOR: " + targetName + " ---");

            // Update session data
            session.setAttribute("contactNumber", newPhone);
            session.setAttribute("restaurantAddress", newAddress);

        } catch (IOException e) {
            System.out.println("Error updating the restaurant file!");
            e.printStackTrace();
        }

        response.sendRedirect("index.jsp");
    }
}