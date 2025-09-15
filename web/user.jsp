<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sidhi's Store - Premium Online Shopping</title>
    <!-- Bootstrap 5.3 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="user_style.css">
</head>
<body>
    <!-- Enhanced Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar">
        <div class="container">
            <a class="navbar-brand" href="user.jsp">
                <i class="fas fa-shopping-bag"></i> Sidhi's Store
            </a>
            <div class="d-flex align-items-center">
                <a href="cart.jsp" class="nav-btn nav-btn-cart">
                    <i class="fas fa-shopping-cart"></i> Cart
                </a>
                <a href="logout.jsp" class="nav-btn nav-btn-logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <div class="container">
        <%
            String selectedCategory = request.getParameter("category");

            if (selectedCategory == null) {
        %>
        <!-- Hero Section -->
        <div class="hero-section fade-in">
            <div class="hero-title">
                <i class="fas fa-sparkles" style="color: var(--secondary-color);"></i>
                Welcome to Sidhi's Store
            </div>
            <div class="hero-subtitle">
                Discover amazing products across different categories. Your perfect shopping experience starts here!
            </div>
        </div>
        
        <!-- Category Section -->
        <div class="category-section">
            <h2 class="section-title">Shop by Category</h2>
            <div class="row g-4">
                <%
                    try {
                        String sql = "SELECT DISTINCT category FROM products";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            String catName = rs.getString("category");

                            // Enhanced icons and descriptions for categories
                            String icon = "fa-box";
                            String description = "Explore our collection";
                            
                            if ("Electronics".equalsIgnoreCase(catName)) {
                                icon = "fa-laptop";
                                description = "Latest tech & gadgets";
                            } else if ("Books".equalsIgnoreCase(catName)) {
                                icon = "fa-book-open";
                                description = "Knowledge & entertainment";
                            } else if ("Clothing".equalsIgnoreCase(catName)) {
                                icon = "fa-tshirt";
                                description = "Fashion & style";
                            } else if ("Home".equalsIgnoreCase(catName)) {
                                icon = "fa-home";
                                description = "Comfort & decor";
                            } else if ("Sports".equalsIgnoreCase(catName)) {
                                icon = "fa-dumbbell";
                                description = "Fitness & outdoor";
                            } else if ("Beauty".equalsIgnoreCase(catName)) {
                                icon = "fa-heart";
                                description = "Beauty & wellness";
                            } else if ("Toys".equalsIgnoreCase(catName)) {
                                icon = "fa-gamepad";
                                description = "Fun & games";
                            }
                %>
                    <div class="col-lg-3 col-md-4 col-sm-6 fade-in">
                        <a href="user.jsp?category=<%= catName %>" style="text-decoration:none; color:inherit;">
                            <div class="category-card">
                                <i class="fas <%= icon %> category-icon"></i>
                                <div class="category-title"><%= catName %></div>
                                <div class="category-desc"><%= description %></div>
                            </div>
                        </a>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger' role='alert'><i class='fas fa-exclamation-triangle'></i> Error loading categories: " + e.getMessage() + "</div>");
                    }
                %>
            </div>
        </div>

        <%
            } else {
        %>
        <!-- Products Section -->
        <div class="fade-in">
            <a href="user.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Categories
            </a>
            
            <div class="text-center mb-5">
                <h2 class="section-title"><%= selectedCategory %> Collection</h2>
                <p class="text-muted">Discover amazing products in <%= selectedCategory.toLowerCase() %> category</p>
            </div>
            
            <div class="row g-4">
                <%
                    try {
                        String sql = "SELECT * FROM products WHERE category=?";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setString(1, selectedCategory);
                        ResultSet rs = ps.executeQuery();

                        boolean hasProducts = false;
                        while (rs.next()) {
                            hasProducts = true;
                            int productId = rs.getInt("id");
                            String name = rs.getString("name");
                            String desc = rs.getString("description");
                            double price = rs.getDouble("price");
                            String image = rs.getString("image_url");
                %>
                    <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                        <div class="product-card fade-in">
                            <div class="position-relative overflow-hidden">
                                <img src="<%= image %>" class="product-img w-100" alt="<%= name %>" 
                                     onerror="this.src='https://via.placeholder.com/300x250?text=No+Image';">
                            </div>
                            <div class="product-body">
                                <h5 class="product-title"><%= name %></h5>
                                <p class="product-desc"><%= desc %></p>
                                <div class="product-price">₹ <%= String.format("%.2f", price) %></div>
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <label for="qty-<%= productId %>" class="text-muted">Qty</label>
                                    <input id="qty-<%= productId %>" type="number" name="quantity" min="1" value="1" class="form-control" style="width:90px;">
                                </div>
                                <div class="d-grid gap-2">
                                    <form method="post" action="addToCart.jsp" class="w-100 d-grid">
                                        <input type="hidden" name="product_id" value="<%= productId %>">
                                        <input type="hidden" name="quantity" value="1" data-qty-ref="qty-<%= productId %>">
                                        <button type="submit" class="add-to-cart-btn w-100">
                                            <i class="fas fa-cart-plus"></i> Add to Cart
                                        </button>
                                    </form>
                                    <form method="post" action="checkout.jsp" class="w-100 d-grid">
                                        <input type="hidden" name="buy_now_product_id" value="<%= productId %>">
                                        <input type="hidden" name="quantity" value="1" data-qty-ref="qty-<%= productId %>">
                                        <button type="submit" class="btn btn-outline-primary" style="border-radius:50px;">
                                            <i class="fas fa-bolt"></i> Buy Now
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
<script>
// Sync quantity inputs to hidden fields in forms
(function(){
  const qtyInput = document.getElementById('qty-<%= productId %>');
  if (qtyInput) {
    const forms = qtyInput.closest('.product-body').querySelectorAll('form input[data-qty-ref="qty-<%= productId %>"]');
    const sync = () => { forms.forEach(h => h.value = qtyInput.value); };
    qtyInput.addEventListener('input', sync);
    sync();
  }
})();
</script>
                <%
                        }
                        if (!hasProducts) {
                %>
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="fas fa-box-open"></i>
                            <h4>No Products Found</h4>
                            <p>Sorry, we couldn't find any products in the <%= selectedCategory %> category at the moment.</p>
                            <a href="user.jsp" class="back-btn mt-3">
                                <i class="fas fa-arrow-left"></i> Browse Other Categories
                            </a>
                        </div>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                %>
                    <div class="col-12">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Error!</strong> Unable to load products: <%= e.getMessage() %>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
        <%
            }
        %>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript for Enhanced UX -->
    <script>
        // Smooth scrolling for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
        
        // Add loading state to buttons
        document.querySelectorAll('button[type="submit"]').forEach(button => {
            button.addEventListener('click', function() {
                const originalText = this.innerHTML;
                this.innerHTML = '<span class="loading"></span> Adding...';
                this.disabled = true;
                
                // Re-enable button after form submission (fallback)
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 3000);
            });
        });
        
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.custom-navbar');
            if (window.scrollY > 50) {
                navbar.style.background = 'rgba(255, 255, 255, 0.98)';
                navbar.style.boxShadow = '0 8px 25px rgba(0, 0, 0, 0.15)';
            } else {
                navbar.style.background = 'rgba(255, 255, 255, 0.95)';
                navbar.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.1)';
            }
        });
        
        // Animate elements on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -100px 0px'
        };
        
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);
        
        // Observe all fade-in elements
        document.querySelectorAll('.fade-in').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(el);
        });
        
        // Image lazy loading fallback
        document.querySelectorAll('img').forEach(img => {
            img.addEventListener('error', function() {
                this.style.backgroundColor = '#f8f9fa';
                this.style.display = 'flex';
                this.style.alignItems = 'center';
                this.style.justifyContent = 'center';
                this.innerHTML = '<i class="fas fa-image" style="font-size: 2rem; color: #dee2e6;"></i>';
            });
        });
        
        // Add hover effects with JavaScript for better performance
        document.querySelectorAll('.category-card, .product-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = this.classList.contains('category-card') ? 
                    'translateY(-10px) scale(1.02)' : 'translateY(-8px)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
        
        // Success notification function
        function showNotification(message, type = 'success') {
            const notification = document.createElement('div');
            notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
            notification.style.top = '100px';
            notification.style.right = '20px';
            notification.style.zIndex = '9999';
            notification.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(notification);
            
            // Auto remove after 3 seconds
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 3000);
        }
        
        // Show notification if there's a success message
        <% if (request.getParameter("added") != null) { %>
            showNotification('<i class="fas fa-check-circle"></i> Item added to cart successfully!');
        <% } else if (request.getParameter("error") != null) { %>
            showNotification('<i class="fas fa-exclamation-triangle"></i> Error: Please try again.', 'warning');
        <% } %>
    </script>
</body>
</html>
