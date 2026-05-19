<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Menu Items — FoodRush</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --bg: #f5f6fa;
      --surface: #ffffff;
      --border: #e8eaed;
      --accent: #22c55e;
      --accent2: #16a34a;
      --text: #1a1a2e;
      --muted: #6b7280;
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; min-height: 100vh; }
    nav {
      background: #fff;
      border-bottom: 1px solid var(--border);
      padding: 0 2rem; height: 64px;
      display: flex; align-items: center; justify-content: space-between;
      position: sticky; top: 0; z-index: 100;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    }
    .brand { font-size: 1.4rem; font-weight: 700; color: var(--accent2); }
    .brand span { color: var(--text); }
    .nav-add {
      background: var(--accent); color: #fff; text-decoration: none;
      padding: .5rem 1.2rem; border-radius: 8px; font-weight: 600; font-size: .875rem;
    }
    .nav-add:hover { background: var(--accent2); }
    .container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
    /* Our new Back Button styles */
        .back-link {
            display: inline-flex;
            align-items: center;
            color: var(--muted);
            text-decoration: none;
            font-size: .875rem;
            font-weight: 600;
            margin-bottom: 1rem;
            transition: color 0.15s;
        }
        .back-link:hover { color: var(--accent2); }
        .back-link svg { width: 18px; height: 18px; margin-right: 6px; }
    .page-title { font-size: 1.75rem; font-weight: 700; margin-bottom: .25rem; }
    .page-title span { color: var(--accent2); }
    .item-count { color: var(--muted); font-size: .875rem; margin-bottom: 1.5rem; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: .75rem 1.25rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: .875rem; }
    .toolbar { display: flex; gap: .75rem; margin-bottom: 1.5rem; flex-wrap: wrap; }
    .search-wrap { position: relative; flex: 1; min-width: 200px; }
    .search-wrap svg { position: absolute; left: .9rem; top: 50%; transform: translateY(-50%); color: var(--muted); pointer-events: none; }
    .search-input { width: 100%; background: #fff; border: 1px solid var(--border); color: var(--text); padding: .6rem .9rem .6rem 2.5rem; border-radius: 8px; font-family: inherit; font-size: .9rem; outline: none; }
    .search-input:focus { border-color: var(--accent); }
    .filter-select { background: #fff; border: 1px solid var(--border); color: var(--text); padding: .6rem 1rem; border-radius: 8px; font-family: inherit; font-size: .9rem; outline: none; cursor: pointer; }
    .search-btn { background: var(--accent); color: #fff; border: none; padding: .6rem 1.25rem; border-radius: 8px; font-family: inherit; font-size: .9rem; font-weight: 600; cursor: pointer; }
    .search-btn:hover { background: var(--accent2); }
    .table-wrap { background: #fff; border: 1px solid var(--border); border-radius: 12px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    table { width: 100%; border-collapse: collapse; }
    thead th { background: #f9fafb; padding: .875rem 1.25rem; text-align: left; font-size: .75rem; font-weight: 600; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); border-bottom: 1px solid var(--border); }
    tbody tr { border-bottom: 1px solid var(--border); transition: background .15s; }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: #f0fdf4; }
    td { padding: 1rem 1.25rem; font-size: .9rem; vertical-align: middle; }
    .item-name { font-weight: 600; }
    .item-desc { color: var(--muted); font-size: .8rem; max-width: 260px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .category-badge { background: #dcfce7; color: #166534; padding: .2rem .65rem; border-radius: 20px; font-size: .78rem; font-weight: 600; }
    .price { font-weight: 700; }
    .status-badge { padding: .2rem .65rem; border-radius: 20px; font-size: .78rem; font-weight: 600; }
    .status-badge.available { background: #dcfce7; color: #166534; }
    .status-badge.unavailable { background: #fee2e2; color: #991b1b; }
    .actions { display: flex; gap: .5rem; }
    .btn-edit, .btn-delete { padding: .35rem .85rem; border-radius: 6px; font-size: .8rem; font-weight: 600; text-decoration: none; }
    .btn-edit { background: #dbeafe; color: #1d4ed8; }
    .btn-delete { background: #fee2e2; color: #dc2626; }
    .btn-edit:hover, .btn-delete:hover { opacity: .8; }
    .empty { text-align: center; padding: 4rem 2rem; color: var(--muted); }
    .empty p { font-size: 1.1rem; margin-bottom: 1.5rem; margin-top: 1rem; }
    .empty a { color: var(--accent2); text-decoration: none; font-weight: 600; }
  </style>
</head>
<body>
<nav>
  <div class="brand">Food<span>Rush</span></div>
  <a href="${pageContext.request.contextPath}/menuItems?action=add" class="nav-add">+ Add Item</a>
</nav>
<div class="container">

  <c:if test="${not empty param.success}">
    <div class="flash">✓ ${param.success}</div>
  </c:if>

  <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">
      <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
      </svg>
      Back to Dashboard.
  </a>

  <h1 class="page-title">Menu <span>Items</span></h1>
  <p class="item-count">
    <c:choose>
      <c:when test="${not empty items}">${items.size()} item(s) found</c:when>
      <c:otherwise>No items yet</c:otherwise>
    </c:choose>
  </p>
  <form method="get" action="${pageContext.request.contextPath}/menuItems" class="toolbar">
    <input type="hidden" name="action" value="search"/>
    <div class="search-wrap">
      <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <circle cx="11" cy="11" r="8"/><path stroke-linecap="round" d="m21 21-4.35-4.35"/>
      </svg>
      <input class="search-input" type="text" name="q" placeholder="Search items…" value="${not empty query ? query : ''}"/>
    </div>
    <select class="filter-select" name="category" onchange="this.form.action='${pageContext.request.contextPath}/menuItems';this.form.submit()">
      <option value="">All Categories</option>
      <c:forEach items="${categories}" var="cat">
        <option value="${cat}">${cat}</option>
      </c:forEach>
    </select>
    <button class="search-btn" type="submit">Search</button>
  </form>
  <div class="table-wrap">
    <c:choose>
      <c:when test="${not empty items}">
        <table>
          <thead>
            <tr><th>Item</th><th>Category</th><th>Price (LKR)</th><th>Status</th><th>Actions</th></tr>
          </thead>
          <tbody>
            <c:forEach items="${items}" var="item">
              <tr>
                <td>
                  <div class="item-name">${item.name}</div>
                  <div class="item-desc">${item.description}</div>
                </td>
                <td><span class="category-badge">${item.category}</span></td>
                <td class="price"><fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                <td>
                  <c:choose>
                    <c:when test="${item.available}"><span class="status-badge available">Available</span></c:when>
                    <c:otherwise><span class="status-badge unavailable">Unavailable</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div class="actions">
                    <a href="${pageContext.request.contextPath}/menuItems?action=edit&id=${item.id}" class="btn-edit">Edit</a>
                    <a href="${pageContext.request.contextPath}/menuItems?action=delete&id=${item.id}" class="btn-delete">Delete</a>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:when>
      <c:otherwise>
        <div class="empty">
          <svg width="56" height="56" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
          </svg>
          <p>No menu items found.</p>
          <a href="${pageContext.request.contextPath}/menuItems?action=add">Add your first item →</a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>
