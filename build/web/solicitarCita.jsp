<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="config.Conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>

<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (actual.getIdperfil() != 3) {
        response.sendRedirect("front.jsp");
        return;
    }

    String ok = request.getParameter("ok");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Solicitar cita</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

<div class="page">

    <div class="page-header">
        <div>
            <h1>Solicitar cita</h1>
            <p class="muted">
                Agenda una cita con un neurólogo disponible del sistema.
            </p>
        </div>
    </div>

    <% if ("creada".equals(ok)) { %>
        <div class="msg ok">
            La cita fue solicitada correctamente.
        </div>
    <% } %>

    <% if ("campos".equals(error)) { %>
        <div class="msg error">
            Debes completar todos los campos.
        </div>
    <% } else if ("ocupada".equals(error)) { %>
        <div class="msg error">
            Ya existe una cita registrada con ese neurólogo en esa fecha y hora.
        </div>
    <% } else if ("guardar".equals(error)) { %>
        <div class="msg error">
            No se pudo guardar la cita.
        </div>
    <% } %>

    <div class="card mt-20">

        <h2>Nueva solicitud de cita</h2>

        <p class="muted">
            Selecciona el neurólogo. Según su especialidad y horarios registrados, se habilitarán los servicios, fechas y horas disponibles.
        </p>

        <form action="SolicitarCita" method="post">

            <div class="form-grid">

                <div>
                    <label>Neurólogo</label>

                    <select name="idDoctor" id="idDoctor" required onchange="actualizarFormulario()">
                        <option value="" data-especialidad="">
                            Seleccione un neurólogo
                        </option>

                        <%
                            try {
                                Conexion cn = new Conexion();
                                Connection con = cn.crearConexion();

                                String q = "SELECT identificacion, nombre, apellido, especialidad "
                                        + "FROM Usuario "
                                        + "WHERE id_perfil = 2 "
                                        + "AND id_estado = 1 "
                                        + "ORDER BY nombre, apellido";

                                PreparedStatement ps = con.prepareStatement(q);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    String idDoctor = rs.getString("identificacion");
                                    String nombreDoctor = rs.getString("nombre") + " " + rs.getString("apellido");
                                    String especialidad = rs.getString("especialidad");

                                    if (especialidad == null || especialidad.trim().isEmpty()) {
                                        especialidad = "Sin especialidad registrada";
                                    }
                        %>

                            <option value="<%= idDoctor %>" data-especialidad="<%= especialidad %>">
                                Dr(a). <%= nombreDoctor %>
                            </option>

                        <%
                                }

                                rs.close();
                                ps.close();
                                con.close();

                            } catch (Exception e) {
                                out.println("<option value='' data-especialidad=''>Error al cargar neurólogos</option>");
                            }
                        %>
                    </select>
                </div>

                <div>
                    <label>Especialidad del neurólogo</label>
                    <input type="text"
                           id="especialidadDoctor"
                           name="especialidadDoctor"
                           placeholder="La especialidad aparecerá automáticamente"
                           readonly>
                </div>

                <div>
                    <label>Servicio neurológico</label>

                    <select name="idServicio" id="idServicio" required>
                        <option value="">
                            Primero seleccione un neurólogo
                        </option>

                        <%
                            try {
                                Conexion cn = new Conexion();
                                Connection con = cn.crearConexion();

                                String q = "SELECT id_servicio, nombre_servicio "
                                        + "FROM Servicio "
                                        + "WHERE id_estado = 1 "
                                        + "ORDER BY nombre_servicio";

                                PreparedStatement ps = con.prepareStatement(q);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    String nombreServicio = rs.getString("nombre_servicio");
                        %>

                            <option value="<%= rs.getInt("id_servicio") %>"
                                    data-servicio="<%= nombreServicio %>"
                                    style="display:none;">
                                <%= nombreServicio %>
                            </option>

                        <%
                                }

                                rs.close();
                                ps.close();
                                con.close();

                            } catch (Exception e) {
                                out.println("<option value=''>Error al cargar servicios</option>");
                            }
                        %>
                    </select>

                    <p class="muted" id="ayudaServicio" style="margin-top:8px;">
                        Los servicios se mostrarán según la especialidad del neurólogo seleccionado.
                    </p>
                </div>

                <div>
                    <label>Fecha disponible</label>

                    <select name="fecha" id="fecha" required onchange="actualizarHorasDisponibles()">
                        <option value="">
                            Primero seleccione un neurólogo
                        </option>
                    </select>

                    <p class="muted" id="ayudaFecha" style="margin-top:8px;">
                        Las fechas se generan automáticamente según los horarios del neurólogo.
                    </p>
                </div>

                <div>
                    <label>Hora disponible</label>

                    <select name="hora" id="hora" required>
                        <option value="">
                            Primero seleccione una fecha
                        </option>
                    </select>

                    <p class="muted" id="ayudaHora" style="margin-top:8px;">
                        Las horas disponibles aparecerán según la fecha seleccionada.
                    </p>
                </div>

                <div class="full">
                    <label>Motivo u observación</label>
                    <textarea name="observacion"
                              placeholder="Describe brevemente el motivo de la cita."></textarea>
                </div>

            </div>

            <div style="margin-top:20px;">
                <button type="submit" class="btn">
                    Solicitar cita
                </button>
            </div>

        </form>

    </div>

