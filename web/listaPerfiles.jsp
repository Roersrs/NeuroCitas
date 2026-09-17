<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

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

    UsuarioDAO usuarioDAO = new UsuarioDAO();

    List<Usuario> todos = usuarioDAO.listadoTodosLosUsuarios();

    List<Usuario> administradores = new ArrayList<Usuario>();
    List<Usuario> neurologos = new ArrayList<Usuario>();
    List<Usuario> pacientes = new ArrayList<Usuario>();

    if (todos != null) {

        for (Usuario u : todos) {

            if (u.getIdestado() == 1) {

                if (u.getIdperfil() == 1) {

                    administradores.add(u);

                } else if (u.getIdperfil() == 2) {

                    neurologos.add(u);

                } else if (u.getIdperfil() == 3) {

                    pacientes.add(u);
                }
            }
        }
    }
%>

<!DOCTYPE html>

<html lang="es">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Perfiles | NeuroCitas</title>

<link rel="stylesheet" href="css/estilos.css">

<style>

    /* =====================================
       CONTENEDOR
    ===================================== */

    .profiles-container {
        padding: 5px;
    }


    /* =====================================
       ENCABEZADO
    ===================================== */

    .profiles-header {
        margin-bottom: 25px;
    }

    .profiles-header h1 {
        margin: 0 0 7px;
        color: #10233f;
        font-size: 30px;
    }

    .profiles-header p {
        margin: 0;
        color: #71859b;
        font-size: 14px;
    }


    /* =====================================
       BOTONES DE PERFILES
    ===================================== */

    .profile-tabs {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
        margin-bottom: 24px;
    }

    .profile-tab {
        position: relative;

        display: flex;
        align-items: center;
        gap: 14px;

        padding: 18px;

        border: 1px solid #dce7f1;
        border-radius: 16px;

        background: white;
        color: #173653;

        cursor: pointer;

        text-align: left;

        transition: .25s;

        box-shadow:
            0 7px 20px rgba(20, 55, 90, .06);
    }

    .profile-tab:hover {
        transform: translateY(-3px);

        box-shadow:
            0 12px 25px rgba(20, 55, 90, .12);

        border-color: #8fc8f4;
    }

    .profile-tab.active {
        color: white;

        border-color: #0879dc;

        background:
            linear-gradient(
                135deg,
                #0757a6,
                #1598e4
            );

        box-shadow:
            0 12px 25px rgba(8, 117, 223, .22);
    }


    /* =====================================
       ICONOS
    ===================================== */

    .tab-icon {
        width: 48px;
        height: 48px;

        flex-shrink: 0;

        display: grid;
        place-items: center;

        border-radius: 13px;

        background: #e9f4ff;

        font-size: 23px;

        transition: .25s;
    }

    .profile-tab.active .tab-icon {
        background: rgba(255,255,255,.18);
    }


    /* =====================================
       INFORMACIÓN DEL BOTÓN
    ===================================== */

    .tab-info {
        flex: 1;
    }

    .tab-title {
        display: block;

        font-size: 15px;
        font-weight: 800;

        margin-bottom: 4px;
    }

    .tab-count {
        font-size: 12px;
        color: #758ba2;
    }

    .profile-tab.active .tab-count {
        color: #d7edff;
    }

    .number {
        font-weight: 900;
    }


    /* =====================================
       PANEL
    ===================================== */

    .profile-panel {
        display: none;

        background: white;

        border: 1px solid #dce7f1;
        border-radius: 18px;

        padding: 22px;

        box-shadow:
            0 10px 30px rgba(20,55,90,.07);

        animation: aparecer .3s ease;
    }

    .profile-panel.active {
        display: block;
    }


    /* =====================================
       ENCABEZADO DE TABLA
    ===================================== */

    .panel-header {
        display: flex;

        align-items: center;
        justify-content: space-between;

        gap: 20px;

        margin-bottom: 20px;
    }

    .panel-title h2 {
        margin: 0 0 4px;
        color: #10233f;
        font-size: 21px;
    }

    .panel-title p {
        margin: 0;
        color: #7890a7;
        font-size: 12px;
    }


    /* =====================================
       BUSCADOR
    ===================================== */

    .search-box {
        position: relative;

        width: 390px;
        max-width: 100%;
    }

    .search-icon {
        position: absolute;

        left: 14px;
        top: 50%;

        transform: translateY(-50%);

        pointer-events: none;
    }

    .search-input {
        width: 100%;
        height: 45px;

        padding:
            0 15px
            0 42px;

        border:
            1px solid #cedce9;

        border-radius: 12px;

        background: #fbfdff;

        color: #173653;

        outline: none;

        transition: .2s;
    }

    .search-input:focus {
        border-color: #1687e7;

        box-shadow:
            0 0 0 4px rgba(22,135,231,.1);
    }


    /* =====================================
       TABLA
    ===================================== */

    .table-container {
        overflow-x: auto;

        border:
            1px solid #e1eaf2;

        border-radius: 14px;
    }

    .users-table {
        width: 100%;

        min-width: 800px;

        border-collapse: collapse;

        background: white;
    }

    .users-table thead {
        background: #173b60;
        color: white;
    }

    .users-table th {
        padding: 14px 15px;

        text-align: left;

        font-size: 12px;
        font-weight: 800;
    }

    .users-table td {
        padding: 14px 15px;

        border-bottom:
            1px solid #edf2f6;

        color: #253f5a;

        font-size: 13px;
    }

    .users-table tbody tr {
        transition: .18s;
    }

    .users-table tbody tr:hover {
        background: #f2f8fe;
    }


    /* =====================================
       IDENTIFICACIÓN
    ===================================== */

    .identificacion {
        font-weight: 800;
        color: #0b65b3;
    }


    /* =====================================
       NOMBRE
    ===================================== */

    .nombre-usuario {
        font-weight: 700;
        color: #183653;
    }


    /* =====================================
       ESPECIALIDAD
    ===================================== */

    .specialty {
        display: inline-block;

        padding: 5px 9px;

        border-radius: 20px;

        background: #e9f4ff;

        color: #0869bd;

        font-size: 11px;

        font-weight: 700;
    }


    /* =====================================
       PARTE INFERIOR
    ===================================== */

    .table-footer {
        display: flex;

        justify-content: space-between;
        align-items: center;

        gap: 15px;

        margin-top: 17px;
    }

    .results-info {
        color: #75899e;
        font-size: 12px;
    }


    /* =====================================
       PAGINACIÓN
    ===================================== */

    .pagination {
        display: flex;
        align-items: center;
        gap: 9px;
    }

    .page-button {
        height: 36px;

        border:
            1px solid #cfdeea;

        border-radius: 9px;

        padding: 0 14px;

        background: white;

        color: #164a76;

        font-weight: 700;

        cursor: pointer;

        transition: .2s;
    }

    .page-button:hover:not(:disabled) {
        color: white;

        border-color: #1687e7;

        background: #1687e7;
    }

    .page-button:disabled {
        opacity: .4;
        cursor: not-allowed;
    }

    .page-number {
        padding: 0 7px;

        font-size: 12px;
        font-weight: 700;

        color: #59728b;
    }


    /* =====================================
       SIN RESULTADOS
    ===================================== */

    .no-results {
        display: none;

        padding: 35px;

        text-align: center;

        color: #7c90a4;
    }

    .no-results-icon {
        font-size: 35px;
        margin-bottom: 8px;
    }


    /* =====================================
       ANIMACIÓN
    ===================================== */

    @keyframes aparecer {

        from {
            opacity: 0;
            transform: translateY(7px);
        }

        to {
            opacity: 1;
            transform: none;
        }
    }


    /* =====================================
       RESPONSIVE
    ===================================== */

    @media(max-width:850px) {

        .profile-tabs {
            grid-template-columns: 1fr;
        }

        .panel-header {
            flex-direction: column;
            align-items: stretch;
        }

        .search-box {
            width: 100%;
        }
    }

    @media(max-width:600px) {

        .profile-panel {
            padding: 14px;
        }

        .table-footer {
            flex-direction: column;
        }
    }

