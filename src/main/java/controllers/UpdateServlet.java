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

        // 1. Grab the session to ensure a user is actually logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("restaurantName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Capture the new data from the HTML form
        String targetName = request.getParameter("restaurantName"); // The readonly name field
        String newPhone = request.getParameter("contactNumber");
        String newAddress = request.getParameter("restaurantAddress");

        // 3. Read all current records into memory (an ArrayList)
        List<String> fileLines = new ArrayList<>();

        try {
            File file = new File(FILE_PATH);
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                // Split the row by commas to check the data
                String[] details = line.split(",");

                // Index 3 is the Restaurant Name. If it matches, we update this row!
                if (details[3].equals(targetName)) {
                    // Rebuild the CSV string with the original account info, but NEW phone and address
                    line = details[0] + "," + details[1] + "," + details[2] + "," +
                            details[3] + "," + newPhone + "," + newAddress;
                }

                // Add the line (whether it was updated or left original) to our memory list
                fileLines.add(line);
            }
            br.close();

            // 4. Overwrite the file with our updated list!
            // (The 'false' in FileWriter means "Overwrite everything", instead of append)
            PrintWriter pw = new PrintWriter(new FileWriter(file, false));
            for (String finalLine : fileLines) {
                pw.println(finalLine);
            }
            pw.close();

            System.out.println("--- PROFILE UPDATED IN FILE FOR: " + targetName + " ---");

            // 5. CRITICAL: Update the Session Wristband so the UI changes immediately without re-logging in!
            session.setAttribute("contactNumber", newPhone);
            session.setAttribute("restaurantAddress", newAddress);

        } catch (IOException e) {
            System.out.println("Error updating the restaurant file!");
            e.printStackTrace();
        }

        // 6. Send them back to the dashboard to see their shiny new data
        response.sendRedirect("index.jsp");
    }
}