</div>

<script>
    const horariosDoctor = {};
    const citasOcupadas = {};

    <%
        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();

            String q = "SELECT id_doctor, dia_semana, hora_inicio, hora_fin "
                    + "FROM horarios "
                    + "WHERE id_estado = 1 "
                    + "ORDER BY id_doctor, dia_semana, hora_inicio";

            PreparedStatement ps = con.prepareStatement(q);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String idDoctor = rs.getString("id_doctor");
                String diaSemana = rs.getString("dia_semana");
                String horaInicio = rs.getString("hora_inicio");
                String horaFin = rs.getString("hora_fin");
    %>

        if (!horariosDoctor["<%= idDoctor %>"]) {
            horariosDoctor["<%= idDoctor %>"] = [];
        }

        horariosDoctor["<%= idDoctor %>"].push({
            dia: "<%= diaSemana %>",
            inicio: "<%= horaInicio %>",
            fin: "<%= horaFin %>"
        });

    <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            System.out.println("ERROR AL CARGAR HORARIOS EN SOLICITAR CITA: " + e.getMessage());
        }
    %>

    <%
        try {
            Conexion cn = new Conexion();
            Connection con = cn.crearConexion();

            String q = "SELECT identificacion_doctor, fecha, hora "
                    + "FROM Cita "
                    + "WHERE id_estado = 1 "
                    + "AND estado <> 'Cancelada'";

            PreparedStatement ps = con.prepareStatement(q);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String idDoctor = rs.getString("identificacion_doctor");
                String fecha = rs.getString("fecha");
                String hora = rs.getString("hora");
    %>

        if (!citasOcupadas["<%= idDoctor %>"]) {
            citasOcupadas["<%= idDoctor %>"] = {};
        }

        if (!citasOcupadas["<%= idDoctor %>"]["<%= fecha %>"]) {
            citasOcupadas["<%= idDoctor %>"]["<%= fecha %>"] = [];
        }

        citasOcupadas["<%= idDoctor %>"]["<%= fecha %>"].push("<%= hora %>");

    <%
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            System.out.println("ERROR AL CARGAR CITAS OCUPADAS EN SOLICITAR CITA: " + e.getMessage());
        }
    %>

    function normalizarTexto(texto) {
        return texto
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim();
    }

    function servicioPermitido(especialidad, servicio) {
        especialidad = normalizarTexto(especialidad);
        servicio = normalizarTexto(servicio);

        if (especialidad.includes("neurologia pediatrica")) {
            return servicio.includes("pediatrica")
                || servicio.includes("epilepsia")
                || servicio.includes("electroencefalograma")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("epileptologia")) {
            return servicio.includes("epilepsia")
                || servicio.includes("electroencefalograma")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("neurofisiologia")) {
            return servicio.includes("electroencefalograma")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("cefaleas") || especialidad.includes("migrana")) {
            return servicio.includes("cefalea")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("trastornos del movimiento")) {
            return servicio.includes("control neurologico")
                || servicio.includes("consulta neurologica inicial");
        }

        if (especialidad.includes("enfermedad cerebrovascular")) {
            return servicio.includes("tomografia")
                || servicio.includes("resonancia")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("neuropsicologia")) {
            return servicio.includes("evaluacion")
                || servicio.includes("control neurologico")
                || servicio.includes("consulta neurologica inicial");
        }

        if (especialidad.includes("demencias") || especialidad.includes("deterioro cognitivo")) {
            return servicio.includes("evaluacion")
                || servicio.includes("resonancia")
                || servicio.includes("tomografia")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("neuroinmunologia")) {
            return servicio.includes("resonancia")
                || servicio.includes("consulta neurologica inicial")
                || servicio.includes("control neurologico");
        }

        if (especialidad.includes("neurologia clinica")) {
            return true;
        }

        return servicio.includes("consulta neurologica inicial")
            || servicio.includes("control neurologico");
    }

    function actualizarFormulario() {
        actualizarEspecialidad();
        actualizarServicios();
        actualizarFechasDisponibles();
        limpiarHoras();
    }

    function actualizarEspecialidad() {
        const selectDoctor = document.getElementById("idDoctor");
        const especialidadInput = document.getElementById("especialidadDoctor");

        const opcionDoctor = selectDoctor.options[selectDoctor.selectedIndex];
        const especialidad = opcionDoctor.getAttribute("data-especialidad") || "";

        especialidadInput.value = especialidad;
    }

    function actualizarServicios() {
        const especialidad = document.getElementById("especialidadDoctor").value;
        const selectServicio = document.getElementById("idServicio");
        const ayudaServicio = document.getElementById("ayudaServicio");

        selectServicio.value = "";

        let cantidadServicios = 0;

        for (let i = 0; i < selectServicio.options.length; i++) {
            const option = selectServicio.options[i];

            if (i === 0) {
                option.text = especialidad ? "Seleccione un servicio" : "Primero seleccione un neurólogo";
                option.style.display = "block";
                continue;
            }

            const nombreServicio = option.getAttribute("data-servicio") || "";

            if (especialidad && servicioPermitido(especialidad, nombreServicio)) {
                option.style.display = "block";
                option.disabled = false;
                cantidadServicios++;
            } else {
                option.style.display = "none";
                option.disabled = true;
            }
        }

        if (!especialidad) {
            ayudaServicio.textContent = "Los servicios se mostrarán según la especialidad del neurólogo seleccionado.";
        } else if (cantidadServicios === 0) {
            ayudaServicio.textContent = "No hay servicios asociados a esta especialidad.";
        } else {
            ayudaServicio.textContent = "Servicios disponibles para: " + especialidad + ".";
        }
    }

    function nombreDiaSemana(fecha) {
        const dias = [
            "Domingo",
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes",
            "Sábado"
        ];

        return dias[fecha.getDay()];
    }

    function formatearFechaValor(fecha) {
        const y = fecha.getFullYear();
        const m = String(fecha.getMonth() + 1).padStart(2, "0");
        const d = String(fecha.getDate()).padStart(2, "0");

        return y + "-" + m + "-" + d;
    }

    function formatearFechaTexto(fecha) {
        const d = String(fecha.getDate()).padStart(2, "0");
        const m = String(fecha.getMonth() + 1).padStart(2, "0");
        const y = fecha.getFullYear();

        return d + "/" + m + "/" + y;
    }

    function actualizarFechasDisponibles() {
        const selectDoctor = document.getElementById("idDoctor");
        const idDoctor = selectDoctor.value;
        const selectFecha = document.getElementById("fecha");
        const ayudaFecha = document.getElementById("ayudaFecha");

        selectFecha.innerHTML = "";

        if (!idDoctor) {
            const option = document.createElement("option");
            option.value = "";
            option.textContent = "Primero seleccione un neurólogo";
            selectFecha.appendChild(option);

            ayudaFecha.textContent = "Las fechas se generan automáticamente según los horarios del neurólogo.";
            return;
        }

        const horarios = horariosDoctor[idDoctor] || [];

        if (horarios.length === 0) {
            const option = document.createElement("option");
            option.value = "";
            option.textContent = "Este neurólogo no tiene horarios disponibles";
            selectFecha.appendChild(option);

            ayudaFecha.textContent = "El neurólogo seleccionado todavía no tiene horarios creados.";
            return;
        }

        const optionInicial = document.createElement("option");
        optionInicial.value = "";
        optionInicial.textContent = "Seleccione una fecha disponible";
        selectFecha.appendChild(optionInicial);

        let fechasAgregadas = 0;
        const hoy = new Date();

        for (let i = 1; i <= 45; i++) {
            const fecha = new Date();
            fecha.setDate(hoy.getDate() + i);

            const dia = nombreDiaSemana(fecha);
            const horariosDelDia = horarios.filter(h => h.dia === dia);

            if (horariosDelDia.length > 0) {
                const option = document.createElement("option");

                option.value = formatearFechaValor(fecha);
                option.textContent = dia + " - " + formatearFechaTexto(fecha);

                let rangos = horariosDelDia.map(h => h.inicio + " a " + h.fin).join(" | ");
                option.setAttribute("data-rangos", rangos);
                option.setAttribute("data-dia", dia);

                selectFecha.appendChild(option);
                fechasAgregadas++;
            }
        }

        if (fechasAgregadas === 0) {
            const option = document.createElement("option");
            option.value = "";
            option.textContent = "No hay fechas disponibles próximas";
            selectFecha.appendChild(option);

            ayudaFecha.textContent = "No se encontraron fechas disponibles en los próximos 45 días.";
        } else {
            ayudaFecha.textContent = "Se encontraron " + fechasAgregadas + " fechas disponibles para este neurólogo.";
        }
    }

    function limpiarHoras() {
        const selectHora = document.getElementById("hora");
        const ayudaHora = document.getElementById("ayudaHora");

        selectHora.innerHTML = "";

        const option = document.createElement("option");
        option.value = "";
        option.textContent = "Primero seleccione una fecha";
        selectHora.appendChild(option);

        ayudaHora.textContent = "Las horas disponibles aparecerán según la fecha seleccionada.";
    }

    function horaATotalMinutos(hora) {
        const partes = hora.split(":");
        return parseInt(partes[0]) * 60 + parseInt(partes[1]);
    }

    function totalMinutosAHora(total) {
        const h = Math.floor(total / 60);
        const m = total % 60;

        return String(h).padStart(2, "0") + ":" + String(m).padStart(2, "0");
    }

    function horaOcupada(idDoctor, fecha, hora) {
        if (!citasOcupadas[idDoctor]) {
            return false;
        }

        if (!citasOcupadas[idDoctor][fecha]) {
            return false;
        }

        const ocupadas = citasOcupadas[idDoctor][fecha];

        for (let i = 0; i < ocupadas.length; i++) {
            if (ocupadas[i].substring(0, 5) === hora) {
                return true;
            }
        }

        return false;
    }

    function actualizarHorasDisponibles() {
        const idDoctor = document.getElementById("idDoctor").value;
        const selectFecha = document.getElementById("fecha");
        const fecha = selectFecha.value;
        const opcionFecha = selectFecha.options[selectFecha.selectedIndex];

        const selectHora = document.getElementById("hora");
        const ayudaHora = document.getElementById("ayudaHora");

        selectHora.innerHTML = "";

        if (!idDoctor || !fecha) {
            const option = document.createElement("option");
            option.value = "";
            option.textContent = "Primero seleccione una fecha";
            selectHora.appendChild(option);

            ayudaHora.textContent = "Las horas disponibles aparecerán según la fecha seleccionada.";
            return;
        }

        const dia = opcionFecha.getAttribute("data-dia");
        const horarios = horariosDoctor[idDoctor] || [];
        const horariosDelDia = horarios.filter(h => h.dia === dia);

        if (horariosDelDia.length === 0) {
            const option = document.createElement("option");
            option.value = "";
            option.textContent = "No hay horas disponibles";
            selectHora.appendChild(option);

            ayudaHora.textContent = "No hay horarios creados para esta fecha.";
            return;
        }

        const optionInicial = document.createElement("option");
        optionInicial.value = "";
        optionInicial.textContent = "Seleccione una hora disponible";
        selectHora.appendChild(optionInicial);

        let cantidadHoras = 0;

        for (let i = 0; i < horariosDelDia.length; i++) {
            const inicio = horaATotalMinutos(horariosDelDia[i].inicio.substring(0, 5));
            const fin = horaATotalMinutos(horariosDelDia[i].fin.substring(0, 5));

            for (let minuto = inicio; minuto < fin; minuto += 30) {
                const hora = totalMinutosAHora(minuto);

                if (!horaOcupada(idDoctor, fecha, hora)) {
                    const option = document.createElement("option");
                    option.value = hora;
                    option.textContent = hora;
                    selectHora.appendChild(option);
                    cantidadHoras++;
                }
            }
        }

        if (cantidadHoras === 0) {
            const option = document.createElement("option");
            option.value = "";
            option.textContent = "No hay horas disponibles";
            selectHora.appendChild(option);

            ayudaHora.textContent = "Todas las horas de esta fecha ya están ocupadas.";
        } else {
            ayudaHora.textContent = "Hay " + cantidadHoras + " horas disponibles para esta fecha.";
        }
    }

    window.onload = function () {
        actualizarFormulario();
    };
</script>

</body>
</html>