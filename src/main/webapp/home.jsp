<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome | Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen font-sans">

    <div class="max-w-6xl w-full px-6 py-12">

        <div class="text-center mb-16">
            <h1 class="text-5xl font-extrabold tracking-tight text-black mb-4">
                Welcome to <span class="text-green-500">UberEats</span>
            </h1>
            <p class="text-xl text-gray-500">How would you like to use our platform today?</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

            <a href="#" class="group bg-white rounded-3xl shadow-sm border border-gray-200 p-10 text-center hover:shadow-xl hover:border-green-500 transition duration-300 transform hover:-translate-y-2">
                <div class="w-20 h-20 mx-auto bg-green-50 rounded-full flex items-center justify-center mb-6 group-hover:bg-green-100 transition">
                    <span class="text-4xl">🍔</span>
                </div>
                <h2 class="text-2xl font-bold text-gray-900 mb-3">Hungry Customer</h2>
                <p class="text-gray-500 mb-8">Order delicious food from your favorite local restaurants delivered to your door.</p>
                <span class="inline-block bg-black text-white font-bold py-3 px-8 rounded-full group-hover:bg-green-500 transition">Order Food</span>
            </a>

            <a href="#" class="group bg-white rounded-3xl shadow-sm border border-gray-200 p-10 text-center hover:shadow-xl hover:border-green-500 transition duration-300 transform hover:-translate-y-2">
                <div class="w-20 h-20 mx-auto bg-blue-50 rounded-full flex items-center justify-center mb-6 group-hover:bg-blue-100 transition">
                    <span class="text-4xl">🛵</span>
                </div>
                <h2 class="text-2xl font-bold text-gray-900 mb-3">Delivery Driver</h2>
                <p class="text-gray-500 mb-8">Be your own boss. Deliver food, set your own hours, and earn money on your schedule.</p>
                <span class="inline-block bg-black text-white font-bold py-3 px-8 rounded-full group-hover:bg-blue-500 transition">Start Driving</span>
            </a>

            <a href="login.jsp" class="group bg-white rounded-3xl shadow-sm border border-gray-200 p-10 text-center hover:shadow-xl hover:border-green-500 transition duration-300 transform hover:-translate-y-2 relative overflow-hidden">
                <div class="absolute top-0 right-0 bg-green-500 text-white text-xs font-bold px-3 py-1 rounded-bl-lg">LIVE</div>
                <div class="w-20 h-20 mx-auto bg-orange-50 rounded-full flex items-center justify-center mb-6 group-hover:bg-orange-100 transition">
                    <span class="text-4xl">🏪</span>
                </div>
                <h2 class="text-2xl font-bold text-gray-900 mb-3">Restaurant Partner</h2>
                <p class="text-gray-500 mb-8">Manage your menu, track incoming orders, and grow your local business with us.</p>
                <span class="inline-block bg-black text-white font-bold py-3 px-8 rounded-full group-hover:bg-orange-500 transition">Manage Restaurant</span>
            </a>

        </div>

        <div class="text-center mt-16 text-sm text-gray-400">
            &copy; 2026 Food Delivery System. Built for SLIIT.
        </div>

    </div>
</body>
</html>