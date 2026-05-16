package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;

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

        // 1. Capture the updated data from the form
        String targetName  = request.getParameter("restaurantName");
        String newPassword = request.getParameter("newPassword");
        String newPhone    = request.getParameter("contactNumber");
        String newAddress  = request.getParameter("restaurantAddress");

        // Using ArrayList - as covered in the course
        ArrayList<String> fileLines = new ArrayList<>();

        try {
            File file = new File(FILE_PATH);
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");

                // Find the matching restaurant and update Password (1), Phone (4), Address (5)
                if (details[3].equals(targetName)) {
                    line = details[0] + "," + newPassword + "," + details[2] + ","
                         + details[3] + "," + newPhone + "," + newAddress + "," + details[6];
                }

                fileLines.add(line);
            }
            br.close();

            // Overwrite the file with updated data
            PrintWriter pw = new PrintWriter(new FileWriter(file, false));
            for (String finalLine : fileLines) {
                pw.println(finalLine);
            }
            pw.close();

            System.out.println("--- PROFILE UPDATED FOR: " + targetName + " ---");

            // Update the session so the UI reflects changes immediately
            session.setAttribute("contactNumber",     newPhone);
            session.setAttribute("restaurantAddress", newAddress);

        } catch (IOException e) {
            System.out.println("Error updating the restaurant file!");
            e.printStackTrace();
        }

        response.sendRedirect("index.jsp");
    }
}
