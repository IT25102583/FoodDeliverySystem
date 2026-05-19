<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800 font-sans">

<nav class="bg-black text-white p-4 shadow-md flex justify-between items-center">
    <div class="text-2xl font-bold tracking-tight">UberEats <span class="text-green-500">Partner</span></div>
    <div class="flex items-center space-x-4">
        <span class="text-sm font-medium">Welcome, ${restaurantName}</span>
        <a href="logoutRestaurant" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded text-sm font-bold transition">Log Out</a>
    </div>
</nav>

<div class="flex min-h-screen">

    <%-- ── SIDEBAR ─────────────────────────────────────────────────────────── --%>
    <aside class="w-64 bg-white border-r border-gray-200 p-6 hidden md:block">
        <ul class="space-y-4 text-sm font-medium text-gray-600">
            <li><a href="index.jsp" class="block p-2 hover:bg-gray-50 hover:text-black rounded transition">Dashboard</a></li>
            <li><a href="editProfile.jsp" class="block p-2 text-black bg-gray-100 font-bold rounded shadow-sm">Edit Profile</a></li>

            <li><a href="menuItems" class="block p-2 hover:bg-gray-50 hover:text-black rounded transition">🍽️ Menu Management</a></li>
            <li>
                <a href="deleteAccount" onclick="return confirm('Are you absolutely sure you want to permanently delete your restaurant? This cannot be undone.');" class="block p-2 text-red-500 hover:bg-red-50 hover:text-red-600 font-bold rounded mt-8 transition">
                    Delete Account
                </a>
            </li>
        </ul>
    </aside>

    <%-- ── MAIN CONTENT ───────────────────────────────────────────────────── --%>
    <main class="flex-1 p-8">

        <div>
            <h1 class="text-3xl font-bold text-gray-900 mb-8">Account Settings</h1>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 max-w-2xl mb-10">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Edit Profile Details</h2>

            <%-- NEW SUCCESS MESSAGE BOX (Hidden by default) --%>
                    <div id="successBox" class="hidden items-center bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-6 text-sm font-bold shadow-sm max-w-2xl">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        Profile updated successfully!
                    </div>
                    <form action="updateRestaurant" method="POST" onsubmit="sessionStorage.setItem('profileUpdated', 'true');">

                <input type="hidden" name="restaurantName" value="${restaurantName}">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">New Password</label>
                        <input type="password" name="newPassword"
                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
                               title="Must contain at least 8 characters, including at least 1 number, 1 uppercase, and 1 lowercase letter."
                               placeholder="Enter new password"
                               class="w-full border border-gray-300 rounded-lg p-2.5 bg-white focus:ring-black focus:border-black" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Contact Number</label>
                        <input type="text" name="contactNumber" value="${contactNumber}"
                               pattern="^(\d{10})$"
                               title="Phone number must be exactly 10 digits."
                               class="w-full border border-gray-300 rounded-lg p-2.5 focus:ring-black focus:border-black" required>
                    </div>
                </div>
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Restaurant Address</label>
                    <input type="text" name="restaurantAddress" value="${restaurantAddress}"
                           class="w-full border border-gray-300 rounded-lg p-2.5 focus:ring-black focus:border-black" required>
                </div>
                <div class="flex justify-end">
                    <button type="submit" class="bg-black hover:bg-gray-800 text-white font-bold py-2 px-6 rounded-lg transition">Update Profile</button>
                </div>
            </form>
        </div>

    </main>
</div>

<script>
        // When the page loads, check if they just updated their profile
        if (sessionStorage.getItem('profileUpdated') === 'true') {

            // Un-hide the success box by removing the 'hidden' class
            // And add the 'flex' class to make it format correctly
            const successBox = document.getElementById('successBox');
            successBox.classList.remove('hidden');
            successBox.classList.add('flex');

            // Rip up the secret note so it doesn't show again if they refresh
            sessionStorage.removeItem('profileUpdated');
        }
    </script>

</body>
</html>