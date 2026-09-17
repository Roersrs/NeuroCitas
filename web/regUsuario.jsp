<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/estilos.css">
    <title>Nuevo usuario</title>
</head>
<body>
<div class="page">
    <div class="card">
        <h2>Agregar usuario</h2>
        <p>El administrador puede crear doctores, clientes o nuevos administradores.</p>

        <form action="ControladorUsuario" method="post">
            <div class="form-grid">
                <div class="campo">
                    <input type="text" name="cidentificacion" placeholder="Identificación" required maxlength="10" inputmode="numeric" pattern="[0-9]{1,10}" oninput="soloNumeros(this)">
                    <div class="ayuda">Digite solo números. Máximo 10 números.</div>
                </div>

                <div class="campo">
                    <input name="cnombre" placeholder="Nombre" required>
                    <div class="ayuda">Digite el nombre del usuario.</div>
                </div>

                <div class="campo">
                    <input name="capellido" placeholder="Apellido" required>
                    <div class="ayuda">Digite el apellido del usuario.</div>
                </div>

                <div class="campo">
                    <input type="email" name="cmail" placeholder="Correo">
                    <div class="ayuda">Digite un correo válido.</div>
                </div>

                <div class="campo">
                    <input name="ctelefono" placeholder="Teléfono" maxlength="10" inputmode="numeric" pattern="[0-9]{0,10}" oninput="soloNumeros(this)">
                    <div class="ayuda">Digite solo números. No más de 10 números.</div>
                </div>

                <div class="campo">
                    <input name="cusuario" placeholder="Usuario" required>
                    <div class="ayuda">Nombre de usuario para iniciar sesión.</div>
                </div>

                <div class="campo">
                    <input type="password" name="cclave" id="clave" placeholder="Contraseña" required minlength="8" pattern="(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}" oninput="validarClave()">
                    <div class="ayuda">Debe tener mínimo 8 caracteres, mayúsculas, números y símbolos.</div>
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

                <div class="campo">
                    <select name="cidperfil" required>
                        <option value="1">Administrador</option>
                        <option value="2">Doctor</option>
                        <option value="3">Cliente</option>
                    </select>
                    <div class="ayuda">Seleccione el permiso o rol del usuario.</div>
                </div>
            </div>

            <button type="submit">Guardar usuario</button>
            <a class="btn secondary" href="listaUsuarios.jsp">Volver</a>
        </form>
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
        if (puntos <= 1) { nivel.textContent = 'Débil'; nivel.className = 'debil'; }
        else if (puntos <= 3) { nivel.textContent = 'Media'; nivel.className = 'media'; }
        else { nivel.textContent = 'Fuerte'; nivel.className = 'fuerte'; }
    }

    function marcar(id, ok) {
        document.getElementById(id).className = ok ? 'cumple' : '';
    }
</script>
</body>
</html>