</style>

</head>


<body>


<div class="page">


    <div class="profiles-container">


        <!-- ================================= -->
        <!-- ENCABEZADO -->
        <!-- ================================= -->

        <div class="profiles-header">

            <h1>
                Perfiles del Sistema
            </h1>

            <p>
                Consulta los usuarios activos registrados en NeuroCitas.
            </p>

        </div>



        <!-- ================================= -->
        <!-- BOTONES -->
        <!-- ================================= -->

        <div class="profile-tabs">


            <!-- ADMINISTRADORES -->

            <button
                type="button"
                class="profile-tab active"
                onclick="mostrarPerfil('administradores', this)"
            >

                <div class="tab-icon">
                    🛡️
                </div>

                <div class="tab-info">

                    <span class="tab-title">
                        Administradores
                    </span>

                    <span class="tab-count">

                        <span class="number">
                            <%= administradores.size() %>
                        </span>

                        registrados

                    </span>

                </div>

            </button>



            <!-- NEURÓLOGOS -->

            <button
                type="button"
                class="profile-tab"
                onclick="mostrarPerfil('neurologos', this)"
            >

                <div class="tab-icon">
                    🧠
                </div>

                <div class="tab-info">

                    <span class="tab-title">
                        Neurólogos
                    </span>

                    <span class="tab-count">

                        <span class="number">
                            <%= neurologos.size() %>
                        </span>

                        registrados

                    </span>

                </div>

            </button>



            <!-- PACIENTES -->

            <button
                type="button"
                class="profile-tab"
                onclick="mostrarPerfil('pacientes', this)"
            >

                <div class="tab-icon">
                    👤
                </div>

                <div class="tab-info">

                    <span class="tab-title">
                        Pacientes
                    </span>

                    <span class="tab-count">

                        <span class="number">
                            <%= pacientes.size() %>
                        </span>

                        registrados

                    </span>

                </div>

            </button>


        </div>



        <!-- ================================================= -->
        <!-- ADMINISTRADORES -->
        <!-- ================================================= -->

        <div
            class="profile-panel active"
            id="administradores"
        >


            <div class="panel-header">


                <div class="panel-title">

                    <h2>
                        🛡️ Administradores
                    </h2>

                    <p>
                        Administradores activos del sistema.
                    </p>

                </div>


                <div class="search-box">

                    <span class="search-icon">
                        🔎
                    </span>

                    <input
                        type="search"
                        class="search-input"
                        id="buscar-administradores"
                        placeholder="Buscar identificación, nombre, correo..."
                        oninput="buscar('administradores')"
                    >

                </div>


            </div>



            <div class="table-container">


                <table
                    class="users-table"
                    id="tabla-administradores"
                >


                    <thead>

                        <tr>

                            <th>
                                Identificación
                            </th>

                            <th>
                                Nombre
                            </th>

                            <th>
                                Usuario
                            </th>

                            <th>
                                Correo
                            </th>

                            <th>
                                Teléfono
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <% for (Usuario u : administradores) { %>


                        <tr>

                            <td class="identificacion">

                                <%= u.getIdentificacion() %>

                            </td>


                            <td class="nombre-usuario">

                                <%= u.getNombre() %>
                                <%= u.getApellido() %>

                            </td>


                            <td>

                                <%= u.getUsuario() %>

                            </td>


                            <td>

                                <%= u.getEmail() %>

                            </td>


                            <td>

                                <%= u.getTelefono() %>

                            </td>

                        </tr>


                    <% } %>


                    </tbody>


                </table>


                <div
                    class="no-results"
                    id="vacio-administradores"
                >

                    <div class="no-results-icon">
                        🔍
                    </div>

                    No se encontraron administradores.

                </div>


            </div>



            <div class="table-footer">

                <div
                    class="results-info"
                    id="info-administradores"
                >
                </div>


                <div class="pagination">

                    <button
                        type="button"
                        class="page-button"
                        id="anterior-administradores"
                        onclick="cambiarPagina('administradores', -1)"
                    >
                        ← Anterior
                    </button>


                    <span
                        class="page-number"
                        id="pagina-administradores"
                    >
                    </span>


                    <button
                        type="button"
                        class="page-button"
                        id="siguiente-administradores"
                        onclick="cambiarPagina('administradores', 1)"
                    >
                        Siguiente →
                    </button>

                </div>

            </div>


        </div>



        <!-- ================================================= -->
        <!-- NEURÓLOGOS -->
        <!-- ================================================= -->

        <div
            class="profile-panel"
            id="neurologos"
        >


            <div class="panel-header">


                <div class="panel-title">

                    <h2>
                        🧠 Neurólogos
                    </h2>

                    <p>
                        Especialistas activos registrados.
                    </p>

                </div>


                <div class="search-box">

                    <span class="search-icon">
                        🔎
                    </span>

                    <input
                        type="search"
                        class="search-input"
                        id="buscar-neurologos"
                        placeholder="Buscar identificación, nombre, especialidad..."
                        oninput="buscar('neurologos')"
                    >

                </div>


            </div>



            <div class="table-container">


                <table
                    class="users-table"
                    id="tabla-neurologos"
                >


                    <thead>

                        <tr>

                            <th>
                                Identificación
                            </th>

                            <th>
                                Nombre
                            </th>

                            <th>
                                Especialidad
                            </th>

                            <th>
                                Correo
                            </th>

                            <th>
                                Teléfono
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <% for (Usuario u : neurologos) { %>


                        <tr>

                            <td class="identificacion">

                                <%= u.getIdentificacion() %>

                            </td>


                            <td class="nombre-usuario">

                                Dr(a).
                                <%= u.getNombre() %>
                                <%= u.getApellido() %>

                            </td>


                            <td>

                                <span class="specialty">

                                    <%= (u.getEspecialidad() != null
                                            && !u.getEspecialidad().trim().isEmpty())
                                            ? u.getEspecialidad()
                                            : "Neurología"
                                    %>

                                </span>

                            </td>


                            <td>

                                <%= u.getEmail() %>

                            </td>


                            <td>

                                <%= u.getTelefono() %>

                            </td>

                        </tr>


                    <% } %>


                    </tbody>


                </table>


                <div
                    class="no-results"
                    id="vacio-neurologos"
                >

                    <div class="no-results-icon">
                        🔍
                    </div>

                    No se encontraron neurólogos.

                </div>


            </div>



            <div class="table-footer">

                <div
                    class="results-info"
                    id="info-neurologos"
                >
                </div>


                <div class="pagination">


                    <button
                        type="button"
                        class="page-button"
                        id="anterior-neurologos"
                        onclick="cambiarPagina('neurologos', -1)"
                    >
                        ← Anterior
                    </button>


                    <span
                        class="page-number"
                        id="pagina-neurologos"
                    >
                    </span>


                    <button
                        type="button"
                        class="page-button"
                        id="siguiente-neurologos"
                        onclick="cambiarPagina('neurologos', 1)"
                    >
                        Siguiente →
                    </button>


                </div>

            </div>


        </div>



        <!-- ================================================= -->
        <!-- PACIENTES -->
        <!-- ================================================= -->

        <div
            class="profile-panel"
            id="pacientes"
        >


            <div class="panel-header">


                <div class="panel-title">

                    <h2>
                        👤 Pacientes
                    </h2>

                    <p>
                        Pacientes activos registrados en NeuroCitas.
                    </p>

                </div>


                <div class="search-box">

                    <span class="search-icon">
                        🔎
                    </span>

                    <input
                        type="search"
                        class="search-input"
                        id="buscar-pacientes"
                        placeholder="Buscar identificación, nombre, correo..."
                        oninput="buscar('pacientes')"
                    >

                </div>


            </div>



            <div class="table-container">


                <table
                    class="users-table"
                    id="tabla-pacientes"
                >


                    <thead>

                        <tr>

                            <th>
                                Identificación
                            </th>

                            <th>
                                Nombre
                            </th>

                            <th>
                                Usuario
                            </th>

                            <th>
                                Correo
                            </th>

                            <th>
                                Teléfono
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <% for (Usuario u : pacientes) { %>


                        <tr>

                            <td class="identificacion">

                                <%= u.getIdentificacion() %>

                            </td>


                            <td class="nombre-usuario">

                                <%= u.getNombre() %>
                                <%= u.getApellido() %>

                            </td>


                            <td>

                                <%= u.getUsuario() %>

                            </td>


                            <td>

                                <%= u.getEmail() %>

                            </td>


                            <td>

                                <%= u.getTelefono() %>

                            </td>

                        </tr>


                    <% } %>


                    </tbody>


                </table>


                <div
                    class="no-results"
                    id="vacio-pacientes"
                >

                    <div class="no-results-icon">
                        🔍
                    </div>

                    No se encontraron pacientes.

                </div>


            </div>



            <div class="table-footer">


                <div
                    class="results-info"
                    id="info-pacientes"
                >
                </div>


                <div class="pagination">


                    <button
                        type="button"
                        class="page-button"
                        id="anterior-pacientes"
                        onclick="cambiarPagina('pacientes', -1)"
                    >
                        ← Anterior
                    </button>


                    <span
                        class="page-number"
                        id="pagina-pacientes"
                    >
                    </span>


                    <button
                        type="button"
                        class="page-button"
                        id="siguiente-pacientes"
                        onclick="cambiarPagina('pacientes', 1)"
                    >
                        Siguiente →
                    </button>


                </div>


            </div>


        </div>


    </div>

