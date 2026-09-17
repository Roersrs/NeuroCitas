<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de cliente</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body class="login-body">
    <div class="login-container">
        <div class="hero">
            <h1>Crear cuenta</h1>
            <p>Regístrate como cliente para consultar disponibilidad médica y agendar citas.</p>
        </div>

        <div class="login-card">
            <h2>Registro de cliente</h2>

            <% if(request.getParameter("error")!=null){ %>
                <div class="msg error">
                    No se pudo registrar. Revisa que identificación y teléfono tengan máximo 10 números, y que la contraseña cumpla los requisitos.
                </div>
            <% } %>

            <form action="ControladorRegistro" method="post" id="formRegistro">
                <div class="form-grid">
                    <div class="campo">
                        <input type="text" name="cidentificacion" id="identificacion" placeholder="Identificación" required
                               maxlength="10" inputmode="numeric" pattern="[0-9]{1,10}"
                               oninput="soloNumeros(this)">
                        <div class="ayuda">Digite solo números. Máximo 10 números.</div>
                    </div>

                    <div class="campo">
                        <input type="text" name="cnombre" placeholder="Nombre" required>
                        <div class="ayuda">Digite el nombre del cliente.</div>
                    </div>

                    <div class="campo">
                        <input type="text" name="capellido" placeholder="Apellido" required>
                        <div class="ayuda">Digite el apellido del cliente.</div>
                    </div>

                    <div class="campo">
                        <input type="email" name="cmail" placeholder="Correo" required>
                        <div class="ayuda">Digite un correo válido. Ejemplo: usuario@correo.com</div>
                    </div>

                    <div class="campo">
                        <input type="text" name="ctelefono" id="telefono" placeholder="Teléfono" required
                               maxlength="10" inputmode="numeric" pattern="[0-9]{1,10}"
                               oninput="soloNumeros(this)">
                        <div class="ayuda">Digite solo números. No más de 10 números.</div>
                    </div>

                    <div class="campo">
                        <input type="text" name="cusuario" placeholder="Usuario" required>
                        <div class="ayuda">Crea un nombre de usuario para iniciar sesión.</div>
                    </div>

                    <div class="campo full">
                        <input type="password" name="cclave" id="clave" placeholder="Contraseña" required
                               minlength="8"
                               pattern="(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}"
                               oninput="validarClave()">
                        <div class="ayuda ayuda-clave">
                            La contraseña debe tener mínimo 8 caracteres, una letra mayúscula, números y símbolos.
                        </div>
                        <div class="password-box" id="passwordBox">
                            <strong>Seguridad:</strong> <span id="nivelClave">Débil</span>
                            <ul>
                                <li id="reqLongitud">Mínimo 8 caracteres</li>
                                <li id="reqMayuscula">Al menos una letra mayúscula</li>
                                <li id="reqNumero">Al menos un número</li>
                                <li id="reqSimbolo">Al menos un símbolo</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <button type="submit">Registrarme</button>
            </form>

            <div class="links"><a href="index.jsp">Ya tengo cuenta</a></div>
        </div>
    </div>

    <script>
        function soloNumeros(input) {
            input.value = input.value.replace(/[^0-9]/g, '').slice(0, 10);
        }

        function validarClave() {
            const clave = document.getElementById('clave').value;
            const nivel = document.getElementById('nivelClave');

            const longitud = clave.length >= 8;
            const mayuscula = /[A-Z]/.test(clave);
            const numero = /[0-9]/.test(clave);
            const simbolo = /[^A-Za-z0-9]/.test(clave);

            marcar('reqLongitud', longitud);
            marcar('reqMayuscula', mayuscula);
            marcar('reqNumero', numero);
            marcar('reqSimbolo', simbolo);

            const puntos = [longitud, mayuscula, numero, simbolo].filter(Boolean).length;

            if (puntos <= 1) {
                nivel.textContent = 'Débil';
                nivel.className = 'debil';
            } else if (puntos <= 3) {
                nivel.textContent = 'Media';
                nivel.className = 'media';
            } else {
                nivel.textContent = 'Fuerte';
                nivel.className = 'fuerte';
            }
        }

        function marcar(id, ok) {
            const item = document.getElementById(id);
            item.className = ok ? 'cumple' : '';
        }
    </script>
</body>
</html>
