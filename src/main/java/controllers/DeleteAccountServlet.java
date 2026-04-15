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

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {

    // We need the paths to BOTH files so we can clean up everything
    private static final String RESTAURANT_FILE = "C:\\FoodDeliveryData\\restaurants.txt";
    private static final String STATUS_FILE = "C:\\FoodDeliveryData\\status.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Verify someone is actually logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("restaurantName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String targetName = (String) session.getAttribute("restaurantName");

        // 2. Wipe them from restaurants.txt (The name is at index 3 in the comma-separated row)
        removeRecordFromFile(RESTAURANT_FILE, targetName, 3);

        // 3. Wipe them from status.txt (The name is at index 0 in this file)
        removeRecordFromFile(STATUS_FILE, targetName, 0);

        // 4. Rip up the Session Wristband
        session.invalidate();
        System.out.println("--- ACCOUNT PERMANENTLY DELETED FOR: " + targetName + " ---");

        // 5. Boot them back to the Sign-Up page
        response.sendRedirect("signup.jsp");
    }

    /**
     * A reusable File I/O Helper Method (DRY Principle)
     * It reads a file, keeps every line EXCEPT the one we want to delete, and overwrites the file.
     */
    private void removeRecordFromFile(String filePath, String targetName, int nameColumnIndex) {
        List<String> fileLines = new ArrayList<>();

        try {
            File file = new File(filePath);
            if (!file.exists()) return; // If file doesn't exist, nothing to delete!

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");

                // If the name in this row DOES NOT match our target, we save it to memory.
                // If it DOES match, we ignore it (which effectively deletes it!).
                if (!details[nameColumnIndex].equals(targetName)) {
                    fileLines.add(line);
                }
            }
            br.close();

            // Overwrite the file with our filtered list
            PrintWriter pw = new PrintWriter(new FileWriter(file, false));
            for (String finalLine : fileLines) {
                pw.println(finalLine);
            }
            pw.close();

        } catch (IOException e) {
            System.out.println("Error deleting from file: " + filePath);
            e.printStackTrace();
        }
    }
}