</div>



<script>

/* ==========================================
   CONFIGURACIÓN
========================================== */

var cantidadPorPagina = 10;


var estado = {

    administradores: {
        pagina: 1
    },

    neurologos: {
        pagina: 1
    },

    pacientes: {
        pagina: 1
    }

};



/* ==========================================
   CAMBIAR ENTRE PERFILES
========================================== */

function mostrarPerfil(tipo, boton) {

    var paneles =
        document.querySelectorAll(
            ".profile-panel"
        );


    paneles.forEach(function(panel) {

        panel.classList.remove(
            "active"
        );

    });


    var botones =
        document.querySelectorAll(
            ".profile-tab"
        );


    botones.forEach(function(btn) {

        btn.classList.remove(
            "active"
        );

    });


    document.getElementById(
        tipo
    ).classList.add(
        "active"
    );


    boton.classList.add(
        "active"
    );


    actualizarTabla(tipo);
}



/* ==========================================
   BUSCAR
========================================== */

function buscar(tipo) {

    estado[tipo].pagina = 1;

    actualizarTabla(tipo);
}



/* ==========================================
   OBTENER FILAS FILTRADAS
========================================== */

function obtenerFilasFiltradas(tipo) {

    var tabla =
        document.getElementById(
            "tabla-" + tipo
        );


    var filas =
        Array.from(
            tabla.querySelectorAll(
                "tbody tr"
            )
        );


    var buscador =
        document.getElementById(
            "buscar-" + tipo
        );


    var texto =
        buscador.value
            .toLowerCase()
            .trim();


    if (texto === "") {

        return filas;
    }


    return filas.filter(
        function(fila) {

            return fila.innerText
                .toLowerCase()
                .includes(texto);
        }
    );
}



