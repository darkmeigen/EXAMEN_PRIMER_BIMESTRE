<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Consulta de Productos</title>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<link rel="stylesheet" href="estilos.css">
<link rel="stylesheet" href="productos.css">
<style>
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
        padding: 20px;
    }
    .product-card {
        background: #4b1e8e;
        border-radius: 8px;
        padding: 15px;
        text-align: center;
        color: white;
        transition: transform 0.2s;
    }
    .product-card:hover {
        transform: scale(1.05);
    }
    .product-card img {
        max-width: 100%;
        height: auto;
        border-radius: 4px;
    }
    .logged-in {
        color: white;
        font-size: 1rem;
        margin-left: 20px;
        padding: 5px 10px;
        background-color: #4b1e8e;
        border-radius: 5px;
    }
    .nav-container {
        display: flex;
        justify-content: space-around;
        align-items: center;
        padding: 10px 0;
    }
    .nav-container a {
        color: #4b1e8e;
        text-decoration: none;
        font-size: 1.1rem;
        transition: color 0.3s;
    }
    .nav-container a:hover {
        color: #6b2eb8;
    }
    .logout-btn {
        display: inline-block;
        margin-left: 20px;
        margin-top: 5px;
        padding: 5px 10px;
        background-color: #ff4d4d;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-size: 0.9rem;
        transition: background-color 0.3s;
    }
    .logout-btn:hover {
        background-color: #e63939;
    }
</style>
</head>
<body>
    <header>
        <div class="logo">
            <a href="index.jsp" tabindex="0"><img src="fotos/e.png" alt="Logo"></a>
        </div>
        <nav class="nav-container" role="navigation">
            <a href="productos.jsp" tabindex="0">BUSCALOS POR CATEGORIA</a> 
            <a href="carrito.jsp" tabindex="0">Ir al Carrito</a>
            <% 
                HttpSession sesion = request.getSession();
                if (sesion.getAttribute("usuarioLogeado") != null && (Boolean)sesion.getAttribute("usuarioLogeado")) {
                    String nombreUsuario = (String) sesion.getAttribute("usuario");
            %>
                <div style="display: flex; flex-direction: column; align-items: center;">
                    <span class="logged-in">Logeado como <%= nombreUsuario %></span>
                    <a href="cerrarsesion.jsp" class="logout-btn" tabindex="0">Cerrar sesión</a>
                </div>
            <% } else { %>
                <a href="login.jsp" tabindex="0">INICIAR SESIÓN</a>
            <% } %>
        </nav>
    </header>

    <div class="container mx-auto px-4 py-8 max-w-7xl">
        <h2 class="text-3xl font-bold text-left mb-6">Todos los Productos</h2>

        <div class="product-grid">
            <%
                request.setCharacterEncoding("UTF-8");
                Conexion con = new Conexion();
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr, p.foto_pr " +
                                "FROM tb_producto p JOIN tb_categoria c ON p.id_cat = c.id_cat";
                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();
                    boolean hasResults = false;
                    while (rs.next()) {
                        hasResults = true;
                        int idPr = rs.getInt("id_pr");
                        String nombrePr = rs.getString("nombre_pr");
                        String categoria = rs.getString("descripcion_cat");
                        String fotoPr = rs.getString("foto_pr");
                        String imagenSrc = (fotoPr != null && !fotoPr.isEmpty()) ? "productos/" + fotoPr : "fotos/no-image.png";
                        double precioPr = rs.getDouble("precio_pr");
                        int cantidadPr = rs.getInt("cantidad_pr");
            %>
            <div class="product-card">
                <img src="<%= imagenSrc %>" alt="<%= nombrePr %>" style="width: 200px; height: 200px; object-fit: cover;">
                <h3 class="text-lg font-semibold mt-2"><%= nombrePr %></h3>
                <p class="text-sm">Categoría: <%= categoria %></p>
                <p class="text-sm">Precio: $<%= precioPr %></p>
                <div class="mt-2">
                    <% if (session.getAttribute("usuarioLogeado") != null && (Boolean)session.getAttribute("usuarioLogeado")) { %>
                        <form action="agregarCarrito.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="id_pr" value="<%= idPr %>">
                            <input type="hidden" name="nombre_pr" value="<%= java.net.URLEncoder.encode(nombrePr, "UTF-8") %>">
                            <input type="hidden" name="origen" value="productos1.jsp">
                            <button type="submit" class="btn bg-green-500 text-white font-semibold py-1 px-4 rounded-lg cursor-pointer hover:bg-green-600" tabindex="0">Comprar</button>
                        </form>
                    <% } else { %>
                        <p class="text-red-400 font-medium">Debes <a href="login.jsp" class="text-blue-400 underline" tabindex="0">iniciar sesión</a> para comprar.</p>
                    <% } %>
                </div>
            </div>
            <%
                    }
                    if (!hasResults) {
            %>
            <p class="text-center">No hay productos disponibles.</p>
            <%
                    }
                } catch (SQLException e) {
            %>
            <p class="text-center text-red-400">Error al cargar los productos: <%= e.getMessage() %></p>
            <%
                } finally {
                    Conexion.closeResources(rs, ps);
                    con.close();
                }
            %>
            
        </div>
    </div>
    
</body>
</html>