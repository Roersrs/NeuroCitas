<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>NeuroCitas - Solicitud Neurólogo</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="login-body">

<div class="login-container" style="max-width:860px;">

    <div class="hero">
        <div class="hero-badge">NeuroCitas</div>

        <h1>¿Eres neurólogo?</h1>

        <p class="hero-sub">
            Únete a NeuroCitas como especialista. Gestiona tus citas, horarios de atención
            y brinda atención neurológica de calidad a los pacientes.
        </p>

        <br>

        <p class="hero-sub" style="font-size:13px;color:#5a6a7e;">
            Tu solicitud será revisada por el administrador. Una vez aprobada,
            podrás iniciar sesión con las credenciales que registres aquí.
        </p>
    </div>

    <div class="login-card">

        <h2>Solicitud de registro — Neurólogo</h2>

        <%
            String err = request.getParameter("error");

            if ("validacion".equals(err)) {
        %>
            <div class="msg error">
                Verifica los campos: identificación, teléfono, especialidad y contraseña segura.
            </div>
        <% } else if (err != null) { %>
            <div class="msg error">
                No se pudo enviar la solicitud. Es posible que la identificación,
                el correo o el usuario ya existan.
            </div>
        <% } %>

        <form method="post" action="ControladorSolicitudDoctor">

            <div class="form-grid">

                <div class="campo">
                    <label>Identificación</label>
                    <input type="text"
                           name="cidentificacion"
                           placeholder="Cédula (máx 10 dígitos)"
                           maxlength="10"
                           pattern="\d{1,10}"
                           oninput="soloNumeros(this)"
                           required>
                </div>

                <div class="campo">
                    <label>Teléfono</label>
                    <input type="text"
                           name="ctelefono"
                           placeholder="Teléfono (máx 10 dígitos)"
                           maxlength="10"
                           pattern="\d{1,10}"
                           oninput="soloNumeros(this)"
                           required>
                </div>

                <div class="campo">
                    <label>Nombre</label>
                    <input type="text"
                           name="cnombre"
                           placeholder="Nombre"
                           required>
                </div>

                <div class="campo">
                    <label>Apellido</label>
                    <input type="text"
                           name="capellido"
                           placeholder="Apellido"
                           required>
                </div>

                <div class="campo full">
                    <label>Correo electrónico</label>
                    <input type="email"
                           name="cmail"
                           placeholder="correo@ejemplo.com"
                           required>
                </div>

                <div class="campo full">
                    <label>Especialidad en neurociencias</label>

                    <select name="cespecialidad" required>
                        <option value="">Seleccione una especialidad</option>
                        <option value="Neurología clínica">Neurología clínica</option>
                        <option value="Neurología pediátrica">Neurología pediátrica</option>
                        <option value="Epileptología">Epileptología</option>
                        <option value="Neurofisiología clínica">Neurofisiología clínica</option>
                        <option value="Neuropsicología">Neuropsicología</option>
                        <option value="Trastornos del movimiento">Trastornos del movimiento</option>
                        <option value="Cefaleas y migraña">Cefaleas y migraña</option>
                        <option value="Enfermedad cerebrovascular">Enfermedad cerebrovascular</option>
                        <option value="Neuroinmunología">Neuroinmunología</option>
                        <option value="Demencias y deterioro cognitivo">Demencias y deterioro cognitivo</option>
                    </select>
                </div>

                <div class="campo">
                    <label>Nombre de usuario</label>
                    <input type="text"
                           name="cusuario"
                           placeholder="Usuario único"
                           required
                           autocomplete="username">
                </div>

                <div class="campo">
                    <label>Contraseña</label>
                    <input type="password"
                           name="cclave"
                           placeholder="Contraseña segura"
                           required
                           autocomplete="new-password"
                           id="claveInput"
                           oninput="validarClave(this.value)">

                    <div class="password-box">
                        <span id="nivelClave">Seguridad: —</span>

                        <ul>
                            <li id="r-len">Mínimo 8 caracteres</li>
                            <li id="r-may">Al menos una mayúscula</li>
                            <li id="r-num">Al menos un número</li>
                            <li id="r-esp">Al menos un carácter especial</li>
                        </ul>
                    </div>
                </div>

            </div>

            <button type="submit" style="width:100%;margin-top:14px;">
                Enviar solicitud
            </button>

        </form>

        <div class="links">
            <a href="index.jsp" style="color:var(--primary);font-weight:700;">
                Volver al inicio
            </a>
        </div>

    </div>

</div>

<script>
    function soloNumeros(input) {
        input.value = input.value.replace(/[^0-9]/g, '').slice(0, 10);
    }

    function validarClave(v) {
        const ok = c => document.getElementById(c).classList;

        const len = v.length >= 8;
        ok('r-len')[len ? 'add' : 'remove']('cumple');

        const may = /[A-Z]/.test(v);
        ok('r-may')[may ? 'add' : 'remove']('cumple');

        const num = /[0-9]/.test(v);
        ok('r-num')[num ? 'add' : 'remove']('cumple');

        const esp = /[^A-Za-z0-9]/.test(v);
        ok('r-esp')[esp ? 'add' : 'remove']('cumple');

        const pts = [len, may, num, esp].filter(Boolean).length;
        const n = document.getElementById('nivelClave');

        n.className = pts <= 1 ? 'debil' : pts <= 3 ? 'media' : 'fuerte';
        n.textContent = 'Seguridad: ' + (pts <= 1 ? 'Débil' : pts <= 3 ? 'Media' : 'Fuerte');
    }
</script>

</body>
</html>