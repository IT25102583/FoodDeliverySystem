<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Partner Login | Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen font-sans">
<a href="home.jsp" class="absolute top-6 left-6 flex items-center text-gray-500 hover:text-black transition font-bold text-sm">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Back to Home
    </a>
    <div class="w-full max-w-md bg-white rounded-2xl shadow-sm border border-gray-200 p-8 m-4">

        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold tracking-tight text-black">UberEats <span class="text-green-500">Partner</span></h1>
            <p class="text-gray-500 mt-2">Welcome back! Please log in to your account.</p>
        </div>

        <form action="loginRestaurant" method="POST" class="space-y-6">

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                <input type="text" name="username" required class="w-full border border-gray-300 rounded-lg p-3 focus:ring-black focus:border-black outline-none transition" placeholder="Enter your username">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                <input type="password" name="password" required class="w-full border border-gray-300 rounded-lg p-3 focus:ring-black focus:border-black outline-none transition" placeholder="Enter your password">
            </div>

            <button type="submit" class="w-full bg-black hover:bg-gray-800 text-white font-bold py-3.5 rounded-xl transition mt-4 shadow-md">
                Log In
            </button>
        </form>

        <div class="mt-8 text-center text-sm text-gray-600">
            Don't have a restaurant account yet? <br>
            <a href="signup.jsp" class="text-green-600 hover:text-green-700 hover:underline font-bold mt-1 inline-block">Register your restaurant here</a>
        </div>

    </div>
</body>
</html>