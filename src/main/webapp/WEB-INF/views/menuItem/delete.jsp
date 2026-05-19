<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Delete Menu Item — FoodRush</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <style>
    :root { --bg: #f5f6fa; --surface: #ffffff; --border: #e8eaed; --accent: #22c55e; --accent2: #16a34a; --text: #1a1a2e; --muted: #6b7280; --danger: #ef4444; }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; min-height: 100vh; }
    nav { background: #fff; border-bottom: 1px solid var(--border); padding: 0 2rem; height: 64px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .brand { font-size: 1.4rem; font-weight: 700; color: var(--accent2); }
    .brand span { color: var(--text); }
    .back-link { color: var(--muted); text-decoration: none; font-size: .875rem; }
    .back-link:hover { color: var(--accent2); }
    .container { max-width: 500px; margin: 5rem auto; padding: 0 2rem; }
    .card { background: #fff; border: 1px solid var(--border); border-radius: 16px; padding: 2.5rem; text-align: center; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    .icon-wrap { width: 72px; height: 72px; background: #fee2e2; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; }
    .icon-wrap svg { color: var(--danger); }
    .card-title { font-size: 1.75rem; font-weight: 700; margin-bottom: .5rem; }
    .card-title span { color: var(--danger); }
    .card-sub { color: var(--muted); font-size: .9rem; margin-bottom: 2rem; line-height: 1.6; }
    .item-box { background: #f9fafb; border: 1px solid var(--border); border-radius: 10px; padding: 1.25rem; margin-bottom: 2rem; text-align: left; }
    .item-box-name { font-weight: 600; font-size: 1.05rem; margin-bottom: .4rem; }
    .item-box-row { display: flex; justify-content: space-between; font-size: .82rem; color: var(--muted); margin-top: .3rem; }
    .category-badge { background: #dcfce7; color: #166534; padding: .15rem .55rem; border-radius: 20px; font-size: .75rem; font-weight: 600; }
    .btn-row { display: flex; gap: .75rem; justify-content: center; }
    .btn-cancel { background: transparent; border: 1px solid var(--border); color: var(--muted); padding: .65rem 1.75rem; border-radius: 8px; font-family: inherit; font-size: .9rem; cursor: pointer; text-decoration: none; }
    .btn-cancel:hover { border-color: var(--muted); color: var(--text); }
    .btn-delete { background: var(--danger); border: none; color: #fff; padding: .65rem 1.75rem; border-radius: 8px; font-family: inherit; font-size: .9rem; font-weight: 600; cursor: pointer; }
    .btn-delete:hover { background: #dc2626; }
  </style>
</head>
<body>
<nav>
  <div class="brand">Food<span>Rush</span></div>
  <a href="${pageContext.request.contextPath}/menuItems" class="back-link">← Back to Menu Items</a>
</nav>
<div class="container">
  <div class="card">
    <div class="icon-wrap">
      <svg width="36" height="36" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v4m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
      </svg>
    </div>
    <h1 class="card-title">Delete <span>Item?</span></h1>
    <p class="card-sub">This action cannot be undone. The item will be permanently removed from the menu.</p>
    <div class="item-box">
      <div class="item-box-name">${item.name}</div>
      <div class="item-box-row">
        <span class="category-badge">${item.category}</span>
        <span>LKR <strong>${item.price}</strong></span>
      </div>
      <div class="item-box-row" style="margin-top:.6rem;">
        <span>${item.description}</span>
      </div>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/menuItems">
      <input type="hidden" name="action" value="delete"/>
      <input type="hidden" name="id" value="${item.id}"/>
      <div class="btn-row">
        <a href="${pageContext.request.contextPath}/menuItems" class="btn-cancel">Cancel</a>
        <button type="submit" class="btn-delete">Yes, Delete</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
