<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario, modelo.HistoriaClinica, modelo.HistoriaClinicaDAO"%>
<%
    Usuario sesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (sesion == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    HistoriaClinica h = null;
    if (idParam != null) {
        try {
            h = new HistoriaClinicaDAO().obtenerPorId(Integer.parseInt(idParam));
        } catch (NumberFormatException e) { h = null; }
    }

    // Control de acceso:
    // Paciente solo ve sus propias historias (perfil 3)
    // Neurologo solo ve historias que el creo (perfil 2)
    // Admin ve cualquiera (perfil 1)
    if (h == null) {
        response.sendRedirect("front.jsp");
        return;
    }
    int rol = sesion.getIdperfil();
    if (rol == 3 && !h.getIdentificacionPaciente().equals(sesion.getIdentificacion())) {
        response.sendRedirect("front.jsp");
        return;
    }
    if (rol == 2 && !h.getIdentificacionNeurologo().equals(sesion.getIdentificacion())) {
        response.sendRedirect("front.jsp");
        return;
    }

    String origen = request.getParameter("origen");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/estilos.css">
    <title>NeuroCitas - Detalle Historia Clinica</title>
    <style>
        .hc-header { background: var(--primary); color: #fff; border-radius: 18px 18px 0 0; padding: 22px 28px; }
        .hc-header h2 { margin: 0 0 4px; font-size: 22px; }
        .hc-header p  { margin: 0; opacity: .85; font-size: 14px; }
        .hc-body { padding: 28px; }
        .hc-section { margin-bottom: 24px; border-bottom: 1px solid var(--line); padding-bottom: 20px; }
        .hc-section:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .hc-section h4 { margin: 0 0 10px; color: var(--primary); font-size: 13px; text-transform: uppercase; letter-spacing: .07em; }
        .hc-section p  { margin: 0; line-height: 1.7; color: var(--text); font-size: 15px; white-space: pre-wrap; }
        .hc-section p.vacio { color: var(--muted); font-style: italic; }
        .hc-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0 28px; }
        @media(max-width:700px){ .hc-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="page">
    <div style="margin-bottom:16px;">
        <% if ("admin".equals(origen)) { %>
            <a class="btn secondary" href="buscarHistoria.jsp" style="padding:8px 16px;font-size:13px;">Volver a la busqueda</a>
        <% } else if (rol == 2) { %>
            <a class="btn secondary" href="historiaNeurologo.jsp" style="padding:8px 16px;font-size:13px;">Volver a mis historias</a>
        <% } else { %>
            <a class="btn secondary" href="miHistoriaClinica.jsp" style="padding:8px 16px;font-size:13px;">Volver a mis historias</a>
        <% } %>
    </div>

    <div class="card" style="padding:0;overflow:hidden;">
        <div class="hc-header">
            <h2>Historia Clinica Neurologica</h2>
            <p>Fecha de registro: <%= h.getFechaRegistro() %> &nbsp;|&nbsp; No. <%= h.getIdHistoria() %></p>
        </div>
        <div class="hc-body">

            <div class="hc-grid">
                <div class="hc-section">
                    <h4>Paciente</h4>
                    <p><strong><%= h.getNombrePaciente() %></strong><br>
                    C.C. <%= h.getIdentificacionPaciente() %></p>
                </div>
                <div class="hc-section">
                    <h4>Neurologo tratante</h4>
                    <p><strong>Dr(a). <%= h.getNombreNeurologo() %></strong></p>
                </div>
            </div>

            <div class="hc-section">
                <h4>Motivo de consulta</h4>
                <p><%= h.getMotivoConsulta() != null && !h.getMotivoConsulta().isEmpty()
                    ? h.getMotivoConsulta() : "<span class='vacio'>No registrado</span>" %></p>
            </div>

            <div class="hc-grid">
                <div class="hc-section">
                    <h4>Antecedentes personales</h4>
                    <p><%= h.getAntecedentesPersonales() != null && !h.getAntecedentesPersonales().isEmpty()
                        ? h.getAntecedentesPersonales() : "<span class='vacio'>No registrado</span>" %></p>
                </div>
                <div class="hc-section">
                    <h4>Antecedentes familiares</h4>
                    <p><%= h.getAntecedentesFamiliares() != null && !h.getAntecedentesFamiliares().isEmpty()
                        ? h.getAntecedentesFamiliares() : "<span class='vacio'>No registrado</span>" %></p>
                </div>
            </div>

            <div class="hc-section">
                <h4>Examen neurologico</h4>
                <p><%= h.getExamenNeurologico() != null && !h.getExamenNeurologico().isEmpty()
                    ? h.getExamenNeurologico() : "<span class='vacio'>No registrado</span>" %></p>
            </div>

            <div class="hc-section">
                <h4>Diagnostico</h4>
                <p><%= h.getDiagnostico() != null && !h.getDiagnostico().isEmpty()
                    ? h.getDiagnostico() : "<span class='vacio'>No registrado</span>" %></p>
            </div>

            <div class="hc-grid">
                <div class="hc-section">
                    <h4>Estudios diagnosticos</h4>
                    <p><%= h.getEstudios() != null && !h.getEstudios().isEmpty()
                        ? h.getEstudios() : "<span class='vacio'>No registrado</span>" %></p>
                </div>
                <div class="hc-section">
                    <h4>Plan de tratamiento</h4>
                    <p><%= h.getTratamiento() != null && !h.getTratamiento().isEmpty()
                        ? h.getTratamiento() : "<span class='vacio'>No registrado</span>" %></p>
                </div>
            </div>

            <div class="hc-section">
                <h4>Observaciones adicionales</h4>
                <p><%= h.getObservaciones() != null && !h.getObservaciones().isEmpty()
                    ? h.getObservaciones() : "<span class='vacio'>No registrado</span>" %></p>
            </div>

        </div>
    </div>
</div>
</body>
</html>
