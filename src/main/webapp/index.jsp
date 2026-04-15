<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Dashboard | Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800 font-sans">

    <nav class="bg-black text-white p-4 shadow-md flex justify-between items-center">
        <div class="text-2xl font-bold tracking-tight">UberEats <span class="text-green-500">Partner</span></div>
        <div class="flex items-center space-x-4">
            <span class="text-sm font-medium">Welcome, ${restaurantName}</span>
<a href="logoutRestaurant" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded text-sm font-bold transition">Log Out</a>        </div>
    </nav>

    <div class="flex min-h-screen">
        <aside class="w-64 bg-white border-r border-gray-200 p-6 hidden md:block">
            <ul class="space-y-4 text-sm font-medium text-gray-600">
                <li><a href="#" class="block p-2 text-black bg-gray-100 rounded">Dashboard</a></li>
                <li><a href="#" class="block p-2 hover:bg-gray-50 hover:text-black rounded">Edit Profile</a></li>
                <li><a href="#" class="block p-2 hover:bg-gray-50 hover:text-black rounded">Menu Management</a></li>
                <li><a href="#" class="block p-2 text-red-500 hover:bg-red-50 rounded mt-8">Delete Account</a></li>
            </ul>
        </aside>

        <main class="flex-1 p-8">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Restaurant Profile</h1>
                    <p class="text-gray-500 mt-1">Manage your details and restaurant status.</p>
                </div>
                <div class="flex items-center space-x-3 bg-white p-3 rounded-lg shadow-sm border border-gray-200">
                    <span class="text-sm font-bold text-gray-700">Accepting Orders:</span>
                    <span class="bg-green-100 text-green-800 text-xs font-bold px-3 py-1 rounded-full">OPEN</span>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 max-w-2xl">
                <form action="updateRestaurant" method="POST">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Restaurant Name</label>
                            <input type="text" name="restaurantName" value="${restaurantName}" class="w-full border border-gray-300 rounded-lg p-2.5 bg-gray-50 focus:outline-none" readonly>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Contact Number</label>
                            <input type="text" name="contactNumber" value="${contactNumber}" class="w-full border border-gray-300 rounded-lg p-2.5 focus:ring-black focus:border-black">
                        </div>
                    </div>
                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Restaurant Address</label>
                        <input type="text" name="restaurantAddress" value="${restaurantAddress}" class="w-full border border-gray-300 rounded-lg p-2.5 focus:ring-black focus:border-black">
                    </div>

                    <div class="flex justify-end">
                        <button type="submit" class="bg-black hover:bg-gray-800 text-white font-bold py-2 px-6 rounded-lg transition">Update Profile</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>