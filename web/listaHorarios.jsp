<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="modelo.Horario"%>
<%@page import="modelo.HorarioDAO"%>
<%@page import="java.util.List"%>

<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (actual.getIdperfil() != 1) {
        response.sendRedirect("front.jsp");
        return;
    }

    UsuarioDAO udao = new UsuarioDAO();
    HorarioDAO hdao = new HorarioDAO();

    List<Usuario> doctores = udao.listarDoctores();
    List<Horario> horarios = hdao.listarTodos();

    String ok = request.getParameter("ok");
    String error = request.getParameter("error");

    String[] dias = {
        "Lunes",
        "Martes",
        "Miércoles",
        "Jueves",
        "Viernes",
        "Sábado",
        "Domingo"
    };
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Calendario de neurólogos | NeuroCitas</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f3f7fb;
            color: #10233f;
        }

        .wrap {
            padding: 24px;
            max-width: 1600px;
            margin: auto;
        }

        /* ============================= */
        /* ENCABEZADO */
        /* ============================= */

        .hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 28px 32px;
            color: white;

            background:
                linear-gradient(
                    120deg,
                    #071b3a,
                    #0b315f 58%,
                    #075d8c
                );

            box-shadow:
                0 18px 45px rgba(10,42,78,.18);

            animation: entrada .5s ease;
        }

        .hero h1 {
            font-size: 34px;
            margin: 8px 0 7px;
        }

        .hero p {
            margin: 0;
            color: #c6ddf2;
        }

        .eyebrow {
            color: #65d3ff;
            letter-spacing: 2px;
            font-size: 12px;
            font-weight: 800;
        }

        .brain {
            position: absolute;
            right: 40px;
            top: 10px;
            font-size: 100px;
            opacity: .18;
            animation: pulso 3s infinite;
        }

        /* ============================= */
        /* TARJETAS */
        /* ============================= */

        .card {
            background: white;
            margin-top: 20px;
            padding: 22px;
            border-radius: 20px;
            border: 1px solid #dce8f3;

            box-shadow:
                0 10px 30px rgba(20,55,90,.07);

            animation: entrada .6s ease;
        }

        .card-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .title-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            background: #e8f4ff;
            font-size: 24px;
        }

        .card h2 {
            margin: 0;
            font-size: 21px;
        }

        .sub {
            color: #7188a5;
            font-size: 13px;
            margin-top: 4px;
        }

        /* ============================= */
        /* ALERTAS */
        /* ============================= */

        .alert {
            padding: 12px 15px;
            border-radius: 12px;
            margin-bottom: 15px;
            font-weight: 700;
            font-size: 13px;
        }

        .success {
            background: #e7faef;
            color: #13763e;
        }

        .error {
            background: #fff0f0;
            color: #b72d2d;
        }

        /* ============================= */
        /* FORMULARIO */
        /* ============================= */

        .form-grid {
            display: grid;
            grid-template-columns:
                1.4fr
                1fr
                .8fr
                .8fr
                auto;

            gap: 12px;
            align-items: end;
        }

        .field label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 7px;
        }

        .field select,
        .field input,
        .filter-select {
            width: 100%;
            height: 45px;
            border: 1px solid #cbdbe9;
            border-radius: 11px;
            background: #fbfdff;
            padding: 0 12px;
            color: #17304d;
            outline: none;
            transition: .2s;
        }

        .field select:focus,
        .field input:focus,
        .filter-select:focus {
            border-color: #1687e7;

            box-shadow:
                0 0 0 4px rgba(22,135,231,.1);
        }

        /* ============================= */
        /* BOTONES */
        /* ============================= */

        .btn {
            height: 45px;
            border: 0;
            border-radius: 11px;
            padding: 0 18px;
            font-weight: 800;
            cursor: pointer;
            transition: .2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .primary {
            background:
                linear-gradient(
                    135deg,
                    #0875df,
                    #159ee9
                );

            color: white;

            box-shadow:
                0 8px 18px rgba(8,117,223,.22);
        }

        /* ============================= */
        /* FILTRO */
        /* ============================= */

        .calendar-tools {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-select {
            width: 250px;
        }

        /* ============================= */
        /* CALENDARIO */
        /* ============================= */

        .calendar-scroll {
            overflow-x: auto;
            border-radius: 16px;
            border: 1px solid #dce7f1;
        }

        .calendar {
            width: 100%;
            min-width: 1150px;
            border-collapse: collapse;
            table-layout: fixed;
            background: white;
        }

        .calendar thead th {
            background: #12385d;
            color: white;
            padding: 15px 8px;
            font-size: 13px;

            border-right:
                1px solid rgba(255,255,255,.12);
        }

        .calendar thead th:first-child {
            width: 80px;
            background: #0b2948;
        }

        .calendar td {
            border-right: 1px solid #e2eaf2;
            border-bottom: 1px solid #e2eaf2;
            vertical-align: top;
            height: 95px;
            padding: 8px;
            background: #fbfdff;
            transition: .2s;
        }

        .calendar td:hover {
            background: #f2f8fe;
        }

        .day-title {
            font-weight: 800;
        }

        .day-small {
            display: block;
            font-size: 10px;
            color: #a9c5df;
            margin-top: 3px;
        }

        .hour {
            background: #f0f6fb !important;
            text-align: center;
            font-size: 12px;
            font-weight: 800;
            color: #54708c;
            vertical-align: middle !important;
        }

        /* ============================= */
        /* HORARIO */
        /* ============================= */

        .schedule {
            position: relative;

            background:
                linear-gradient(
                    135deg,
                    #e3f2ff,
                    #edf8ff
                );

            border-left: 4px solid #1385e4;
            border-radius: 11px;
            padding: 9px;
            margin-bottom: 6px;
            cursor: pointer;

            box-shadow:
                0 5px 14px rgba(25,105,175,.10);

            transition: .2s;

            animation:
                aparecer .35s ease;
        }

        .schedule:hover {
            transform:
                translateY(-3px)
                scale(1.02);

            box-shadow:
                0 9px 20px rgba(25,105,175,.20);
        }

        .schedule-name {
            font-weight: 900;
            font-size: 12px;
            color: #0a4e8d;
        }

        .schedule-specialty {
            font-size: 10px;
            color: #6d8299;
            margin-top: 3px;
        }

        .schedule-time {
            display: inline-block;
            margin-top: 6px;
            background: white;
            color: #164b78;
            padding: 4px 7px;
            border-radius: 7px;
            font-size: 10px;
            font-weight: 800;
        }

        /* ============================= */
        /* LEYENDA */
        /* ============================= */

        .legend {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 15px;
            color: #6d8298;
            font-size: 12px;
        }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #1687e7;
        }

        /* ============================= */
        /* MODAL */
        /* ============================= */

        .modal {
            position: fixed;
            inset: 0;
            background: rgba(4,18,35,.55);
            backdrop-filter: blur(4px);

            display: none;
            align-items: center;
            justify-content: center;

            padding: 20px;
            z-index: 9999;
        }

        .modal.show {
            display: flex;
        }

        .modal-box {
            width: 100%;
            max-width: 430px;
            background: white;
            border-radius: 20px;
            overflow: hidden;

            box-shadow:
                0 25px 70px rgba(0,0,0,.25);

            animation:
                modalEntrada .25s ease;
        }

        .modal-head {
            padding: 22px;
            color: white;

            background:
                linear-gradient(
                    135deg,
                    #08294c,
                    #0871b6
                );

            position: relative;
        }

        .modal-head h2 {
            margin: 0 0 5px;
        }

        .modal-head p {
            margin: 0;
            color: #cde6fa;
            font-size: 13px;
        }

        .close {
            position: absolute;
            right: 17px;
            top: 15px;

            width: 35px;
            height: 35px;

            border: 0;
            border-radius: 50%;

            background:
                rgba(255,255,255,.15);

            color: white;
            font-size: 20px;
            cursor: pointer;
        }

        .modal-body {
            padding: 22px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;

            padding: 12px 0;

            border-bottom:
                1px solid #edf2f7;

            font-size: 13px;
        }

        .info-row span {
            color: #71859b;
        }

        .info-row strong {
            text-align: right;
            color: #173653;
        }

        .delete-form {
            margin-top: 20px;
        }

        .delete {
            width: 100%;
            background: #ffe7e7;
            color: #bf2929;
        }

        /* ============================= */
        /* ANIMACIONES */
        /* ============================= */

        @keyframes entrada {

            from {
                opacity: 0;
                transform: translateY(12px);
            }

            to {
                opacity: 1;
                transform: none;
            }
        }

        @keyframes aparecer {

            from {
                opacity: 0;
                transform: scale(.94);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes modalEntrada {

            from {
                opacity: 0;
                transform: scale(.92);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes pulso {

            50% {
                transform: scale(1.08);
            }
        }

        /* ============================= */
        /* RESPONSIVE */
        /* ============================= */

        @media(max-width:1000px) {

            .form-grid {
                grid-template-columns: 1fr 1fr;
            }

            .card-title {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media(max-width:600px) {

            .wrap {
                padding: 12px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .hero h1 {
                font-size: 27px;
            }

            .brain {
                display: none;
            }
        }

    </style>

</head>

<body>


<div class="wrap">


    <!-- ============================== -->
    <!-- ENCABEZADO -->
    <!-- ============================== -->

    <section class="hero">

        <div class="eyebrow">
            NEUROCITAS · ADMINISTRACIÓN
        </div>

        <h1>
            📅 Calendario de neurólogos
        </h1>

        <p>
            Consulta y administra la disponibilidad semanal
            del equipo de neurología.
        </p>

        <div class="brain">
            🧠
        </div>

    </section>


    <!-- ============================== -->
    <!-- AGREGAR HORARIO -->
    <!-- ============================== -->

    <section class="card">


        <div class="card-title">

            <div class="title-left">

                <div class="icon">
                    ➕
                </div>

                <div>

                    <h2>
                        Agregar horario
                    </h2>

                    <div class="sub">
                        Registra la disponibilidad de un neurólogo.
                    </div>

                </div>

            </div>

        </div>


        <% if ("agregado".equals(ok)) { %>

            <div class="alert success">
                ✓ Horario agregado correctamente.
            </div>

        <% } %>


        <% if ("eliminado".equals(ok)) { %>

            <div class="alert success">
                ✓ Horario eliminado correctamente.
            </div>

        <% } %>


        <% if (error != null) { %>

            <div class="alert error">

                ⚠

                <%= "cruce".equals(error)
                        ? "Ese neurólogo ya tiene un horario en ese rango."
                        : "hora".equals(error)
                        ? "La hora de inicio debe ser menor que la hora final."
                        : "campos".equals(error)
                        ? "Completa todos los campos."
                        : "No fue posible realizar la operación."
                %>

            </div>

        <% } %>


        <form action="CtrolHorario"
              method="post">


            <input
                type="hidden"
                name="accion"
                value="agregar"
            >


            <div class="form-grid">


                <div class="field">

                    <label>
                        Neurólogo
                    </label>

                    <select
                        name="idDoctor"
                        required
                    >

                        <option value="">
                            Seleccione un neurólogo
                        </option>


                        <% for (Usuario d : doctores) { %>

                            <option value="<%= d.getIdentificacion() %>">

                                Dr(a).
                                <%= d.getNombre() %>
                                <%= d.getApellido() %>

                            </option>

                        <% } %>

                    </select>

                </div>


                <div class="field">

                    <label>
                        Día
                    </label>

                    <select
                        name="diaSemana"
                        required
                    >

                        <option value="">
                            Seleccione un día
                        </option>

                        <option>Lunes</option>
                        <option>Martes</option>
                        <option>Miércoles</option>
                        <option>Jueves</option>
                        <option>Viernes</option>
                        <option>Sábado</option>
                        <option>Domingo</option>

                    </select>

                </div>


                <div class="field">

                    <label>
                        Hora inicio
                    </label>

                    <input
                        type="time"
                        name="horaInicio"
                        required
                    >

                </div>


                <div class="field">

                    <label>
                        Hora fin
                    </label>

                    <input
                        type="time"
                        name="horaFin"
                        required
                    >

                </div>


                <button
                    class="btn primary"
                    type="submit"
                >

                    ＋ Agregar

                </button>


            </div>


        </form>


    </section>


    <!-- ============================== -->
    <!-- CALENDARIO -->
    <!-- ============================== -->

    <section class="card">


        <div class="card-title">


            <div class="title-left">

                <div class="icon">
                    🗓️
                </div>

                <div>

                    <h2>
                        Calendario semanal
                    </h2>

                    <div class="sub">
                        Horarios activos de todos los neurólogos.
                    </div>

                </div>

            </div>


            <div class="calendar-tools">

                <select
                    id="filtroDoctor"
                    class="filter-select"
                    onchange="filtrarDoctor()"
                >

                    <option value="">
                        Todos los neurólogos
                    </option>


                    <% for (Usuario d : doctores) { %>

                        <option value="<%= d.getIdentificacion() %>">

                            <%= d.getNombre() %>
                            <%= d.getApellido() %>

                        </option>

                    <% } %>

                </select>

            </div>


        </div>


        <div class="calendar-scroll">


            <table class="calendar">


                <thead>

                    <tr>

                        <th>
                            HORA
                        </th>


                        <% for (String dia : dias) { %>

                            <th>

                                <span class="day-title">
                                    <%= dia.toUpperCase() %>
                                </span>

                                <span class="day-small">
                                    Disponibilidad
                                </span>

                            </th>

                        <% } %>

                    </tr>

                </thead>


                <tbody>


                <%
                    for (int hora = 6; hora <= 21; hora++) {
                %>


                    <tr>


                        <td class="hour">

                            <%= String.format("%02d:00", hora) %>

                        </td>


                        <%
                            for (String dia : dias) {
                        %>


                        <td>


                            <%
                                if (horarios != null) {

                                    for (Horario h : horarios) {

                                        if (h.getDiaSemana() == null ||
                                            !h.getDiaSemana().equalsIgnoreCase(dia)) {

                                            continue;
                                        }


                                        String inicioTexto =
                                                String.valueOf(h.getHoraInicio());

                                        String finTexto =
                                                String.valueOf(h.getHoraFin());


                                        int horaInicio = -1;


                                        try {

                                            String[] partes =
                                                    inicioTexto.split(":");

                                            horaInicio =
                                                    Integer.parseInt(partes[0]);

                                        } catch (Exception e) {

                                            horaInicio = -1;
                                        }


                                        if (horaInicio != hora) {

                                            continue;
                                        }


                                        String nombreDoctor =
                                                h.getIdDoctor();

                                        String especialidad =
                                                "Neurología";


                                        for (Usuario d : doctores) {

                                            if (d.getIdentificacion() != null &&
                                                d.getIdentificacion().equals(
                                                        h.getIdDoctor()
                                                )) {

                                                nombreDoctor =
                                                        d.getNombre()
                                                        + " "
                                                        + d.getApellido();


                                                if (d.getEspecialidad() != null &&
                                                    !d.getEspecialidad()
                                                      .trim()
                                                      .isEmpty()) {

                                                    especialidad =
                                                            d.getEspecialidad();
                                                }

                                                break;
                                            }
                                        }
                            %>


                            <div
                                class="schedule horario-item"

                                data-doctor="<%= h.getIdDoctor() %>"

                                data-idhorario="<%= h.getIdHorario() %>"

                                data-nombre="<%= nombreDoctor %>"

                                data-especialidad="<%= especialidad %>"

                                data-dia="<%= dia %>"

                                data-inicio="<%= inicioTexto %>"

                                data-fin="<%= finTexto %>"

                                onclick="abrirHorario(this)"
                            >


                                <div class="schedule-name">

                                    Dr(a).
                                    <%= nombreDoctor %>

                                </div>


                                <div class="schedule-specialty">

                                    🧠
                                    <%= especialidad %>

                                </div>


                                <div class="schedule-time">

                                    🕘
                                    <%= inicioTexto %>
                                    -
                                    <%= finTexto %>

                                </div>


                            </div>


                            <%
                                    }
                                }
                            %>


                        </td>


                        <%
                            }
                        %>


                    </tr>


                <%
                    }
                %>


                </tbody>


            </table>


        </div>


        <div class="legend">

            <span class="legend-dot"></span>

            Haz clic sobre un horario para ver sus detalles.

        </div>


    </section>


</div>


<!-- ============================== -->
<!-- MODAL -->
<!-- ============================== -->

<div
    class="modal"
    id="modalHorario"
    onclick="cerrarFondo(event)"
>


    <div class="modal-box">


        <div class="modal-head">


            <button
                type="button"
                class="close"
                onclick="cerrarModal()"
            >
                ×
            </button>


            <h2 id="modalDoctor">
                Neurólogo
            </h2>


            <p id="modalEspecialidad">
                Neurología
            </p>


        </div>


        <div class="modal-body">


            <div class="info-row">

                <span>
                    🪪 Identificación
                </span>

                <strong id="modalIdDoctor"></strong>

            </div>


            <div class="info-row">

                <span>
                    📅 Día
                </span>

                <strong id="modalDia"></strong>

            </div>


            <div class="info-row">

                <span>
                    🕘 Hora inicio
                </span>

                <strong id="modalInicio"></strong>

            </div>


            <div class="info-row">

                <span>
                    🕐 Hora fin
                </span>

                <strong id="modalFin"></strong>

            </div>


            <form
                action="CtrolHorario"
                method="post"
                class="delete-form"
                onsubmit="return confirm('¿Seguro que deseas eliminar este horario?');"
            >


                <input
                    type="hidden"
                    name="accion"
                    value="eliminar"
                >


                <input
                    type="hidden"
                    name="idHorario"
                    id="modalIdHorario"
                >


                <input
                    type="hidden"
                    name="idDoctor"
                    id="modalDoctorEliminar"
                >


                <button
                    type="submit"
                    class="btn delete"
                >

                    🗑 Eliminar horario

                </button>


            </form>


        </div>


    </div>


</div>


<script>

/* ============================= */
/* ABRIR HORARIO */
/* ============================= */

function abrirHorario(elemento) {

    var idHorario =
        elemento.getAttribute("data-idhorario");

    var idDoctor =
        elemento.getAttribute("data-doctor");

    var nombre =
        elemento.getAttribute("data-nombre");

    var especialidad =
        elemento.getAttribute("data-especialidad");

    var dia =
        elemento.getAttribute("data-dia");

    var inicio =
        elemento.getAttribute("data-inicio");

    var fin =
        elemento.getAttribute("data-fin");


    document.getElementById(
        "modalDoctor"
    ).textContent =
        "Dr(a). " + nombre;


    document.getElementById(
        "modalEspecialidad"
    ).textContent =
        especialidad;


    document.getElementById(
        "modalIdDoctor"
    ).textContent =
        idDoctor;


    document.getElementById(
        "modalDia"
    ).textContent =
        dia;


    document.getElementById(
        "modalInicio"
    ).textContent =
        inicio;


    document.getElementById(
        "modalFin"
    ).textContent =
        fin;


    document.getElementById(
        "modalIdHorario"
    ).value =
        idHorario;


    document.getElementById(
        "modalDoctorEliminar"
    ).value =
        idDoctor;


    document.getElementById(
        "modalHorario"
    ).classList.add("show");
}


/* ============================= */
/* CERRAR MODAL */
/* ============================= */

function cerrarModal() {

    document.getElementById(
        "modalHorario"
    ).classList.remove("show");
}


function cerrarFondo(event) {

    if (event.target.id === "modalHorario") {

        cerrarModal();
    }
}


/* ============================= */
/* FILTRAR NEURÓLOGO */
/* ============================= */

function filtrarDoctor() {

    var doctor =
        document.getElementById(
            "filtroDoctor"
        ).value;


    var horarios =
        document.querySelectorAll(
            ".horario-item"
        );


    horarios.forEach(function(item) {

        if (
            doctor === "" ||
            item.getAttribute("data-doctor") === doctor
        ) {

            item.style.display = "";

        } else {

            item.style.display = "none";
        }

    });
}


/* ============================= */
/* CERRAR CON ESC */
/* ============================= */

document.addEventListener(
    "keydown",
    function(event) {

        if (event.key === "Escape") {

            cerrarModal();
        }

    }
);

</script>


</body>

</html>