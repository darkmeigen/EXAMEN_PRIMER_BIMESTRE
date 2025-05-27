<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Carrito de Compras</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="estilos.css">
    <link rel="stylesheet" href="productos.css">
    <style>
        .product-card {
            background: #4b1e8e;
            border: 2px solid #fff;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            color: white;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }
        .product-card:hover {
            transform: scale(1.05);
            transition: transform 0.2s;
        }
        .product-card img {
            max-width: 100px;
            height: auto;
            border-radius: 4px;
            margin-right: 10px;
        }
        .cantidad-input {
            width: 50px;
            padding: 5px;
            text-align: center;
            color: #800080;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            padding: 5px 10px;
            margin: 0 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #4b1e8e;
            padding: 20px;
            border-radius: 8px;
            color: white;
            width: 90%;
            max-width: 500px;
        }
        .modal-content h2 {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .mis-compras-table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        .mis-compras-table th, .mis-compras-table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ccc;
        }
        .mis-compras-table th {
            background-color: #333;
            color: white;
        }
        .total-section {
            margin-top: 10px;
            text-align: right;
            font-size: 1.5rem;
            font-weight: bold;
        }
        .pay-button {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        .pay-button:hover {
            background: #218838;
        }
    </style>
    <script>
        function mostrarFormularioPago() {
            const modal = document.getElementById('modalPago');
            modal.style.display = 'flex';
        }

        function cerrarModal() {
            const modal = document.getElementById('modalPago');
            modal.style.display = 'none';
            document.getElementById('formPago').reset();
            document.getElementById('errorCedula').style.display = 'none';
            document.getElementById('errorNombre').style.display = 'none';
            document.getElementById('errorTelefono').style.display = 'none';
            document.getElementById('errorTarjeta').style.display = 'none';
            document.getElementById('cardType').textContent = '';
        }

        function detectarTipoTarjeta() {
            const numeroTarjeta = document.getElementById('numeroTarjeta').value.replace(/\D/g, '');
            const cardTypeElement = document.getElementById('cardType');
            let cardType = 'Desconocida';
            if (numeroTarjeta.length > 0) {
                if (/^4/.test(numeroTarjeta)) cardType = 'Visa';
                else if (/^3[47]/.test(numeroTarjeta)) cardType = 'American Express';
                else if (/^5[1-5]/.test(numeroTarjeta)) cardType = 'MasterCard';
                else if (/^6011/.test(numeroTarjeta)) cardType = 'Discover';
                else if (/^3(0[0-5]|[68])/.test(numeroTarjeta)) cardType = 'Diners Club';
            }
            cardTypeElement.textContent = `Tipo de tarjeta: ${cardType}`;
            return cardType !== 'Desconocida';
        }

        function validarFormulario(event) {
            event.preventDefault();
            let valido = true;
            const cedula = document.getElementById('cedula').value.replace(/\D/g, '');
            const errorCedula = document.getElementById('errorCedula');
            if (cedula.length !== 10) {
                errorCedula.textContent = 'La cédula debe tener 10 dígitos numéricos.';
                errorCedula.style.display = 'block';
                valido = false;
            } else errorCedula.style.display = 'none';

            const nombre = document.getElementById('nombre').value.trim();
            const errorNombre = document.getElementById('errorNombre');
            if (nombre === '') {
                errorNombre.textContent = 'El nombre es obligatorio.';
                errorNombre.style.display = 'block';
                valido = false;
            } else errorNombre.style.display = 'none';

            const telefono = document.getElementById('telefono').value.replace(/\D/g, '');
            const errorTelefono = document.getElementById('errorTelefono');
            if (telefono.length !== 10) {
                errorTelefono.textContent = 'El teléfono debe tener 10 dígitos numéricos.';
                errorTelefono.style.display = 'block';
                valido = false;
            } else errorTelefono.style.display = 'none';

            const numeroTarjeta = document.getElementById('numeroTarjeta').value.replace(/\D/g, '');
            const errorTarjeta = document.getElementById('errorTarjeta');
            const esTarjetaValida = detectarTipoTarjeta();
            if (numeroTarjeta.length !== 16 || !esTarjetaValida) {
                errorTarjeta.textContent = 'El número de tarjeta debe tener 16 dígitos y ser válida.';
                errorTarjeta.style.display = 'block';
                valido = false;
            } else errorTarjeta.style.display = 'none';

            if (valido) document.getElementById('formPago').submit();
        }
    </script>
</head>
<body>
<%
    // Verificar si el usuario está logeado
    if (session.getAttribute("usuarioLogeado") == null || !(Boolean)session.getAttribute("usuarioLogeado")) {
        session.setAttribute("mensaje", "Debes estar logeado para acceder a esta página. Por favor, inicia sesión.");
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtener el idUsuario de la sesión
    int idUsuario = (Integer) session.getAttribute("idUsuario");
    if (idUsuario == 0) {
        session.setAttribute("mensaje", "Error: No se encontró el ID de usuario en la sesión. Por favor, inicia sesión nuevamente.");
        response.sendRedirect("login.jsp");
        return;
    }
%>
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

<div style="max-width: 800px; margin: 0 auto; padding: 20px;">
    <h2 style="font-size: 2rem; font-weight: bold; text-align: left; margin-bottom: 20px; color: #fff;">Carrito de Compras</h2>

    <div style="background: #4b1e8e; padding: 10px; border-radius: 8px;">
        <div id="listaProductos">
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                PreparedStatement psProducto = null;
                ResultSet rsProducto = null;
                double total = 0.0;
                try {
                    Conexion con = new Conexion();
                    conn = con.getConexion();
                    if (conn == null) {
                        throw new SQLException("No se pudo conectar a la base de datos.");
                    }
                    String sqlCarrito = "SELECT c.id_carrito, c.id_usuario, c.nombre_pr, c.cantidad, c.id_estado " +
                                      "FROM tb_carrito c WHERE c.id_usuario = ? AND c.id_estado = 1";
                    ps = conn.prepareStatement(sqlCarrito);
                    ps.setInt(1, idUsuario);
                    rs = ps.executeQuery();

                    boolean hasResults = false;
                    while (rs.next()) {
                        hasResults = true;
                        int idCarrito = rs.getInt("id_carrito");
                        String nombrePr = rs.getString("nombre_pr");
                        int cantidad = rs.getInt("cantidad");
                        int idEstado = rs.getInt("id_estado");

                        String sqlProducto = "SELECT id_pr, precio_pr, foto_pr FROM tb_producto WHERE nombre_pr = ?";
                        psProducto = conn.prepareStatement(sqlProducto);
                        psProducto.setString(1, nombrePr);
                        rsProducto = psProducto.executeQuery();
                        double precioPr = 0.0;
                        String fotoPr = "fotos/no-image.png";
                        if (rsProducto.next()) {
                            precioPr = rsProducto.getDouble("precio_pr");
                            fotoPr = (rsProducto.getString("foto_pr") != null && !rsProducto.getString("foto_pr").isEmpty()) ? "productos/" + rsProducto.getString("foto_pr") : "fotos/no-image.png";
                        } else {
                            out.println("<p style='color: red; text-align: center;'>Producto no encontrado en tb_producto: " + nombrePr + "</p>");
                        }
                        if (rsProducto != null) rsProducto.close();
                        if (psProducto != null) psProducto.close();

                        double subtotal = precioPr * cantidad;
                        total += subtotal;
            %>
            <div id="producto_<%= idCarrito %>" class="product-card">
                <img src="<%= fotoPr %>" alt="<%= nombrePr %>">
                <div style="flex: 1; text-align: center;">
                    <h3 style="font-size: 1.2rem; font-weight: bold; margin-bottom: 10px;"><%= nombrePr %></h3>
                    <div style="display: flex; justify-content: center; align-items: center; margin-bottom: 10px;">
                        <label style="margin-right: 10px;">Cantidad:</label>
                        <input type="number" id="cantidad_<%= idCarrito %>" name="cantidad_<%= idCarrito %>" value="<%= cantidad %>" min="1" class="cantidad-input" readonly>
                        <form action="actualizarCarrito.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="id_carrito" value="<%= idCarrito %>">
                            <input type="hidden" name="accion" value="aumentar">
                            <button type="submit" class="btn" style="background: #3498db; color: white;" tabindex="0">+</button>
                        </form>
                        <form action="actualizarCarrito.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="id_carrito" value="<%= idCarrito %>">
                            <input type="hidden" name="accion" value="disminuir">
                            <button type="submit" class="btn" style="background: #3498db; color: white;" tabindex="0">-</button>
                        </form>
                        <form action="eliminarCarrito.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="id_carrito" value="<%= idCarrito %>">
                            <button type="submit" class="btn" style="background: #e74c3c; color: white;" tabindex="0">Eliminar</button>
                        </form>
                    </div>
                    <p style="margin-top: 10px;">Subtotal: $<%= String.format("%.2f", subtotal) %></p>
                </div>
            </div>
            <%
                    }
                    if (!hasResults) {
            %>
            <p style="text-align: center; color: #fff;">No hay productos en el carrito.</p>
            <%
                    }
                } catch (SQLException e) {
            %>
            <p style="color: red; text-align: center;">Error al cargar el carrito: <%= e.getMessage() %></p>
            <%
                } finally {
                    try {
                        if (rsProducto != null) rsProducto.close();
                        if (psProducto != null) psProducto.close();
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<p style='color: red; text-align: center;'>Error al cerrar recursos: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>
        <div class="total-section">
            <h3>Total: $<%= String.format("%.2f", total) %></h3>
        </div>
        <% if (total > 0) { %>
        <button onclick="mostrarFormularioPago()" class="pay-button" tabindex="0">Pagar</button>
        <% } %>
    </div>

    <!-- Sección Mis Compras -->
    <%
        Connection connCompras = null;
        PreparedStatement psCompras = null;
        ResultSet rsCompras = null;
        try {
            Conexion con = new Conexion();
            connCompras = con.getConexion();
            if (connCompras == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            String sqlCompras = "SELECT c.id_carrito, c.nombre_pr, c.cantidad, c.fecha_agregado " +
                              "FROM tb_carrito c WHERE c.id_usuario = ? AND c.id_estado = 2";
            psCompras = connCompras.prepareStatement(sqlCompras);
            psCompras.setInt(1, idUsuario);
            rsCompras = psCompras.executeQuery();
            if (rsCompras.isBeforeFirst()) {
    %>
    <h2 style="text-align: center; margin-top: 40px; color: #fff; font-size: 1.5rem; font-weight: bold;">Mis Compras</h2>
    <table class="mis-compras-table">
        <tr>
            <th>ID</th>
            <th>Producto</th>
            <th>Cantidad</th>
            <th>Fecha</th>
        </tr>
        <%
            while (rsCompras.next()) {
                int idCarrito = rsCompras.getInt("id_carrito");
                String nombrePr = rsCompras.getString("nombre_pr");
                int cantidad = rsCompras.getInt("cantidad");
                String fecha = rsCompras.getString("fecha_agregado");
        %>
        <tr>
            <td><%= idCarrito %></td>
            <td><%= nombrePr %></td>
            <td><%= cantidad %></td>
            <td><%= fecha != null ? fecha : "Sin fecha" %></td>
        </tr>
        <%
            }
            %>
    </table>
    <%
            } else {
                out.println("<p style='text-align: center; color: #fff;'>No hay compras realizadas.</p>");
            }
        } catch (SQLException e) {
            out.println("<p style='color: red; text-align: center;'>Error al cargar mis compras: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rsCompras != null) rsCompras.close();
                if (psCompras != null) psCompras.close();
                if (connCompras != null) connCompras.close();
            } catch (SQLException e) {
                out.println("<p style='color: red; text-align: center;'>Error al cerrar recursos: " + e.getMessage() + "</p>");
            }
        }
    %>
</div>

<div id="modalPago" class="modal">
    <div class="modal-content">
        <h2>Información de Pago</h2>
        <form id="formPago" action="procesarPago.jsp" method="post" onsubmit="validarFormulario(event)">
            <label for="cedula">Cédula:</label>
            <input type="text" id="cedula" name="cedula" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required tabindex="0">
            <div id="errorCedula" class="error"></div>

            <label for="nombre">Nombre:</label>
            <input type="text" id="nombre" name="nombre" required tabindex="0">
            <div id="errorNombre" class="error"></div>

            <label for="telefono">Teléfono:</label>
            <input type="text" id="telefono" name="telefono" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required tabindex="0">
            <div id="errorTelefono" class="error"></div>

            <label for="numeroTarjeta">Número de Tarjeta de Crédito:</label>
            <input type="text" id="numeroTarjeta" name="numeroTarjeta" maxlength="16" oninput="this.value = this.value.replace(/[^0-9]/g, ''); detectarTipoTarjeta();" required tabindex="0">
            <div id="cardType" class="card-type"></div>
            <div id="errorTarjeta" class="error"></div>

            <input type="hidden" name="total" value="<%= total %>">
            <input type="hidden" name="id_usuario" value="<%= idUsuario %>">
            <div style="text-align: right; margin-top: 20px;">
                <button type="button" onclick="cerrarModal()" class="btn" style="background: #e74c3c; color: white;" tabindex="0">Cancelar</button>
                <button type="submit" class="btn" style="background: #28a745; color: white;" tabindex="0">Pagar</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>