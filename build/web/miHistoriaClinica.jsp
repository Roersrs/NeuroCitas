<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.HistoriaClinica"%>
<%@page import="modelo.HistoriaClinicaDAO"%>
<%@page import="java.util.List"%>

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

    HistoriaClinicaDAO historiaDAO = new HistoriaClinicaDAO();
    List<HistoriaClinica> historias = historiaDAO.listarPorPaciente(actual.getIdentificacion());
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi historia clínica</title>
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
            font-size: 20px;
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
        }

        .empty-state {
            text-align: center;
            padding: 25px;
            color: #64748b;
            font-weight: 600;
        }
    </style>
</head>

<body>

<div class="page">

    <div class="page-header">
        <div>
            <h1>Mi historia clínica</h1>
            <p class="muted">
                Consulta cada atención médica registrada por separado según la fecha.
            </p>
        </div>
    </div>

    <div class="card mt-20">

        <h2>Registros clínicos</h2>

        <p class="muted">
            Cada tarjeta corresponde a una historia clínica o evolución diferente.
        </p>

        <% if (historias == null || historias.isEmpty()) { %>

            <div class="empty-state">
                Todavía no tienes historias clínicas registradas.
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
                                <h3>Historia clínica #<%= contador %></h3>

                                <p class="muted">
                                    Neurólogo:
                                    <strong>
                                        <%= h.getNombreDoctor() != null ? h.getNombreDoctor() : h.getIdentificacionDoctor() %>
                                    </strong>
                                </p>
                            </div>

                            <div class="historia-fecha">
                                <%= h.getFechaRegistro() != null ? h.getFechaRegistro() : "Sin fecha" %>
                            </div>

                        </div>

                        <div class="historia-dato">
                            <strong>Motivo de consulta</strong>
                            <p>
                                <%= h.getMotivoConsulta() != null && !h.getMotivoConsulta().trim().isEmpty()
                                    ? h.getMotivoConsulta()
                                    : "Sin registro" %>
                            </p>
                        </div>

                        <div class="historia-dato">
                            <strong>Enfermedad actual</strong>
                            <p>
                                <%= h.getEnfermedadActual() != null && !h.getEnfermedadActual().trim().isEmpty()
                                    ? h.getEnfermedadActual()
                                    : "Sin registro" %>
                            </p>
                        </div>

                        <div class="historia-dato">
                            <strong>Antecedentes</strong>
                            <p>
                                <%= h.getAntecedentes() != null && !h.getAntecedentes().trim().isEmpty()
                                    ? h.getAntecedentes()
                                    : "Sin registro" %>
                            </p>
                        </div>

                        <div class="historia-dato">
                            <strong>Examen físico / neurológico</strong>
                            <p>
                                <%= h.getExamenFisico() != null && !h.getExamenFisico().trim().isEmpty()
                                    ? h.getExamenFisico()
                                    : "Sin registro" %>
                            </p>
                        </div>

                        <div class="historia-dato">
                            <strong>Diagnóstico</strong>
                            <p>
                                <%= h.getDiagnostico() != null && !h.getDiagnostico().trim().isEmpty()
                                    ? h.getDiagnostico()
                                    : "Sin registro" %>
                            </p>
                        </div>

                        <div class="historia-dato">
                            <strong>Tratamiento / plan</strong>
                            <p>
                                <%= h.getTratamiento() != null && !h.getTratamiento().trim().isEmpty()
                                    ? h.getTratamiento()
                                    : "Sin registro" %>
                            </p>
                        </div>

                        <div class="historia-dato">
                            <strong>Observaciones</strong>
                            <p>
                                <%= h.getObservaciones() != null && !h.getObservaciones().trim().isEmpty()
                                    ? h.getObservaciones()
                                    : "Sin observaciones" %>
                            </p>
                        </div>

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