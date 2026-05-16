package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {

    private static final String RESTAURANT_FILE = "C:\\FoodDeliveryData\\restaurants.txt";
    private static final String STATUS_FILE     = "C:\\FoodDeliveryData\\status.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Verify someone is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("restaurantName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String targetName = (String) session.getAttribute("restaurantName");

        // 2. Remove from restaurants.txt (name is at index 3)
        removeRecordFromFile(RESTAURANT_FILE, targetName, 3);

        // 3. Remove from status.txt (name is at index 0)
        removeRecordFromFile(STATUS_FILE, targetName, 0);

        // 4. Destroy the session
        session.invalidate();
        System.out.println("--- ACCOUNT PERMANENTLY DELETED FOR: " + targetName + " ---");

        // 5. Redirect to sign-up page
        response.sendRedirect("signup.jsp");
    }

    /**
     * Reusable helper method (DRY Principle).
     * Reads the file, skips the matching record, and rewrites the rest.
     */
    private void removeRecordFromFile(String filePath, String targetName, int nameColumnIndex) {
        ArrayList<String> fileLines = new ArrayList<>();

        try {
            File file = new File(filePath);
            if (!file.exists()) return;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");
                // Only keep lines that do NOT match the target
                if (!details[nameColumnIndex].equals(targetName)) {
                    fileLines.add(line);
                }
            }
            br.close();

            // Overwrite the file with the filtered list
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