/* ==========================================
   ACTUALIZAR TABLA
========================================== */

function actualizarTabla(tipo) {

    var tabla =
        document.getElementById(
            "tabla-" + tipo
        );


    var todasLasFilas =
        Array.from(
            tabla.querySelectorAll(
                "tbody tr"
            )
        );


    var filtradas =
        obtenerFilasFiltradas(tipo);


    var total =
        filtradas.length;


    var totalPaginas =
        Math.ceil(
            total /
            cantidadPorPagina
        );


    if (totalPaginas < 1) {

        totalPaginas = 1;
    }


    if (
        estado[tipo].pagina >
        totalPaginas
    ) {

        estado[tipo].pagina =
            totalPaginas;
    }


    var inicio =
        (
            estado[tipo].pagina - 1
        )
        *
        cantidadPorPagina;


    var fin =
        inicio +
        cantidadPorPagina;



    /* Ocultar todas */

    todasLasFilas.forEach(
        function(fila) {

            fila.style.display =
                "none";
        }
    );



    /* Mostrar página */

    filtradas
        .slice(inicio, fin)
        .forEach(
            function(fila) {

                fila.style.display =
                    "";
            }
        );



    /* Sin resultados */

    var vacio =
        document.getElementById(
            "vacio-" + tipo
        );


    if (total === 0) {

        vacio.style.display =
            "block";

    } else {

        vacio.style.display =
            "none";
    }



    /* Información */

    var info =
        document.getElementById(
            "info-" + tipo
        );


    if (total === 0) {

        info.textContent =
            "0 resultados";

    } else {

        var desde =
            inicio + 1;


        var hasta =
            Math.min(
                fin,
                total
            );


        info.textContent =
            "Mostrando "
            + desde
            + " - "
            + hasta
            + " de "
            + total
            + " usuarios";
    }



    /* Página */

    document.getElementById(
        "pagina-" + tipo
    ).textContent =
        "Página "
        + estado[tipo].pagina
        + " de "
        + totalPaginas;



    /* Botones */

    document.getElementById(
        "anterior-" + tipo
    ).disabled =
        estado[tipo].pagina <= 1;


    document.getElementById(
        "siguiente-" + tipo
    ).disabled =
        estado[tipo].pagina >=
        totalPaginas;
}



/* ==========================================
   CAMBIAR PÁGINA
========================================== */

function cambiarPagina(tipo, cambio) {

    estado[tipo].pagina += cambio;

    if (estado[tipo].pagina < 1) {

        estado[tipo].pagina = 1;
    }


    actualizarTabla(tipo);
}



/* ==========================================
   INICIALIZAR
========================================== */

document.addEventListener(
    "DOMContentLoaded",
    function() {

        actualizarTabla(
            "administradores"
        );

        actualizarTabla(
            "neurologos"
        );

        actualizarTabla(
            "pacientes"
        );

    }
);

</script>


</body>

</html>