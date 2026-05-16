package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;

@WebServlet("/toggleStatus")
public class ToggleStatusServlet extends HttpServlet {

    private static final String STATUS_FILE = "C:\\FoodDeliveryData\\status.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Verify who is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("restaurantName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String restaurantName = (String) session.getAttribute("restaurantName");
        String currentStatus  = (String) session.getAttribute("restaurantStatus");

        // 2. Flip the status
        String newStatus = (currentStatus == null || currentStatus.equals("CLOSED")) ? "OPEN" : "CLOSED";

        // 3. Read and update the status file
        ArrayList<String> fileLines = new ArrayList<>();
        boolean found = false;

        try {
            File file = new File(STATUS_FILE);

            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");
                if (details[0].equals(restaurantName)) {
                    line = restaurantName + "," + newStatus;
                    found = true;
                }
                fileLines.add(line);
            }
            br.close();

            // First time toggling - add a new entry for this restaurant
            if (!found) {
                fileLines.add(restaurantName + "," + newStatus);
            }

            // 4. Overwrite the file with updated data
            PrintWriter pw = new PrintWriter(new FileWriter(file, false));
            for (String finalLine : fileLines) {
                pw.println(finalLine);
            }
            pw.close();

            // 5. Update the session so the button changes color immediately
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
