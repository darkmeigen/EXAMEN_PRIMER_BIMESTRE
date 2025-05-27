<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bitácora de Auditoría</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="EstilosExtra.css">
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
    <h1 class="titulo-logo">E-COMMERCE PARADISE STORE</h1>

    <header>
        <div class="logo">
            <a href="index.jsp">
                <img src="fotos/e.png" alt="Logo">
            </a>
        </div>
        <nav class="nav-container">
            <a href="productos1.jsp">CONOCE NUESTROS PRODUCTOS</a>
            <a href="productos.jsp">BUSCALOS POR CATEGORIA</a>
            <a href="carrito.jsp">CARRITO</a>
           
        </nav>
    </header>

    <div class="form-container">
        <h2>Bitácora de Auditoría</h2>

        <form method="GET" action="bitacora.jsp">
            <div class="form-group">
                <label for="tabla">Tabla:</label>
                <select id="tabla" name="tabla" class="form-control">
                    <option value="">Todas</option>
                    <%
                        Conexion conTablas = new Conexion();
                        PreparedStatement psTablas = null;
                        ResultSet rsTablas = null;
                        try {
                            String sqlTablas = "SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename";
                            psTablas = conTablas.prepareStatement(sqlTablas);
                            rsTablas = psTablas.executeQuery();
                            String selectedTabla = request.getParameter("tabla") != null ? request.getParameter("tabla") : "";
                            while (rsTablas.next()) {
                                String tablaName = rsTablas.getString("tablename");
                                boolean isSelected = tablaName.equals(selectedTabla);
                    %>
                                <option value="<%= tablaName %>" <%= isSelected ? "selected" : "" %>><%= tablaName %></option>
                    <%
                            }
                        } catch (SQLException e) {
                            out.println("Error al cargar tablas: " + e.getMessage());
                        } finally {
                            Conexion.closeResources(rsTablas, psTablas);
                            conTablas.close();
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="operacion">Operación:</label>
                <select id="operacion" name="operacion" class="form-control">
                    <option value="">Todas</option>
                    <option value="I" <%= "I".equals(request.getParameter("operacion")) ? "selected" : "" %>>Inserción</option>
                    <option value="U" <%= "U".equals(request.getParameter("operacion")) ? "selected" : "" %>>Actualización</option>
                    <option value="D" <%= "D".equals(request.getParameter("operacion")) ? "selected" : "" %>>Eliminación</option>
                </select>
            </div>
            <div class="form-group button-group">
                <button type="submit" class="btn btn-primary">Filtrar</button>
                <a href="bitacora.jsp" class="btn btn-secondary">Limpiar</a>
            </div>
        </form>

        <table class="table">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Tabla</th>
                    <th scope="col">Operación</th>
                    <th scope="col">Valor Anterior</th>
                    <th scope="col">Valor Nuevo</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Usuario</th>
                    <th scope="col">Acción</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Conexion con = new Conexion();
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        String tabla = request.getParameter("tabla");
                        String operacion = request.getParameter("operacion");
                        String sql = "SELECT id_aud, tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud " +
                                    "FROM auditoria.tb_auditoria WHERE operacion_aud IS NOT NULL";
                        if (tabla != null && !tabla.isEmpty()) {
                            sql += " AND tabla_aud = ?";
                        }
                        if (operacion != null && !operacion.isEmpty()) {
                            sql += " AND operacion_aud = ?";
                        }
                        sql += " ORDER BY fecha_aud DESC";
                        ps = con.prepareStatement(sql);
                        int paramIndex = 1;
                        if (tabla != null && !tabla.isEmpty()) {
                            ps.setString(paramIndex++, tabla);
                        }
                        if (operacion != null && !operacion.isEmpty()) {
                            ps.setString(paramIndex++, operacion);
                        }
                        rs = ps.executeQuery();
                        boolean hasResults = false;
                        while (rs.next()) {
                            hasResults = true;
                            String operacionAud = rs.getString("operacion_aud");
                            String operacionTexto = operacionAud.equals("I") ? "Inserción" :
                                                   operacionAud.equals("U") ? "Actualización" :
                                                   operacionAud.equals("D") ? "Eliminación" : operacionAud;
                %>
                            <tr>
                                <td><%= rs.getInt("id_aud") %></td>
                                <td><%= rs.getString("tabla_aud") %></td>
                                <td><%= operacionTexto %></td>
                                <td class="json-data" data-json='<%= rs.getString("valoranterior_aud") != null ? rs.getString("valoranterior_aud").replace("'", "\\'").replace("\n", "") : "" %>'></td>
                                <td class="json-data" data-json='<%= rs.getString("valornuevo_aud") != null ? rs.getString("valornuevo_aud").replace("'", "\\'").replace("\n", "") : "" %>'></td>
                                <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss a z").format(rs.getTimestamp("fecha_aud")) %></td>
                                <td><%= rs.getString("usuario_aud") != null ? rs.getString("usuario_aud") : "Desconocido" %></td>
                                <td>
                                    <a href="EliminarRegistroBitacora.jsp?id_aud=<%= rs.getInt("id_aud") %>" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que deseas eliminar este registro?')">Eliminar</a>
                                </td>
                            </tr>
                <%
                        }
                        if (!hasResults) {
                %>
                            <tr>
                                <td colspan="8" class="text-center">No hay registros de auditoría</td>
                            </tr>
                <%
                        }
                    } catch (SQLException e) {
                %>
                        <tr>
                            <td colspan="8" class="text-center error">Error al cargar bitácora: <%= e.getMessage() %></td>
                        </tr>
                <%
                    } finally {
                        Conexion.closeResources(rs, ps);
                        con.close();
                    }
                %>
            </tbody>
        </table>
    </div>

    <script>
        function formatJson(jsonStr) {
            if (!jsonStr || jsonStr.trim() === '') return '-';
            try {
                const obj = JSON.parse(jsonStr);
                // Mostrar solo el nombre_pr si existe, de lo contrario mostrar '-'
                const nombrePr = obj.nombre_pr;
                const displayValue = (nombrePr !== null && nombrePr !== undefined) ? nombrePr : '-';
                return displayValue;
            } catch (e) {
                console.error('Error parsing JSON:', e, 'JSON:', jsonStr);
                return '-';
            }
        }

        document.querySelectorAll('.json-data').forEach(cell => {
            cell.innerHTML = formatJson(cell.getAttribute('data-json'));
        });
    </script>
</body>
</html>