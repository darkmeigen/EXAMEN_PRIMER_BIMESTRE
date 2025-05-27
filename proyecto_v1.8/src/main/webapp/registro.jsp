<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro - Paradise Store</title>
    <link rel="stylesheet" href="estilos.css">
    <script>
        function validarFormulario(event) {
            event.preventDefault();
            let valido = true;

            // Validar correo
            const correo = document.getElementById('txtCorreo').value;
            const errorCorreo = document.getElementById('errorCorreo');
            const correoRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!correoRegex.test(correo)) {
                errorCorreo.textContent = 'Por favor, ingrese un correo válido.';
                errorCorreo.style.display = 'block';
                valido = false;
            } else {
                errorCorreo.style.display = 'none';
            }

            // Validar contraseña
            const clave = document.getElementById('txtClave').value;
            const errorClave = document.getElementById('errorClave');
            if (clave.length < 8) {
                errorClave.textContent = 'La contraseña debe tener al menos 8 caracteres.';
                errorClave.style.display = 'block';
                valido = false;
            } else {
                errorClave.style.display = 'none';
            }

            // Validar cédula
            const cedula = document.getElementById('txtCedula').value;
            const errorCedula = document.getElementById('errorCedula');
            if (cedula.length !== 10 || !/^\d{10}$/.test(cedula)) {
                errorCedula.textContent = 'La cédula debe tener 10 dígitos numéricos.';
                errorCedula.style.display = 'block';
                valido = false;
            } else {
                errorCedula.style.display = 'none';
            }

            if (valido) {
                document.getElementById('formRegistro').submit();
            }
        }
    </script>
    <style>
        .error {
            color: red;
            font-size: 0.9rem;
            margin-bottom: 10px;
            display: none;
        }
    </style>
</head>
<body>
<h1 class="titulo-logo">REGISTRO DE USUARIO</h1>

<div class="logo">
    <a href="index.jsp">
        <img src="fotos/e.png" alt="Logo">
    </a>
</div>

<form id="formRegistro" action="respuesta.jsp" method="post" class="card" style="max-width: 600px; margin: auto;" onsubmit="validarFormulario(event)">
    <input type="hidden" name="accion" value="registro">

    <label>Nombre:</label>
    <input type="text" id="txtNombre" name="txtNombre" required><br><br>

    <label>Cédula:</label>
    <input type="text" id="txtCedula" name="txtCedula" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required><br>
    <div id="errorCedula" class="error"></div><br>

    <label>Correo Electrónico:</label>
    <input type="email" id="txtCorreo" name="txtCorreo" required><br>
    <div id="errorCorreo" class="error"></div><br>

    <label>Contraseña:</label>
    <input type="password" id="txtClave" name="txtClave" required><br>
    <div id="errorClave" class="error"></div><br>

    <label>Estado civil:</label>
    <select name="cmbEstadoCivil" required>
        <option value="Soltero">Soltero</option>
        <option value="Casado">Casado</option>
        <option value="Divorciado">Divorciado</option>
        <option value="Viudo">Viudo</option>
    </select><br><br>

    <label>Residencia:</label><br>
    <input type="radio" name="rdResidencia" value="Sur" required> Sur
    <input type="radio" name="rdResidencia" value="Norte"> Norte
    <input type="radio" name="rdResidencia" value="Centro"> Centro<br><br>

    <label>Foto de perfil:</label>
    <input type="file" name="fileFoto" accept=".jpg,.jpeg,.png"><br><br>
    
    <label>Hoja de vida:</label>
    <input type="file" name="filePDF" accept=".pdf"><br><br>

    <label>Mes y año de nacimiento:</label>
    <input type="month" name="fecha" required><br><br>

    <label>Color favorito:</label>
    <input type="color" name="color"><br><br>

    <input type="submit" value="Enviar">
    <input type="reset" value="Restablecer">
</form>
</body>
</html>