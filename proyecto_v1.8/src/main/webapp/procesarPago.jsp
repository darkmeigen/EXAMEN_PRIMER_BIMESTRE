<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Factura de Compra</title>
    <style>
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .factura { border: 1px solid #ccc; padding: 20px; border-radius: 5px; }
        .factura h2 { text-align: center; }
        .factura p { margin: 5px 0; }
        .factura table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        .factura th, .factura td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .factura th { background-color: #f2f2f2; }
        .btn { display: inline-block; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; }
        .btn:hover { background-color: #0056b3; }
        .error { color: red; text-align: center; }
    </style>
</head>
<body>
<%
    // Verificar si el usuario está logeado
    if (session.getAttribute("usuarioLogeado") == null || !(Boolean)session.getAttribute("usuarioLogeado")) {
        session.setAttribute("mensaje", "Debes estar logeado para realizar una compra. Por favor, inicia sesión.");
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtener el idUsuario de la sesión y validar con el parámetro enviado
    int idUsuarioSesion = (Integer) session.getAttribute("idUsuario");
    if (idUsuarioSesion == 0) {
        session.setAttribute("mensaje", "Error: No se encontró el ID de usuario en la sesión. Por favor, inicia sesión nuevamente.");
        response.sendRedirect("login.jsp");
        return;
    }

    // Declaración de variables
    String cedula = request.getParameter("cedula");
    String nombre = request.getParameter("nombre");
    String telefono = request.getParameter("telefono");
    String numeroTarjeta = request.getParameter("numeroTarjeta");
    String totalParam = request.getParameter("total");
    String idUsuarioParam = request.getParameter("id_usuario");
    double total = 0.0;
    int idUsuario = 0;
    String output = "";
    boolean hasError = false;

    // Validar parámetros y coincidencia del id_usuario
    try {
        total = Double.parseDouble(totalParam);
        idUsuario = Integer.parseInt(idUsuarioParam);
        if (idUsuario != idUsuarioSesion) {
            throw new Exception("El ID de usuario no coincide con la sesión. Posible intento de acceso no autorizado.");
        }
    } catch (Exception e) {
        hasError = true;
        output = "<p class='error'>Error: " + e.getMessage() + "</p>";
    }

    // Procesar el pago si no hay error
    if (!hasError) {
        Connection conn = null;
        PreparedStatement psCarrito = null;
        ResultSet rsCarrito = null;
        PreparedStatement psProducto = null;
        ResultSet rsProducto = null;
        PreparedStatement psUpdate = null;

        try {
            Conexion con = new Conexion();
            conn = con.getConexion();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }

            conn.setAutoCommit(false); // Iniciar transacción

            // Obtener los ítems del carrito del usuario autenticado
            String sqlCarrito = "SELECT id_carrito, nombre_pr, cantidad FROM tb_carrito WHERE id_usuario = ? AND id_estado = 1";
            psCarrito = conn.prepareStatement(sqlCarrito);
            psCarrito.setInt(1, idUsuario);
            rsCarrito = psCarrito.executeQuery();

            // Construir la factura en HTML
            StringBuilder facturaHtml = new StringBuilder();
            facturaHtml.append("<div class='container'>");
            facturaHtml.append("<div class='factura'>");
            facturaHtml.append("<h2>Factura de Compra</h2>");
            facturaHtml.append("<p><strong>Cliente:</strong> ").append(nombre).append("</p>");
            facturaHtml.append("<p><strong>Cédula:</strong> ").append(cedula).append("</p>");
            facturaHtml.append("<p><strong>Teléfono:</strong> ").append(telefono).append("</p>");
            facturaHtml.append("<p><strong>Fecha:</strong> ").append(new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date())).append("</p>");
            facturaHtml.append("<table>");
            facturaHtml.append("<tr><th>Producto</th><th>Precio Unitario</th><th>Cantidad</th><th>Total</th></tr>");

            double totalCalculado = 0.0;
            while (rsCarrito.next()) {
                String nombrePr = rsCarrito.getString("nombre_pr");
                int cantidad = rsCarrito.getInt("cantidad");

                String sqlProducto = "SELECT precio_pr FROM tb_producto WHERE nombre_pr = ?";
                psProducto = conn.prepareStatement(sqlProducto);
                psProducto.setString(1, nombrePr);
                rsProducto = psProducto.executeQuery();
                double precioPr = 0.0;
                if (rsProducto.next()) {
                    precioPr = rsProducto.getDouble("precio_pr");
                }
                if (rsProducto != null) rsProducto.close();
                if (psProducto != null) psProducto.close();

                double subtotal = precioPr * cantidad;
                totalCalculado += subtotal;
                facturaHtml.append("<tr>");
                facturaHtml.append("<td>").append(nombrePr).append("</td>");
                facturaHtml.append("<td>$").append(String.format("%.2f", precioPr)).append("</td>");
                facturaHtml.append("<td>").append(cantidad).append("</td>");
                facturaHtml.append("<td>$").append(String.format("%.2f", subtotal)).append("</td>");
                facturaHtml.append("</tr>");
            }
            facturaHtml.append("</table>");
            facturaHtml.append("<p><strong>Total Pagado:</strong> $").append(String.format("%.2f", totalCalculado)).append("</p>");
            if (Math.abs(total - totalCalculado) > 0.01) {
                throw new Exception("El total calculado no coincide con el total enviado.");
            }
            facturaHtml.append("<p><strong>Método de Pago:</strong> Tarjeta de Crédito (termina en ").append(numeroTarjeta.substring(numeroTarjeta.length() - 4)).append(")</p>");
            facturaHtml.append("<p style='text-align: center;'><strong>¡Gracias por su compra!</strong></p>");
            facturaHtml.append("<p style='text-align: center;'><a href='index.jsp' class='btn'>Volver al Inicio</a></p>");
            facturaHtml.append("</div>");
            facturaHtml.append("</div>");

            // Actualizar el estado del carrito del usuario autenticado
            String sqlUpdate = "UPDATE tb_carrito SET id_estado = 2 WHERE id_usuario = ? AND id_estado = 1";
            psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, idUsuario);
            int filas = psUpdate.executeUpdate();
            if (filas == 0) {
                throw new Exception("No se encontraron ítems para actualizar.");
            }

            conn.commit(); // Confirmar transacción
            output = facturaHtml.toString();

        } catch (SQLException | NumberFormatException e) {
            if (conn != null) conn.rollback(); // Revertir transacción en caso de error
            output = "<p class='error'>Error al procesar el pago: " + e.getMessage() + "</p>";
        } finally {
            try {
                if (rsProducto != null) rsProducto.close();
                if (psProducto != null) psProducto.close();
                if (rsCarrito != null) rsCarrito.close();
                if (psCarrito != null) psCarrito.close();
                if (psUpdate != null) psUpdate.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                output = "<p class='error'>Error al cerrar recursos: " + e.getMessage() + "</p>";
            }
        }
    }

    // Mostrar el resultado
    out.println(output);
%>
</body>
</html>