<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Menu Item — FoodRush</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <style>
    :root { --bg: #f5f6fa; --surface: #ffffff; --border: #e8eaed; --accent: #22c55e; --accent2: #16a34a; --text: #1a1a2e; --muted: #6b7280; }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; min-height: 100vh; }
    nav { background: #fff; border-bottom: 1px solid var(--border); padding: 0 2rem; height: 64px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
    .brand { font-size: 1.4rem; font-weight: 700; color: var(--accent2); }
    .brand span { color: var(--text); }
    .back-link { color: var(--muted); text-decoration: none; font-size: .875rem; }
    .back-link:hover { color: var(--accent2); }
    .container { max-width: 700px; margin: 0 auto; padding: 2.5rem 2rem; }
    .form-card { background: #fff; border: 1px solid var(--border); border-radius: 16px; padding: 2.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    .form-title { font-size: 1.75rem; font-weight: 700; margin-bottom: .25rem; }
    .form-title span { color: var(--accent2); }
    .form-sub { color: var(--muted); font-size: .875rem; margin-bottom: 1rem; }
    .id-chip { display: inline-block; background: #dcfce7; color: #166534; border-radius: 6px; padding: .15rem .6rem; font-size: .75rem; font-family: monospace; margin-bottom: 1.5rem; }
    .field-group { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; }
    .field { display: flex; flex-direction: column; gap: .4rem; margin-bottom: 1.25rem; }
    .field.full { grid-column: 1 / -1; }
    label { font-size: .8rem; font-weight: 600; letter-spacing: .04em; text-transform: uppercase; color: var(--muted); }
    input[type="text"], input[type="number"], input[type="url"], select, textarea {
      background: #f9fafb; border: 1px solid var(--border); color: var(--text);
      padding: .7rem 1rem; border-radius: 8px; font-family: inherit; font-size: .9rem; outline: none; width: 100%;
    }
    input:focus, select:focus, textarea:focus { border-color: var(--accent); background: #fff; }
    textarea { resize: vertical; min-height: 90px; }
    .toggle-row { display: flex; align-items: center; justify-content: space-between; background: #f9fafb; border: 1px solid var(--border); border-radius: 8px; padding: .75rem 1rem; margin-bottom: 1.25rem; }
    .toggle-label { font-size: .9rem; font-weight: 500; }
    .toggle-sub { font-size: .78rem; color: var(--muted); }
    .toggle { position: relative; width: 44px; height: 24px; }
    .toggle input { opacity: 0; width: 0; height: 0; }
    .slider { position: absolute; inset: 0; background: #d1d5db; border-radius: 24px; cursor: pointer; transition: background .25s; }
    .slider::before { content: ''; position: absolute; left: 3px; top: 3px; width: 18px; height: 18px; background: #fff; border-radius: 50%; transition: transform .25s; }
    .toggle input:checked + .slider { background: var(--accent); }
    .toggle input:checked + .slider::before { transform: translateX(20px); }
    .divider { border: none; border-top: 1px solid var(--border); margin: 1.5rem 0; }
    .btn-row { display: flex; gap: .75rem; justify-content: flex-end; }
    .btn-cancel { background: transparent; border: 1px solid var(--border); color: var(--muted); padding: .65rem 1.5rem; border-radius: 8px; font-family: inherit; font-size: .9rem; cursor: pointer; text-decoration: none; }
    .btn-cancel:hover { border-color: var(--muted); color: var(--text); }
    .btn-save { background: var(--accent); border: none; color: #fff; padding: .65rem 2rem; border-radius: 8px; font-family: inherit; font-size: .9rem; font-weight: 600; cursor: pointer; }
    .btn-save:hover { background: var(--accent2); }
    @media (max-width: 560px) { .field-group { grid-template-columns: 1fr; } }
  </style>
</head>
<body>
<nav>
  <div class="brand">Food<span>Rush</span></div>
  <a href="${pageContext.request.contextPath}/menuItems" class="back-link">← Back to Menu Items</a>
</nav>
<div class="container">
  <div class="form-card">
    <h1 class="form-title">Edit Menu <span>Item</span></h1>
    <p class="form-sub">Update the details of this menu item.</p>
    <div class="id-chip">ID: ${item.id}</div>
    <form method="post" action="${pageContext.request.contextPath}/menuItems">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" value="${item.id}"/>
      <div class="field-group">
        <div class="field full">
          <label for="name">Item Name *</label>
          <input id="name" name="name" type="text" value="${item.name}" required/>
        </div>
        <div class="field">
          <label for="category">Category *</label>
          <select id="category" name="category" required>
            <option value="Appetizer"   ${item.category == 'Appetizer'   ? 'selected' : ''}>Appetizer</option>
            <option value="Main Course" ${item.category == 'Main Course' ? 'selected' : ''}>Main Course</option>
            <option value="Dessert"     ${item.category == 'Dessert'     ? 'selected' : ''}>Dessert</option>
            <option value="Beverage"    ${item.category == 'Beverage'    ? 'selected' : ''}>Beverage</option>
            <option value="Side Dish"   ${item.category == 'Side Dish'   ? 'selected' : ''}>Side Dish</option>
            <option value="Combo Meal"  ${item.category == 'Combo Meal'  ? 'selected' : ''}>Combo Meal</option>
          </select>
        </div>
        <div class="field">
          <label for="price">Price (LKR) *</label>
          <input id="price" name="price" type="number" min="0" step="0.01" value="${item.price}" required/>
        </div>
        <div class="field full">
          <label for="description">Description</label>
          <textarea id="description" name="description">${item.description}</textarea>
        </div>
        <div class="field full">
          <label for="imageUrl">Image URL</label>
          <input id="imageUrl" name="imageUrl" type="url" value="${item.imageUrl}"/>
        </div>
      </div>
      <div class="toggle-row">
        <div>
          <div class="toggle-label">Available for Order</div>
          <div class="toggle-sub">Customers can see and order this item</div>
        </div>
        <label class="toggle">
          <input type="checkbox" name="available" ${item.available ? 'checked' : ''}/>
          <span class="slider"></span>
        </label>
      </div>
      <hr class="divider"/>
      <div class="btn-row">
        <a href="${pageContext.request.contextPath}/menuItems" class="btn-cancel">Cancel</a>
        <button type="submit" class="btn-save">Update Item</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
