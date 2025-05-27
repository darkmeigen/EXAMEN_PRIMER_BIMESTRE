<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.productos.negocio.*, java.io.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Consulta por Categoría</title>
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
    <script>
        function limpiarTabla() {
            const tabla = document.getElementById("tablaProductos");
            if (tabla) tabla.innerHTML = '';
        }
    </script>
</head>
<body>
<header>
    <div class="logo">
        <a href="index.jsp" tabindex="0">
            <img src="fotos/e.png" alt="Logo">
        </a>
    </div>
    <nav class="nav-container" role="navigation">
        <a href="productos1.jsp" tabindex="0">NUESTROS PRODUCTOS</a>
        <a href="carrito.jsp" tabindex="0">CARRITO</a>
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
    <h2 class="text-3xl font-bold text-left mb-6">Consulta de Productos por Categoría</h2>

    <%
        request.setCharacterEncoding("UTF-8");
        Categoria cat = new Categoria();
        Producto prod = new Producto();
        String categoriaSeleccionada = request.getParameter("cmbCategoria");
    %>

    <div class="card text-left">
        <form id="consultaForm" method="get" action="productos.jsp" class="space-y-4">
            <div class="w-full max-w-md">
                <label for="cmbCategoria" class="block text-lg font-medium mb-2">Seleccione una categoría:</label>
                <div class="relative">
                    <%= cat.mostrarCategoria() %>
                    <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                        <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                            <path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/>
                        </svg>
                    </div>
                </div>
            </div>
            <input type="submit" value="Consultar" class="btn bg-blue-500 text-white font-semibold py-2 px-6 rounded-lg cursor-pointer hover:bg-blue-600" tabindex="0">
            <button type="button" onclick="limpiarTabla()" class="btn bg-red-500 text-white font-semibold py-2 px-6 rounded-lg cursor-pointer hover:bg-red-600" tabindex="0">
                Limpiar Resultados
            </button>
        </form>
    </div>

    <hr class="my-6 border-gray-300">

    <div id="tablaProductos" class="product-grid">
    <% 
        if (categoriaSeleccionada != null) {
            try {
                int idCategoria = Integer.parseInt(categoriaSeleccionada);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PrintStream ps = new PrintStream(baos);
                PrintStream originalOut = System.out;
                System.setOut(ps);
                prod.buscarProductoCategoria(idCategoria);
                System.out.flush();
                System.setOut(originalOut);
                String capturedOutput = baos.toString("UTF-8");
    %>
        <h3 class="text-2xl font-semibold mb-4">Productos en la categoría seleccionada:</h3>
        <%
            if (capturedOutput != null && !capturedOutput.trim().isEmpty()) {
                String[] filas = capturedOutput.split("</tr>");
                for (String fila : filas) {
                    if (!fila.contains("<tr>")) continue;
                    String[] datos = fila.split("</td>");
                    if (datos.length >= 5) { // ID, Imagen, Nombre, Cantidad, Precio
                        String id = datos[0].replaceAll(".*<td>", "").trim();
                        String imagenTag = datos[1].replaceAll(".*<td>", "").trim();
                        String nombre = datos[2].replaceAll(".*<td>", "").trim();
                        String cantidad = datos[3].replaceAll(".*<td>", "").trim();
                        String precio = datos[4].replaceAll(".*<td>", "").trim();
                        String fotoPr = "fotos/no-image.png";
                        if (imagenTag.contains("src='")) {
                            int startIdx = imagenTag.indexOf("src='") + 5;
                            int endIdx = imagenTag.indexOf("'", startIdx);
                            if (endIdx > startIdx) {
                                fotoPr = imagenTag.substring(startIdx, endIdx);
                            }
                        }
                        if (!id.isEmpty() && !nombre.isEmpty() && !cantidad.isEmpty() && !precio.isEmpty()) {
                            int idPr = Integer.parseInt(id);
        %>
        <div class="product-card">
            <img src="<%= fotoPr %>" alt="<%= nombre %>" style="width: 200px; height: 200px; object-fit: cover;">
            <h3 class="text-lg font-semibold mt-2"><%= nombre %></h3>
            <p class="text-sm">Cantidad: <%= cantidad %></p>
            <p class="text-sm">Precio: $<%= precio %></p>
            <div class="mt-2">
                <% if (session.getAttribute("usuarioLogeado") != null && (Boolean)session.getAttribute("usuarioLogeado")) { %>
                    <form action="agregarCarrito.jsp" method="post" class="inline">
                        <input type="hidden" name="id_pr" value="<%= idPr %>">
                        <input type="hidden" name="nombre_pr" value="<%= java.net.URLEncoder.encode(nombre, "UTF-8") %>">
                        <input type="hidden" name="origen" value="productos.jsp">
                        <button type="submit" class="btn bg-green-500 text-white font-semibold py-1 px-4 rounded-lg cursor-pointer hover:bg-green-600" tabindex="0">Comprar</button>
                    </form>
                <% } else { %>
                    <p class="text-red-400 font-medium">Debes <a href="login.jsp" class="text-blue-400 underline" tabindex="0">iniciar sesión</a> para comprar.</p>
                <% } %>
            </div>
        </div>
        <%
                        }
                    }
                }
            } else {
        %>
        <p class="text-center">No hay productos disponibles.</p>
        <%
            }
        } catch (NumberFormatException e) {
        %>
        <p class="text-red-400 font-medium">ID de categoría no válido.</p>
        <% 
        } catch (Exception e) {
        %>
        <p class="text-red-400 font-medium">Error al cargar los productos: <%= e.getMessage() %></p>
        <% 
        }
    }
    %>
    
    </div>
