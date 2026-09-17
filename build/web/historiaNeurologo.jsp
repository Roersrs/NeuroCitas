<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario, modelo.HistoriaClinica, modelo.HistoriaClinicaDAO, modelo.UsuarioDAO, java.util.List"%>
<%
    Usuario sesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (sesion == null || sesion.getIdperfil() != 2) {
        response.sendRedirect("index.jsp");
        return;
    }

    HistoriaClinicaDAO dao = new HistoriaClinicaDAO();
    UsuarioDAO uDao = new UsuarioDAO();

    // Edicion: cargar historia existente si se paso id
    HistoriaClinica editar = null;
    String idEditar = request.getParameter("editar");
    if (idEditar != null && !idEditar.isEmpty()) {
        try {
            editar = dao.obtenerPorId(Integer.parseInt(idEditar));
            // Solo puede editar historias que el mismo creo
            if (editar != null && !editar.getIdentificacionNeurologo().equals(sesion.getIdentificacion())) {
                editar = null;
            }
        } catch (NumberFormatException e) { editar = null; }
    }

    // Lista de historias creadas por este neurologo
    List<HistoriaClinica> historias = dao.listarPorNeurologo(sesion.getIdentificacion());

    // Lista de pacientes activos para el selector
    List<Usuario> pacientes = uDao.listadoDatos();
    // Filtrar solo pacientes (perfil 3)
    java.util.List<Usuario> soloPacientes = new java.util.ArrayList<>();
    for (Usuario p : pacientes) {
        if (p.getIdperfil() == 3) soloPacientes.add(p);
    }

    String ok = request.getParameter("ok");
    String err = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/estilos.css">
    <title>NeuroCitas - Historias Clinicas</title>
</head>
<body>
<div class="page">

    <div class="topbar">
        <h2 style="margin:0;color:var(--primary);">Historias Clinicas — Neurologo</h2>
    </div>

    <% if ("1".equals(ok)) { %>
        <div class="msg ok">Historia clinica registrada correctamente.</div>
    <% } else if ("2".equals(ok)) { %>
        <div class="msg ok">Historia clinica actualizada correctamente.</div>
    <% } else if (err != null) { %>
        <div class="msg error">Ocurrio un error. Verifique los datos e intente de nuevo.</div>
    <% } %>

    <!-- Formulario nueva / edicion -->
    <div class="card" style="margin-bottom:28px;">
        <h3 style="margin-top:0;color:var(--primary);">
            <%= editar != null ? "Editar historia clinica" : "Registrar nueva historia clinica" %>
        </h3>
        <form method="post" action="CtrolHistoriaClinica">
            <input type="hidden" name="accion" value="<%= editar != null ? "editar" : "nueva" %>">
            <% if (editar != null) { %>
                <input type="hidden" name="id_historia" value="<%= editar.getIdHistoria() %>">
            <% } %>

            <div class="form-grid">
                <div class="campo full">
                    <label>Paciente</label>
                    <% if (editar != null) { %>
                        <input type="text" value="<%= editar.getNombrePaciente() %> (C.C. <%= editar.getIdentificacionPaciente() %>)" disabled>
                        <input type="hidden" name="identificacion_paciente" value="<%= editar.getIdentificacionPaciente() %>">
                    <% } else { %>
                        <select name="identificacion_paciente" required>
                            <option value="">-- Seleccione el paciente --</option>
                            <% for (Usuario p : soloPacientes) { %>
                                <option value="<%= p.getIdentificacion() %>">
                                    <%= p.getNombre() %> <%= p.getApellido() %> — C.C. <%= p.getIdentificacion() %>
                                </option>
                            <% } %>
                        </select>
                    <% } %>
                </div>

                <div class="campo full">
                    <label>Motivo de consulta</label>
                    <textarea name="motivo_consulta" placeholder="Describa el motivo principal de la consulta" required><%= editar != null ? editar.getMotivoConsulta() : "" %></textarea>
                </div>

                <div class="campo">
                    <label>Antecedentes personales</label>
                    <textarea name="antecedentes_personales" placeholder="Enfermedades previas, ciruguias, alergias..."><%= editar != null ? editar.getAntecedentesPersonales() : "" %></textarea>
                </div>

                <div class="campo">
                    <label>Antecedentes familiares</label>
                    <textarea name="antecedentes_familiares" placeholder="Enfermedades neurologicas en la familia..."><%= editar != null ? editar.getAntecedentesFamiliares() : "" %></textarea>
                </div>

                <div class="campo full">
                    <label>Examen neurologico</label>
                    <textarea name="examen_neurologico" placeholder="Hallazgos del examen fisico neurologico..."><%= editar != null ? editar.getExamenNeurologico() : "" %></textarea>
                </div>

                <div class="campo full">
                    <label>Diagnostico</label>
                    <textarea name="diagnostico" placeholder="Diagnostico o impresion diagnostica..." required><%= editar != null ? editar.getDiagnostico() : "" %></textarea>
                </div>

                <div class="campo">
                    <label>Estudios diagnosticos solicitados</label>
                    <textarea name="estudios" placeholder="Resonancia, tomografia, EEG, laboratorios..."><%= editar != null ? editar.getEstudios() : "" %></textarea>
                </div>

                <div class="campo">
                    <label>Plan de tratamiento</label>
                    <textarea name="tratamiento" placeholder="Medicamentos, dosis, indicaciones..."><%= editar != null ? editar.getTratamiento() : "" %></textarea>
                </div>

                <div class="campo full">
                    <label>Observaciones adicionales</label>
                    <textarea name="observaciones" placeholder="Notas adicionales, proxima cita, recomendaciones..."><%= editar != null ? editar.getObservaciones() : "" %></textarea>
                </div>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit"><%= editar != null ? "Guardar cambios" : "Registrar historia clinica" %></button>
                <% if (editar != null) { %>
                    <a class="btn secondary" href="historiaNeurologo.jsp">Cancelar</a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Tabla de historias registradas -->
    <div class="card">
        <h3 style="margin-top:0;color:var(--primary);">Historias clinicas registradas</h3>
        <% if (historias.isEmpty()) { %>
            <p style="color:var(--muted);">No ha registrado historias clinicas aun.</p>
        <% } else { %>
            <div style="overflow-x:auto;">
            <table class="table">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Paciente</th>
                        <th>C.C. Paciente</th>
                        <th>Diagnostico</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (HistoriaClinica h : historias) { %>
                        <tr>
                            <td><%= h.getFechaRegistro() %></td>
                            <td><%= h.getNombrePaciente() %></td>
                            <td><%= h.getIdentificacionPaciente() %></td>
                            <td><%= h.getDiagnostico() != null && h.getDiagnostico().length() > 60
                                    ? h.getDiagnostico().substring(0,60) + "..."
                                    : h.getDiagnostico() %></td>
                            <td style="display:flex;gap:8px;flex-wrap:wrap;">
                                <a class="btn" style="padding:6px 14px;font-size:13px;"
                                   href="historiaNeurologo.jsp?editar=<%= h.getIdHistoria() %>">Editar</a>
                                <a class="btn secondary" style="padding:6px 14px;font-size:13px;"
                                   href="detalleHistoria.jsp?id=<%= h.getIdHistoria() %>">Ver detalle</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
