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

@WebServlet("/toggleStatus")
public class ToggleStatusServlet extends HttpServlet {

    // We create a separate file just to track who is open and who is closed!
    private static final String STATUS_FILE = "C:\\FoodDeliveryData\\status.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Grab the session to verify who is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("restaurantName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String restaurantName = (String) session.getAttribute("restaurantName");
        String currentStatus = (String) session.getAttribute("restaurantStatus");

        // 2. Flip the switch! If it's closed (or null), make it OPEN. Otherwise, make it CLOSED.
        String newStatus = (currentStatus == null || currentStatus.equals("CLOSED")) ? "OPEN" : "CLOSED";

        // 3. Read the file, find this restaurant, and update their row
        List<String> fileLines = new ArrayList<>();
        boolean found = false;

        try {
            File file = new File(STATUS_FILE);

            // If the file doesn't exist yet, we create it safely
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");
                if (details[0].equals(restaurantName)) {
                    // Overwrite the old status with the new one
                    line = restaurantName + "," + newStatus;
                    found = true;
                }
                fileLines.add(line);
            }
            br.close();

            // If this is the restaurant's first time clicking the button, add them to the list!
            if (!found) {
                fileLines.add(restaurantName + "," + newStatus);
            }

            // 4. Overwrite the file with the updated data
            PrintWriter pw = new PrintWriter(new FileWriter(file, false));
            for (String finalLine : fileLines) {
                pw.println(finalLine);
            }
            pw.close();

            // 5. Update the Session Wristband so the UI button changes color immediately
            session.setAttribute("restaurantStatus", newStatus);
            System.out.println("--- STATUS TOGGLED TO " + newStatus + " FOR: " + restaurantName + " ---");

        } catch (IOException e) {
            System.out.println("Error updating status file!");
            e.printStackTrace();
        }

        // 6. Refresh the dashboard
        response.sendRedirect("index.jsp");
    }
}