<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="modelo.HistoriaClinica"%>
<%@page import="modelo.HistoriaClinicaDAO"%>
<%@page import="java.util.List"%>

<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");

    if (actual == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (actual.getIdperfil() != 1 && actual.getIdperfil() != 2) {
        response.sendRedirect("front.jsp");
        return;
    }

    String idPaciente = request.getParameter("idPaciente");

    if (idPaciente == null || idPaciente.trim().isEmpty()) {
        response.sendRedirect("buscarHistoria.jsp");
        return;
    }

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    Usuario paciente = usuarioDAO.listadoDatos_Id(idPaciente);

    if (paciente == null) {
        response.sendRedirect("buscarHistoria.jsp");
        return;
    }

    HistoriaClinicaDAO historiaDAO = new HistoriaClinicaDAO();
    List<HistoriaClinica> historias = historiaDAO.listarPorPaciente(idPaciente);

    String ok = request.getParameter("ok");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historia clínica</title>
    <link rel="stylesheet" href="css/estilos.css">

    <style>
        .historial-contenedor {
            display: flex;
            flex-direction: column;
            gap: 24px;
            margin-top: 25px;
        }

        .historia-individual {
            background: #ffffff;
            border: 1px solid #dbe4f0;
            border-left: 6px solid #0f4c9c;
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.06);
        }

        .historia-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            padding-bottom: 16px;
            margin-bottom: 18px;
            border-bottom: 1px solid #edf2f7;
        }

        .historia-top h3 {
            margin: 0;
            color: #0f4c9c;
            font-size: 21px;
        }

        .historia-fecha {
            background: #eef5ff;
            color: #0f4c9c;
            padding: 9px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            white-space: nowrap;
        }

        .historia-doctor {
            margin-top: 8px;
            color: #44546a;
            font-size: 14px;
        }

        .historia-dato {
            margin-bottom: 18px;
        }

        .historia-dato strong {
            display: block;
            color: #0b1f3f;
            font-size: 14px;
            margin-bottom: 6px;
        }

        .historia-dato p {
            margin: 0;
            color: #26384d;
            line-height: 1.6;
            background: #f8fafc;
            padding: 12px 14px;
            border-radius: 12px;
            border: 1px solid #edf2f7;
            white-space: pre-line;
        }

        .editar-box {
            display: none;
            background: #f8fafc;
            border: 1px solid #dbe4f0;
            border-radius: 18px;
            padding: 22px;
            margin-top: 18px;
        }

        .acciones-historia {
            margin-top: 18px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
    </style>

    <script>
        function mostrarFormularioEditar(id) {
            const form = document.getElementById("editar-" + id);

            if (form.style.display === "none" || form.style.display === "") {
                form.style.display = "block";
            } else {
                form.style.display = "none";
            }
        }
    </script>
</head>

<body>

<div class="page">

    <div class="page-header">
        <div>
            <h1>Historia clínica</h1>

            <p class="muted">
                Paciente:
                <strong><%= paciente.getNombre() %> <%= paciente.getApellido() %></strong>
                —
                Identificación:
                <strong><%= paciente.getIdentificacion() %></strong>
            </p>
        </div>

        <a href="buscarHistoria.jsp" class="btn secondary">
            Volver
        </a>
    </div>

    <% if ("guardado".equals(ok)) { %>

        <div class="msg ok">
            Historia clínica guardada correctamente.
        </div>

    <% } else if ("editado".equals(ok)) { %>

        <div class="msg ok">
            Historia clínica actualizada correctamente.
        </div>

    <% } %>

    <% if ("motivo".equals(error)) { %>

        <div class="msg error">
            Debes llenar el motivo de consulta.
        </div>

    <% } else if ("enfermedad".equals(error)) { %>

        <div class="msg error">
            Debes llenar la enfermedad actual.
        </div>

    <% } else if ("diagnostico".equals(error)) { %>

        <div class="msg error">
            Debes llenar el diagnóstico.
        </div>

    <% } else if ("guardar".equals(error)) { %>

        <div class="msg error">
            No se pudo guardar la historia clínica. Revisa la base de datos o la consola de NetBeans.
        </div>

    <% } else if ("editarcampos".equals(error)) { %>

        <div class="msg error">
            Para editar, debes llenar motivo de consulta, enfermedad actual y diagnóstico.
        </div>

    <% } else if ("editar".equals(error)) { %>

        <div class="msg error">
            No se pudo editar la historia clínica. Revisa la base de datos o la consola de NetBeans.
        </div>

    <% } %>

    <% if (actual.getIdperfil() == 2) { %>

        <div class="card mt-20">

            <h2>Agregar nueva evolución / historia clínica</h2>

            <p class="muted">
                Registra una nueva atención médica para este paciente. Cada registro se guardará separado por fecha.
            </p>

            <form action="GuardarHistoriaClinica" method="post">

                <input type="hidden"
                       name="idPaciente"
                       value="<%= paciente.getIdentificacion() %>">

                <div class="form-grid">

                    <div class="full">
                        <label>Motivo de consulta</label>
                        <textarea name="motivoConsulta"
                                  required
                                  placeholder="Ej: Cefalea persistente, mareo, crisis convulsivas..."></textarea>
                    </div>

                    <div class="full">
                        <label>Enfermedad actual</label>
                        <textarea name="enfermedadActual"
                                  required
                                  placeholder="Describe la evolución del cuadro clínico actual."></textarea>
                    </div>

                    <div class="full">
                        <label>Antecedentes</label>
                        <textarea name="antecedentes"
                                  placeholder="Personales, familiares, farmacológicos, quirúrgicos, alérgicos..."></textarea>
                    </div>

                    <div class="full">
                        <label>Examen físico / neurológico</label>
                        <textarea name="examenFisico"
                                  placeholder="Estado general, pares craneales, fuerza, sensibilidad, reflejos, marcha..."></textarea>
                    </div>

                    <div class="full">
                        <label>Diagnóstico</label>
                        <textarea name="diagnostico"
                                  required
                                  placeholder="Diagnóstico principal o impresión diagnóstica."></textarea>
                    </div>

                    <div class="full">
                        <label>Tratamiento / plan</label>
                        <textarea name="tratamiento"
                                  placeholder="Medicamentos, laboratorios, imágenes, recomendaciones, controles..."></textarea>
                    </div>

                    <div class="full">
                        <label>Observaciones</label>
                        <textarea name="observaciones"
                                  placeholder="Notas adicionales de la atención."></textarea>
                    </div>

                </div>

                <div style="margin-top:20px;">
                    <button type="submit" class="btn">
                        Guardar nueva historia clínica
                    </button>
                </div>

            </form>

        </div>

    <% } %>

    <div class="card mt-20">

        <h2>Registros clínicos del paciente</h2>

        <p class="muted">
            Cada tarjeta corresponde a una atención diferente registrada en una fecha específica.
        </p>

        <% if (historias == null || historias.isEmpty()) { %>

            <div class="empty-state">
                Este paciente todavía no tiene historias clínicas registradas.
            </div>

        <% } else { %>

            <div class="historial-contenedor">

                <%
                    int contador = 1;
                    for (HistoriaClinica h : historias) {
                %>

                    <div class="historia-individual">

                        <div class="historia-top">

                            <div>
                                <h3>Atención registrada #<%= contador %></h3>

                                <div class="historia-doctor">
                                    Doctor:
                                    <strong>
                                        <%= h.getNombreDoctor() != null ? h.getNombreDoctor() : h.getIdentificacionDoctor() %>
                                    </strong>
                                </div>
                            </div>

                            <div class="historia-fecha">
                                <%= h.getFechaRegistro() != null ? h.getFechaRegistro() : "Sin fecha" %>
                            </div>

                        </div>

                        <div class="historia-dato">
                            <strong>Motivo de consulta</strong>
                            <p><%= h.getMotivoConsulta() != null && !h.getMotivoConsulta().trim().isEmpty()
                                    ? h.getMotivoConsulta()
                                    : "Sin registro" %></p>
                        </div>

                        <div class="historia-dato">
                            <strong>Enfermedad actual</strong>
                            <p><%= h.getEnfermedadActual() != null && !h.getEnfermedadActual().trim().isEmpty()
                                    ? h.getEnfermedadActual()
                                    : "Sin registro" %></p>
                        </div>

                        <div class="historia-dato">
                            <strong>Antecedentes</strong>
                            <p><%= h.getAntecedentes() != null && !h.getAntecedentes().trim().isEmpty()
                                    ? h.getAntecedentes()
                                    : "Sin registro" %></p>
                        </div>

                        <div class="historia-dato">
                            <strong>Examen físico / neurológico</strong>
                            <p><%= h.getExamenFisico() != null && !h.getExamenFisico().trim().isEmpty()
                                    ? h.getExamenFisico()
                                    : "Sin registro" %></p>
                        </div>

                        <div class="historia-dato">
                            <strong>Diagnóstico</strong>
                            <p><%= h.getDiagnostico() != null && !h.getDiagnostico().trim().isEmpty()
                                    ? h.getDiagnostico()
                                    : "Sin registro" %></p>
                        </div>

                        <div class="historia-dato">
                            <strong>Tratamiento / plan</strong>
                            <p><%= h.getTratamiento() != null && !h.getTratamiento().trim().isEmpty()
                                    ? h.getTratamiento()
                                    : "Sin registro" %></p>
                        </div>

                        <div class="historia-dato">
                            <strong>Observaciones</strong>
                            <p><%= h.getObservaciones() != null && !h.getObservaciones().trim().isEmpty()
                                    ? h.getObservaciones()
                                    : "Sin observaciones" %></p>
                        </div>

                        <% if (actual.getIdperfil() == 2) { %>

                            <div class="acciones-historia">
                                <button type="button"
                                        class="btn secondary"
                                        onclick="mostrarFormularioEditar(<%= h.getIdHistoria() %>)">
                                    Editar esta historia
                                </button>
                            </div>

                            <div id="editar-<%= h.getIdHistoria() %>" class="editar-box">

                                <h3>Editar historia clínica</h3>

                                <form action="EditarHistoriaClinica" method="post">

                                    <input type="hidden"
                                           name="idHistoria"
                                           value="<%= h.getIdHistoria() %>">

                                    <input type="hidden"
                                           name="idPaciente"
                                           value="<%= paciente.getIdentificacion() %>">

                                    <div class="form-grid">

                                        <div class="full">
                                            <label>Motivo de consulta</label>
                                            <textarea name="motivoConsulta" required><%= h.getMotivoConsulta() != null ? h.getMotivoConsulta() : "" %></textarea>
                                        </div>

                                        <div class="full">
                                            <label>Enfermedad actual</label>
                                            <textarea name="enfermedadActual" required><%= h.getEnfermedadActual() != null ? h.getEnfermedadActual() : "" %></textarea>
                                        </div>

                                        <div class="full">
                                            <label>Antecedentes</label>
                                            <textarea name="antecedentes"><%= h.getAntecedentes() != null ? h.getAntecedentes() : "" %></textarea>
                                        </div>

                                        <div class="full">
                                            <label>Examen físico / neurológico</label>
                                            <textarea name="examenFisico"><%= h.getExamenFisico() != null ? h.getExamenFisico() : "" %></textarea>
                                        </div>

                                        <div class="full">
                                            <label>Diagnóstico</label>
                                            <textarea name="diagnostico" required><%= h.getDiagnostico() != null ? h.getDiagnostico() : "" %></textarea>
                                        </div>

                                        <div class="full">
                                            <label>Tratamiento / plan</label>
                                            <textarea name="tratamiento"><%= h.getTratamiento() != null ? h.getTratamiento() : "" %></textarea>
                                        </div>

                                        <div class="full">
                                            <label>Observaciones</label>
                                            <textarea name="observaciones"><%= h.getObservaciones() != null ? h.getObservaciones() : "" %></textarea>
                                        </div>

                                    </div>

                                    <div style="margin-top:18px;">
                                        <button type="submit" class="btn">
                                            Guardar cambios
                                        </button>
                                    </div>

                                </form>

                            </div>

                        <% } %>

                    </div>

                <%
                        contador++;
                    }
                %>

            </div>

        <% } %>

    </div>

</div>

</body>
</html>