</div>

<!-- Al final del <body>, después de la tabla de productos -->
<button id="hablar" style="position: fixed; bottom: 20px; right: 20px; padding: 10px 20px; background-color: rgb(113, 129, 255); color: white; border: none; border-radius: 5px; cursor: pointer;" tabindex="0">Narrar</button>
<div id="salida" style="display:none;">
    <%
        if (categoriaSeleccionada != null) {
            try {
                int idCategoria = Integer.parseInt(categoriaSeleccionada);
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PrintStream ps = new PrintStream(baos);
                PrintStream originalOut = System.out;
                System.setOut(ps);
                prod.buscarProductoCategoria(idCategoria);
                System.out.flush();
                System.setOut(originalOut);
                String capturedOutput = baos.toString("UTF-8");
                out.print(capturedOutput);
            } catch (Exception e) {
                out.print("<p>Error al cargar productos para narración.</p>");
            }
        }
    %>
</div>
<script>
    let oyendo = false;
    let carta = document.querySelector('.product-grid'); // Ajusta según el contenedor de productos
    let hablar = document.getElementById("hablar");

    hablar.addEventListener("click", () => {
        if (!oyendo) {
            oyendo = true;
            hablar.style.backgroundColor = "rgb(113, 255, 163)";
            carta.classList.add('brillo');
            setTimeout(() => {
                carta.classList.remove('brillo');
            }, 1000);

            let texto = document.getElementById("salida").innerText;
            decir(texto);
        } else {
            speechSynthesis.cancel();
            hablar.style.backgroundColor = "rgb(113, 129, 255)";
            oyendo = false;
        }
    });

    function decir(texto) {
        var mensaje = new SpeechSynthesisUtterance(texto);
        const voces = window.speechSynthesis.getVoices();
        mensaje.onend = function () {
            oyendo = false;
            hablar.style.backgroundColor = "rgb(255, 253, 113)";
        };
        mensaje.volume = 1;
        speechSynthesis.speak(mensaje);
    }
</script>
<style>
    .brillo {
        animation: brillo 1s ease-in-out;
    }
    @keyframes brillo {
        0% { filter: brightness(100%); }
        50% { filter: brightness(150%); }
        100% { filter: brightness(100%); }
    }
</style>
</body>
</html>