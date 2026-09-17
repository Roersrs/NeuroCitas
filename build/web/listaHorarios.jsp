<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="modelo.Horario"%>
<%@page import="modelo.HorarioDAO"%>
<%@page import="java.util.List"%>
<%
    Usuario actual = (Usuario) session.getAttribute("usuarioLogueado");
    if (actual == null) { response.sendRedirect("index.jsp"); return; }
    if (actual.getIdperfil() != 1) { response.sendRedirect("front.jsp"); return; }

    UsuarioDAO udao = new UsuarioDAO();
    HorarioDAO hdao = new HorarioDAO();
    List<Usuario> doctores = udao.listarDoctores();
    List<Horario> horarios = hdao.listarTodos();
    String ok = request.getParameter("ok");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Horarios de neurólogos | NeuroCitas</title>
<style>
*{box-sizing:border-box} body{margin:0;font-family:Inter,Segoe UI,Arial,sans-serif;background:linear-gradient(135deg,#eef6fc 0%,#f8fbff 55%,#eaf3fb 100%);color:#10233f;min-height:100vh}.wrap{padding:24px;max-width:1500px;margin:auto}.hero{position:relative;overflow:hidden;border-radius:24px;padding:30px 34px;color:#fff;background:linear-gradient(120deg,#071b3a,#0b315f 58%,#075d8c);box-shadow:0 18px 45px rgba(10,42,78,.18);animation:rise .55s ease}.hero:before,.hero:after{content:"";position:absolute;border-radius:50%;border:1px solid rgba(95,211,255,.25)}.hero:before{width:260px;height:260px;right:45px;top:-110px}.hero:after{width:170px;height:170px;right:90px;top:-65px}.brain{position:absolute;right:38px;top:16px;font-size:92px;opacity:.22;filter:drop-shadow(0 0 18px #44c6ff);animation:pulse 3s ease-in-out infinite}.eyebrow{font-size:12px;letter-spacing:2.2px;color:#6fd5ff;font-weight:800}.hero h1{font-size:36px;margin:10px 0 8px}.hero p{margin:0;color:#c6ddf2;max-width:680px;line-height:1.6}.grid{display:grid;grid-template-columns:minmax(0,1fr) 270px;gap:18px;margin-top:18px}.card{background:rgba(255,255,255,.92);border:1px solid rgba(151,184,214,.28);border-radius:20px;padding:22px;box-shadow:0 12px 35px rgba(18,56,91,.08);animation:rise .65s ease}.card-head{display:flex;align-items:center;gap:13px;margin-bottom:18px}.icon{width:48px;height:48px;border-radius:14px;background:#e9f4ff;display:grid;place-items:center;font-size:24px}.card h2{margin:0;font-size:21px}.sub{color:#7188a5;font-size:13px;margin-top:4px}.form-grid{display:grid;grid-template-columns:1.35fr 1fr .8fr .8fr auto;gap:12px;align-items:end}.field label{display:block;font-size:12px;font-weight:800;margin:0 0 7px}.field select,.field input,.search{width:100%;height:46px;border:1px solid #cfdeec;border-radius:12px;background:#fbfdff;padding:0 13px;color:#18304f;outline:none;transition:.2s}.field select:focus,.field input:focus,.search:focus{border-color:#2087e8;box-shadow:0 0 0 4px rgba(32,135,232,.1)}.btn{height:46px;border:0;border-radius:12px;padding:0 18px;font-weight:800;cursor:pointer;transition:.2s}.primary{background:linear-gradient(135deg,#0875df,#159ee9);color:white;box-shadow:0 8px 18px rgba(8,117,223,.22)}.btn:hover{transform:translateY(-2px)}.alert{padding:12px 15px;border-radius:12px;margin-bottom:15px;font-weight:700;font-size:13px;animation:pop .35s ease}.success{background:#e9fbf1;color:#11773d}.error{background:#fff0f0;color:#b62c2c}.table-card{margin-top:18px}.toolbar{display:flex;justify-content:space-between;gap:15px;align-items:center}.toolbar .search{max-width:310px}.table-wrap{overflow:auto;border-radius:14px;border:1px solid #e1ebf4}.table{width:100%;border-collapse:collapse;background:white}.table th{background:#173b60;color:#fff;text-align:left;padding:13px;font-size:12px}.table td{padding:13px;border-bottom:1px solid #edf2f7;font-size:13px}.table tbody tr{transition:.2s}.table tbody tr:hover{background:#f3f9ff;transform:scale(1.002)}.doctor{font-weight:800}.muted{display:block;color:#7c91aa;font-size:11px;margin-top:3px}.badge{display:inline-flex;align-items:center;gap:7px;background:#ddf8e8;color:#138343;padding:6px 10px;border-radius:99px;font-weight:800;font-size:11px}.dot{width:7px;height:7px;border-radius:50%;background:#1bb95b}.danger{height:34px;background:#ffe7e7;color:#c62c2c;padding:0 11px}.stats{display:grid;gap:14px}.stat{background:#fff;border:1px solid #dfeaf4;border-radius:18px;padding:20px;box-shadow:0 10px 28px rgba(18,56,91,.06)}.stat .num{font-size:30px;font-weight:900;color:#0a5ea8}.stat small{color:#7890aa}.neuro-art{min-height:180px;color:#fff;background:linear-gradient(145deg,#0a2848,#0c5b86);position:relative;overflow:hidden}.neuro-art .bigbrain{font-size:90px;position:absolute;right:12px;bottom:2px;opacity:.3;animation:pulse 3s infinite}.neuro-art p{position:relative;z-index:2;font-weight:700;line-height:1.5;max-width:155px}.empty{text-align:center!important;color:#7990a8;padding:28px!important}@keyframes rise{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:none}}@keyframes pop{from{transform:scale(.97);opacity:0}to{transform:scale(1);opacity:1}}@keyframes pulse{50%{transform:scale(1.07);filter:drop-shadow(0 0 24px #44c6ff)}}@media(max-width:1050px){.grid{grid-template-columns:1fr}.stats{grid-template-columns:repeat(3,1fr)}.form-grid{grid-template-columns:1fr 1fr}.brain{display:none}}@media(max-width:650px){.wrap{padding:12px}.hero h1{font-size:27px}.form-grid,.stats{grid-template-columns:1fr}.toolbar{align-items:stretch;flex-direction:column}.toolbar .search{max-width:none}}
</style>
</head>
<body>
<div class="wrap">
  <section class="hero">
    <div class="eyebrow">GESTIÓN DE HORARIOS</div>
    <h1>Horarios de neurólogos</h1>
    <p>Organiza la disponibilidad de los especialistas y facilita el acceso de los pacientes a la atención neurológica.</p>
    <div class="brain">🧠</div>
  </section>

  <div class="grid">
    <main>
      <section class="card">
        <div class="card-head"><div class="icon">🗓️</div><div><h2>Agregar nuevo horario</h2><div class="sub">Registra la disponibilidad de un neurólogo.</div></div></div>
        <% if ("agregado".equals(ok)) { %><div class="alert success">✓ Horario agregado correctamente.</div><% } %>
        <% if ("eliminado".equals(ok)) { %><div class="alert success">✓ Horario eliminado correctamente.</div><% } %>
        <% if (error != null) { %><div class="alert error">⚠ <%= "cruce".equals(error) ? "Ese neurólogo ya tiene un horario en ese rango." : "hora".equals(error) ? "La hora de inicio debe ser menor que la hora final." : "campos".equals(error) ? "Completa todos los campos." : "No fue posible realizar la operación." %></div><% } %>
        <form action="CtrolHorario" method="post">
          <input type="hidden" name="accion" value="agregar">
          <div class="form-grid">
            <div class="field"><label>Neurólogo</label><select name="idDoctor" required><option value="">Seleccione un neurólogo</option><% for(Usuario d: doctores){ %><option value="<%=d.getIdentificacion()%>"><%=d.getNombre()%> <%=d.getApellido()%></option><% } %></select></div>
            <div class="field"><label>Día de la semana</label><select name="diaSemana" required><option value="">Seleccione un día</option><option>Lunes</option><option>Martes</option><option>Miércoles</option><option>Jueves</option><option>Viernes</option><option>Sábado</option><option>Domingo</option></select></div>
            <div class="field"><label>Hora de inicio</label><input type="time" name="horaInicio" required></div>
            <div class="field"><label>Hora de fin</label><input type="time" name="horaFin" required></div>
            <button class="btn primary" type="submit">＋ Agregar</button>
          </div>
        </form>
      </section>

      <section class="card table-card">
        <div class="toolbar"><div class="card-head" style="margin:0"><div class="icon">📋</div><div><h2>Horarios registrados</h2><div class="sub">Disponibilidad activa de los especialistas.</div></div></div><input class="search" id="buscar" type="search" placeholder="🔎 Buscar neurólogo o día..." oninput="filtrar()"></div>
        <br>
        <div class="table-wrap"><table class="table" id="tablaHorarios"><thead><tr><th>Neurólogo</th><th>Día</th><th>Hora inicio</th><th>Hora fin</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>
        <% if(horarios != null && !horarios.isEmpty()) { for(Horario h: horarios){ String nombre = h.getIdDoctor(); String esp="Neurología"; for(Usuario d: doctores){ if(d.getIdentificacion()!=null && d.getIdentificacion().equals(h.getIdDoctor())){ nombre=d.getNombre()+" "+d.getApellido(); if(d.getEspecialidad()!=null && !d.getEspecialidad().trim().isEmpty()) esp=d.getEspecialidad(); break; }} %>
          <tr><td><span class="doctor"><%=nombre%></span><span class="muted"><%=esp%> · ID <%=h.getIdDoctor()%></span></td><td><%=h.getDiaSemana()%></td><td>🕘 <%=h.getHoraInicio()%></td><td>🕐 <%=h.getHoraFin()%></td><td><span class="badge"><span class="dot"></span>Activo</span></td><td><form action="CtrolHorario" method="post" onsubmit="return confirm('¿Eliminar este horario?');"><input type="hidden" name="accion" value="eliminar"><input type="hidden" name="idHorario" value="<%=h.getIdHorario()%>"><input type="hidden" name="idDoctor" value="<%=h.getIdDoctor()%>"><button class="btn danger" type="submit">🗑 Eliminar</button></form></td></tr>
        <% }} else { %><tr><td class="empty" colspan="6">No hay horarios registrados todavía.</td></tr><% } %>
        </tbody></table></div>
      </section>
    </main>
    <aside class="stats">
      <div class="stat neuro-art"><p>“La neurología conecta ciencia con vida.”</p><div class="bigbrain">🧠</div></div>
      <div class="stat"><div class="num"><%=doctores.size()%></div><small>Neurólogos activos</small></div>
      <div class="stat"><div class="num"><%=horarios.size()%></div><small>Horarios registrados</small></div>
    </aside>
  </div>
</div>
<script>
function filtrar(){var q=document.getElementById('buscar').value.toLowerCase();document.querySelectorAll('#tablaHorarios tbody tr').forEach(function(f){f.style.display=f.innerText.toLowerCase().includes(q)?'':'none';});}
</script>
</body></html>
