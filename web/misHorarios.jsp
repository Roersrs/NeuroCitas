<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Horario"%>
<%@page import="modelo.HorarioDAO"%>
<%@page import="java.util.List"%>

<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (actual.getIdperfil() != 2) {
        response.sendRedirect("front.jsp");
        return;
    }

    HorarioDAO horarioDAO = new HorarioDAO();

    List<Horario> lista =
            horarioDAO.listarPorDoctor(actual.getIdentificacion());

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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Mis horarios | NeuroCitas</title>

    <link rel="stylesheet" href="css/estilos.css">


    <style>

        * {
            box-sizing: border-box;
        }

        /* ========================================
           CONTENEDOR
        ======================================== */

        .schedule-page {
            padding: 5px;
        }


        /* ========================================
           ENCABEZADO
        ======================================== */

        .schedule-header {

            position: relative;

            overflow: hidden;

            padding: 25px 28px;

            border-radius: 20px;

            color: white;

            background:
                linear-gradient(
                    120deg,
                    #071b3a,
                    #0b315f 60%,
                    #0876b5
                );

            box-shadow:
                0 15px 35px rgba(10,42,78,.15);

            margin-bottom: 20px;

            animation: entrada .4s ease;
        }


        .schedule-header h1 {

            margin: 5px 0;

            font-size: 30px;
        }


        .schedule-header p {

            margin: 0;

            color: #c7dff3;

            font-size: 13px;
        }


        .doctor-label {

            color: #65d3ff;

            font-size: 11px;

            font-weight: 800;

            letter-spacing: 1.5px;
        }


        .doctor-name {

            margin-top: 10px;

            display: inline-flex;

            align-items: center;

            gap: 8px;

            padding: 7px 12px;

            border-radius: 20px;

            background:
                rgba(255,255,255,.12);

            font-size: 12px;
        }


        .brain-icon {

            position: absolute;

            right: 35px;

            top: 10px;

            font-size: 95px;

            opacity: .15;

            animation: pulso 3s infinite;
        }


        /* ========================================
           MENSAJES
        ======================================== */

        .schedule-message {

            margin-bottom: 15px;

            padding: 13px 16px;

            border-radius: 12px;

            font-size: 13px;

            font-weight: 700;

            animation: entrada .3s ease;
        }


        .schedule-message.success {

            background: #e8f9ef;

            color: #187542;

            border:
                1px solid #c8eed8;
        }


        .schedule-message.error {

            background: #fff0f0;

            color: #b72d2d;

            border:
                1px solid #ffd1d1;
        }


        /* ========================================
           TARJETAS
        ======================================== */

        .schedule-card {

            background: white;

            border:
                1px solid #dce7f1;

            border-radius: 18px;

            padding: 21px;

            margin-bottom: 20px;

            box-shadow:
                0 9px 28px rgba(20,55,90,.06);

            animation: entrada .45s ease;
        }


        .card-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 20px;

            gap: 15px;
        }


        .card-title {

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .card-icon {

            width: 45px;

            height: 45px;

            display: grid;

            place-items: center;

            border-radius: 13px;

            background: #e8f4ff;

            font-size: 21px;
        }


        .card-title h2 {

            margin: 0;

            font-size: 19px;

            color: #102b49;
        }


        .card-title p {

            margin: 4px 0 0;

            font-size: 12px;

            color: #758ca3;
        }


        /* ========================================
           FORMULARIO
        ======================================== */

        .schedule-form {

            display: grid;

            grid-template-columns:
                1.2fr
                1fr
                1fr
                auto;

            gap: 13px;

            align-items: end;
        }


        .schedule-field label {

            display: block;

            margin-bottom: 7px;

            font-size: 12px;

            font-weight: 800;

            color: #294661;
        }


        .schedule-field select,
        .schedule-field input {

            width: 100%;

            height: 44px;

            padding: 0 12px;

            border:
                1px solid #cddce8;

            border-radius: 10px;

            background: #fbfdff;

            color: #183653;

            outline: none;

            transition: .2s;
        }


        .schedule-field select:focus,
        .schedule-field input:focus {

            border-color: #1687e7;

            box-shadow:
                0 0 0 4px rgba(22,135,231,.1);
        }


        /* ========================================
           BOTÓN
        ======================================== */

        .schedule-btn {

            height: 44px;

            padding: 0 20px;

            border: 0;

            border-radius: 10px;

            cursor: pointer;

            color: white;

            font-weight: 800;

            background:
                linear-gradient(
                    135deg,
                    #0875df,
                    #159ee9
                );

            box-shadow:
                0 7px 16px rgba(8,117,223,.2);

            transition: .2s;
        }


        .schedule-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 10px 20px rgba(8,117,223,.27);
        }


        /* ========================================
           CALENDARIO
        ======================================== */

        .calendar-wrapper {

            width: 100%;

            overflow-x: auto;

            border:
                1px solid #dce7f1;

            border-radius: 15px;
        }


        .calendar {

            width: 100%;

            min-width: 1100px;

            border-collapse: collapse;

            table-layout: fixed;

            background: white;
        }


        /* CABECERA */

        .calendar thead th {

            padding: 14px 8px;

            color: white;

            background: #143a5f;

            border-right:
                1px solid rgba(255,255,255,.12);

            font-size: 12px;
        }


        .calendar thead th:first-child {

            width: 75px;

            background: #0b2948;
        }


        .day-name {

            display: block;

            font-weight: 900;
        }


        .day-sub {

            display: block;

            margin-top: 3px;

            font-size: 9px;

            font-weight: 400;

            color: #b8d3e9;
        }


        /* CELDAS */

        .calendar td {

            height: 90px;

            padding: 7px;

            vertical-align: top;

            background: #fbfdff;

            border-right:
                1px solid #e3ebf2;

            border-bottom:
                1px solid #e3ebf2;

            transition: .2s;
        }


        .calendar td:hover {

            background: #f3f9fe;
        }


        /* HORA */

        .calendar .hour {

            text-align: center;

            vertical-align: middle;

            background:
                #f0f6fb !important;

            color: #58738d;

            font-size: 11px;

            font-weight: 800;
        }


        /* ========================================
           BLOQUE DE HORARIO
        ======================================== */

        .schedule-block {

            padding: 9px;

            margin-bottom: 5px;

            border-radius: 10px;

            cursor: pointer;

            background:
                linear-gradient(
                    135deg,
                    #e4f3ff,
                    #eef9ff
                );

            border-left:
                4px solid #1687e7;

            box-shadow:
                0 4px 12px rgba(20,105,180,.10);

            transition: .2s;

            animation: bloque .3s ease;
        }


        .schedule-block:hover {

            transform:
                translateY(-2px)
                scale(1.015);

            box-shadow:
                0 8px 18px rgba(20,105,180,.18);
        }


        .block-title {

            color: #0a5ca5;

            font-size: 11px;

            font-weight: 900;
        }


        .block-time {

            display: inline-block;

            margin-top: 6px;

            padding: 4px 7px;

            border-radius: 7px;

            background: white;

            color: #285b86;

            font-size: 10px;

            font-weight: 800;
        }


        /* ========================================
           ESTADO VACÍO
        ======================================== */

        .empty-calendar {

            padding: 15px;

            margin-bottom: 15px;

            text-align: center;

            background: #f7fbfe;

            border:
                1px dashed #bfd5e7;

            border-radius: 12px;

            color: #738ba1;

            font-size: 12px;
        }


        /* ========================================
           LEYENDA
        ======================================== */

        .calendar-legend {

            display: flex;

            align-items: center;

            gap: 7px;

            margin-top: 13px;

            color: #71879c;

            font-size: 11px;
        }


        .legend-dot {

            width: 9px;

            height: 9px;

            border-radius: 50%;

            background: #1687e7;
        }


        /* ========================================
           MODAL
        ======================================== */

        .schedule-modal {

            position: fixed;

            inset: 0;

            z-index: 9999;

            display: none;

            align-items: center;

            justify-content: center;

            padding: 20px;

            background:
                rgba(4,18,35,.55);

            backdrop-filter:
                blur(4px);
        }


        .schedule-modal.show {

            display: flex;
        }


        .modal-content {

            width: 100%;

            max-width: 420px;

            overflow: hidden;

            border-radius: 19px;

            background: white;

            box-shadow:
                0 25px 70px rgba(0,0,0,.25);

            animation: modalEntrada .25s ease;
        }


        .modal-header {

            position: relative;

            padding: 22px;

            color: white;

            background:
                linear-gradient(
                    135deg,
                    #08294c,
                    #0871b6
                );
        }


        .modal-header h2 {

            margin: 0 0 5px;

            font-size: 21px;
        }


        .modal-header p {

            margin: 0;

            color: #cce5f8;

            font-size: 12px;
        }


        .modal-close {

            position: absolute;

            right: 15px;

            top: 14px;

            width: 34px;

            height: 34px;

            border: 0;

            border-radius: 50%;

            color: white;

            background:
                rgba(255,255,255,.15);

            font-size: 20px;

            cursor: pointer;
        }


        .modal-body {

            padding: 21px;
        }


        .detail-row {

            display: flex;

            justify-content: space-between;

            gap: 20px;

            padding: 12px 0;

            border-bottom:
                1px solid #edf2f7;

            font-size: 13px;
        }


        .detail-row span {

            color: #73899e;
        }


        .detail-row strong {

            color: #193b5a;

            text-align: right;
        }


        /* ========================================
           ELIMINAR
        ======================================== */

        .delete-form {

            margin-top: 20px;
        }


        .delete-btn {

            width: 100%;

            height: 43px;

            border: 0;

            border-radius: 10px;

            background: #ffe7e7;

            color: #bd2929;

            font-weight: 800;

            cursor: pointer;

            transition: .2s;
        }


        .delete-btn:hover {

            background: #ffd8d8;

            transform: translateY(-1px);
        }


        /* ========================================
           ANIMACIONES
        ======================================== */

        @keyframes entrada {

            from {
                opacity: 0;
                transform: translateY(8px);
            }

            to {
                opacity: 1;
                transform: none;
            }
        }


        @keyframes bloque {

            from {
                opacity: 0;
                transform: scale(.95);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }


        @keyframes modalEntrada {

            from {
                opacity: 0;
                transform: scale(.93);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }


        @keyframes pulso {

            50% {
                transform: scale(1.07);
            }
        }


        /* ========================================
           RESPONSIVE
        ======================================== */

        @media(max-width:900px) {

            .schedule-form {

                grid-template-columns:
                    1fr
                    1fr;
            }
        }


        @media(max-width:600px) {

            .schedule-form {

                grid-template-columns:
                    1fr;
            }

            .brain-icon {

                display: none;
            }

            .schedule-header h1 {

                font-size: 25px;
            }
        }

    </style>

</head>


<body>


<div class="page">


<div class="schedule-page">


    <!-- ======================================= -->
    <!-- ENCABEZADO -->
    <!-- ======================================= -->

    <div class="schedule-header">


        <div class="doctor-label">

            NEUROCITAS · PORTAL MÉDICO

        </div>


        <h1>

            Mi horario de atención

        </h1>


        <p>

            Organiza tu disponibilidad semanal para
            la atención de pacientes.

        </p>


        <div class="doctor-name">

            🩺 Dr(a).
            <%= actual.getNombre() %>
            <%= actual.getApellido() %>

            <% if (actual.getEspecialidad() != null &&
                   !actual.getEspecialidad().trim().isEmpty()) { %>

                · <%= actual.getEspecialidad() %>

            <% } %>

        </div>


        <div class="brain-icon">

            🧠

        </div>


    </div>



    <!-- ======================================= -->
    <!-- MENSAJES -->
    <!-- ======================================= -->


    <% if ("agregado".equals(ok)) { %>

        <div class="schedule-message success">

            ✓ Horario agregado correctamente.

        </div>

    <% } else if ("eliminado".equals(ok)) { %>

        <div class="schedule-message success">

            ✓ Horario eliminado correctamente.

        </div>

    <% } %>



    <% if ("campos".equals(error)) { %>

        <div class="schedule-message error">

            ⚠ Completa todos los campos del horario.

        </div>

    <% } else if ("hora".equals(error)) { %>

        <div class="schedule-message error">

            ⚠ La hora de inicio debe ser menor
            que la hora de fin.

        </div>

    <% } else if ("cruce".equals(error)) { %>

        <div class="schedule-message error">

            ⚠ Ya tienes un horario registrado
            que se cruza con esa hora.

        </div>

    <% } else if ("guardar".equals(error)) { %>

        <div class="schedule-message error">

            ⚠ No se pudo guardar el horario.

        </div>

    <% } else if ("eliminar".equals(error)) { %>

        <div class="schedule-message error">

            ⚠ No se pudo eliminar el horario.

        </div>

    <% } %>



    <!-- ======================================= -->
    <!-- CREAR HORARIO -->
    <!-- ======================================= -->

    <div class="schedule-card">


        <div class="card-header">


            <div class="card-title">


                <div class="card-icon">

                    ➕

                </div>


                <div>

                    <h2>

                        Crear nuevo horario

                    </h2>


                    <p>

                        Define cuándo estarás disponible
                        para atender pacientes.

                    </p>

                </div>


            </div>


        </div>



        <form
            action="ControladorMisHorarios"
            method="post"
        >


            <input
                type="hidden"
                name="accion"
                value="agregar"
            >


            <div class="schedule-form">


                <!-- DÍA -->

                <div class="schedule-field">


                    <label>

                        Día de atención

                    </label>


                    <select
                        name="diaSemana"
                        required
                    >


                        <option value="">

                            Seleccione un día

                        </option>


                        <option value="Lunes">
                            Lunes
                        </option>

                        <option value="Martes">
                            Martes
                        </option>

                        <option value="Miércoles">
                            Miércoles
                        </option>

                        <option value="Jueves">
                            Jueves
                        </option>

                        <option value="Viernes">
                            Viernes
                        </option>

                        <option value="Sábado">
                            Sábado
                        </option>

                        <option value="Domingo">
                            Domingo
                        </option>


                    </select>


                </div>



                <!-- HORA INICIO -->

                <div class="schedule-field">


                    <label>

                        Hora de inicio

                    </label>


                    <input
                        type="time"
                        name="horaInicio"
                        required
                    >


                </div>



                <!-- HORA FIN -->

                <div class="schedule-field">


                    <label>

                        Hora de fin

                    </label>


                    <input
                        type="time"
                        name="horaFin"
                        required
                    >


                </div>



                <!-- BOTÓN -->

                <button
                    type="submit"
                    class="schedule-btn"
                >

                    ＋ Guardar horario

                </button>


            </div>


        </form>


    </div>



    <!-- ======================================= -->
    <!-- CALENDARIO -->
    <!-- ======================================= -->

    <div class="schedule-card">


        <div class="card-header">


            <div class="card-title">


                <div class="card-icon">

                    📅

                </div>


                <div>


                    <h2>

                        Mi calendario semanal

                    </h2>


                    <p>

                        Consulta visualmente tus horarios
                        de atención registrados.

                    </p>


                </div>


            </div>


        </div>



        <% if (lista == null || lista.isEmpty()) { %>


            <div class="empty-calendar">

                📭 Todavía no tienes horarios registrados.
                Crea tu primer horario utilizando el
                formulario de arriba.

            </div>


        <% } %>



        <div class="calendar-wrapper">


            <table class="calendar">


                <!-- CABECERA -->

                <thead>


                    <tr>


                        <th>

                            HORA

                        </th>


                        <% for (String dia : dias) { %>


                            <th>


                                <span class="day-name">

                                    <%= dia.toUpperCase() %>

                                </span>


                                <span class="day-sub">

                                    Atención

                                </span>


                            </th>


                        <% } %>


                    </tr>


                </thead>



                <!-- CUERPO -->

                <tbody>


                <%

                    /*
                     * Calendario desde las
                     * 06:00 hasta las 21:00
                     */

                    for (int hora = 6; hora <= 21; hora++) {

                %>


                    <tr>


                        <!-- HORA -->

                        <td class="hour">

                            <%= String.format("%02d:00", hora) %>

                        </td>



                        <%

                            /*
                             * Recorremos cada día
                             */

                            for (String dia : dias) {

                        %>


                            <td>


                            <%

                                if (lista != null) {

                                    for (Horario h : lista) {


                                        /*
                                         * Verificamos que el horario
                                         * corresponda al día.
                                         */

                                        if (
                                            h.getDiaSemana() == null
                                            ||
                                            !h.getDiaSemana()
                                              .equalsIgnoreCase(dia)
                                        ) {

                                            continue;
                                        }


                                        /*
                                         * Convertimos la hora
                                         * de inicio a texto.
                                         */

                                        String inicio =
                                            String.valueOf(
                                                h.getHoraInicio()
                                            );


                                        String fin =
                                            String.valueOf(
                                                h.getHoraFin()
                                            );


                                        /*
                                         * Sacamos solamente
                                         * la hora.
                                         */

                                        int horaInicio = -1;


                                        try {


                                            String[] partes =
                                                inicio.split(":");


                                            horaInicio =
                                                Integer.parseInt(
                                                    partes[0]
                                                );


                                        } catch(Exception e) {


                                            horaInicio = -1;

                                        }


                                        /*
                                         * Solo mostramos el bloque
                                         * en la fila correspondiente
                                         * a la hora de inicio.
                                         */

                                        if (horaInicio != hora) {

                                            continue;
                                        }

                            %>



                                <!-- ============================ -->
                                <!-- BLOQUE DEL HORARIO -->
                                <!-- ============================ -->

                                <div
                                    class="schedule-block"

                                    data-id="<%= h.getIdHorario() %>"

                                    data-dia="<%= h.getDiaSemana() %>"

                                    data-inicio="<%= inicio %>"

                                    data-fin="<%= fin %>"

                                    onclick="abrirHorario(this)"
                                >


                                    <div class="block-title">

                                        🩺 Disponible

                                    </div>


                                    <div class="block-time">

                                        🕘
                                        <%= inicio %>
                                        -
                                        <%= fin %>

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



        <div class="calendar-legend">

            <span class="legend-dot"></span>

            Haz clic sobre un horario para consultar
            sus detalles.

        </div>


    </div>


</div>


</div>



<!-- ======================================= -->
<!-- MODAL -->
<!-- ======================================= -->

<div
    class="schedule-modal"
    id="modalHorario"
    onclick="cerrarFondo(event)"
>


    <div class="modal-content">


        <!-- CABECERA -->

        <div class="modal-header">


            <button
                type="button"
                class="modal-close"
                onclick="cerrarModal()"
            >

                ×

            </button>


            <h2>

                🧠 Horario de atención

            </h2>


            <p>

                Dr(a).
                <%= actual.getNombre() %>
                <%= actual.getApellido() %>

            </p>


        </div>



        <!-- CONTENIDO -->

        <div class="modal-body">


            <div class="detail-row">


                <span>

                    📅 Día

                </span>


                <strong id="modalDia">

                </strong>


            </div>



            <div class="detail-row">


                <span>

                    🕘 Hora de inicio

                </span>


                <strong id="modalInicio">

                </strong>


            </div>



            <div class="detail-row">


                <span>

                    🕐 Hora de fin

                </span>


                <strong id="modalFin">

                </strong>


            </div>



            <div class="detail-row">


                <span>

                    Estado

                </span>


                <strong>

                    🟢 Disponible

                </strong>


            </div>



            <!-- ELIMINAR -->

            <form
                action="ControladorMisHorarios"
                method="post"
                class="delete-form"

                onsubmit="
                    return confirm(
                        '¿Seguro que deseas eliminar este horario?'
                    );
                "
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


                <button
                    type="submit"
                    class="delete-btn"
                >

                    🗑 Eliminar horario

                </button>


            </form>


        </div>


    </div>


</div>



<script>


/* ========================================
   ABRIR HORARIO
======================================== */

function abrirHorario(elemento) {


    var id =
        elemento.getAttribute(
            "data-id"
        );


    var dia =
        elemento.getAttribute(
            "data-dia"
        );


    var inicio =
        elemento.getAttribute(
            "data-inicio"
        );


    var fin =
        elemento.getAttribute(
            "data-fin"
        );



    document.getElementById(
        "modalIdHorario"
    ).value = id;



    document.getElementById(
        "modalDia"
    ).textContent = dia;



    document.getElementById(
        "modalInicio"
    ).textContent = inicio;



    document.getElementById(
        "modalFin"
    ).textContent = fin;



    document.getElementById(
        "modalHorario"
    ).classList.add(
        "show"
    );

}



/* ========================================
   CERRAR MODAL
======================================== */

function cerrarModal() {


    document.getElementById(
        "modalHorario"
    ).classList.remove(
        "show"
    );

}



/* ========================================
   CERRAR AL TOCAR EL FONDO
======================================== */

function cerrarFondo(event) {


    if (
        event.target.id ===
        "modalHorario"
    ) {


        cerrarModal();

    }

}



/* ========================================
   CERRAR CON ESC
======================================== */

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