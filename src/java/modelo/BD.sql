-- ============================================================
-- NeuroCitas - BASE DE DATOS CORREGIDA
-- Alineada con los DAO de Java (UsuarioDAO, HorarioDAO, CitaDAO, HistoriaClinicaDAO).
-- Cambios respecto al BD.sql original:
--   1. Usuario: se agrega la columna 'especialidad' dentro del CREATE (ya no hace falta el ALTER).
--   2. Tabla 'Horario' -> 'horarios' y columna 'identificacion_doctor' -> 'id_doctor'.
--   3. HistoriaClinica: columnas renombradas a las que usa el codigo
--      (identificacion_doctor, enfermedad_actual, antecedentes, examen_fisico);
--      se elimina 'estudios'; fecha_registro toma la fecha actual por defecto
--      (el INSERT de la app no la envia).
--   4. Admin con clave '123' guardada en BCrypt (antes estaba en texto plano).
--   5. Indices para que las consultas sigan rapidas con muchos datos.
-- Requiere MySQL 8.0.13+ o MariaDB 10.2+ (por DEFAULT (CURDATE())).
-- ADVERTENCIA: borra y recrea toda la base NeuroCitas.
-- ============================================================
DROP DATABASE IF EXISTS NeuroCitas;
CREATE DATABASE NeuroCitas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE NeuroCitas;

-- PERFILES
CREATE TABLE Perfil (
    id_perfil INT PRIMARY KEY AUTO_INCREMENT,
    perfil VARCHAR(40) NOT NULL,
    id_estado INT DEFAULT 1
);

INSERT INTO Perfil (perfil, id_estado) VALUES
('Administrador', 1),
('Neurologo', 1),
('Paciente', 1);

-- USUARIOS
CREATE TABLE Usuario (
    identificacion VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    email VARCHAR(80),
    telefono VARCHAR(30),
    especialidad VARCHAR(100) NULL,
    usuario VARCHAR(40) NOT NULL UNIQUE,
    clave VARCHAR(150) NOT NULL,
    id_perfil INT NOT NULL DEFAULT 3,
    id_estado INT DEFAULT 1,
    FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil)
);

-- ACTIVIDADES DE MENU (permisos por perfil)
CREATE TABLE actividades (
    id_actividad INT PRIMARY KEY AUTO_INCREMENT,
    nom_actividad VARCHAR(80) NOT NULL,
    enlace VARCHAR(120) NOT NULL,
    id_estado INT DEFAULT 1
);

INSERT INTO actividades (nom_actividad, enlace, id_estado) VALUES
('Usuarios',                  'listaUsuarios.jsp',      1),  -- 1
('Perfiles',                  'listaPerfiles.jsp',      1),  -- 2
('Permisos',                  'listaGesActividad.jsp',  1),  -- 3
('Servicios neurologicos',    'listaServicios.jsp',     1),  -- 4
('Horarios de neurologos',    'listaHorarios.jsp',      1),  -- 5
('Todas las citas',           'listaCitas.jsp',         1),  -- 6
('Asignar roles',             'asignarRoles.jsp',       1),  -- 7
('Mis citas como neurologo',  'citasDoctor.jsp',        1),  -- 8
('Agendar cita',              'agendarCita.jsp',        1),  -- 9
('Mis citas',                 'misCitasCliente.jsp',    1),  -- 10
('Solicitudes de neurologos', 'solicitudesDoctor.jsp',  1),  -- 11
('Historias clinicas',        'historiaNeurologo.jsp',  1),  -- 12
('Mi historia clinica',       'miHistoriaClinica.jsp',  1),  -- 13
('Buscar historia clinica',   'buscarHistoria.jsp',     1);  -- 14

-- PERMISOS POR PERFIL (1 = Administrador, 2 = Neurologo, 3 = Paciente)
CREATE TABLE gesActividad (
    idgesActividad INT PRIMARY KEY AUTO_INCREMENT,
    id_perfil INT NOT NULL,
    id_actividad INT NOT NULL,
    id_estado INT DEFAULT 1,
    FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil),
    FOREIGN KEY (id_actividad) REFERENCES actividades(id_actividad)
);

INSERT INTO gesActividad (id_perfil, id_actividad, id_estado) VALUES
(1, 1,  1), (1, 2,  1), (1, 3,  1), (1, 4,  1), (1, 5,  1),
(1, 6,  1), (1, 7,  1), (1, 11, 1), (1, 14, 1),
(2, 5,  1), (2, 8,  1), (2, 12, 1),
(3, 9,  1), (3, 10, 1), (3, 13, 1);

-- SERVICIOS NEUROLOGICOS
CREATE TABLE Servicio (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre_servicio VARCHAR(80) NOT NULL,
    descripcion VARCHAR(250),
    id_estado INT DEFAULT 1
);

INSERT INTO Servicio (nombre_servicio, descripcion, id_estado) VALUES
('Consulta neurologica inicial',   'Valoracion inicial por neurologo para evaluacion del sistema nervioso.', 1),
('Control neurologico',            'Seguimiento y monitoreo de enfermedades neurologicas en tratamiento.', 1),
('Lectura de resonancia magnetica','Interpretacion especializada de resonancia magnetica cerebral o medular.', 1),
('Lectura de tomografia',          'Analisis e interpretacion de tomografias computarizadas de craneo.', 1),
('Evaluacion de epilepsia',        'Valoracion, diagnostico y ajuste de tratamiento antiepileptico.', 1),
('Neurologia pediatrica',          'Atencion neurologica especializada en ninos y adolescentes.', 1),
('Electroencefalograma (EEG)',     'Registro y analisis de la actividad electrica cerebral.', 1),
('Evaluacion de cefalea cronica',  'Diagnostico y manejo de migrana y otras cefaleas cronicas.', 1);

-- HORARIOS (el codigo usa la tabla 'horarios' con la columna 'id_doctor')
CREATE TABLE horarios (
    id_horario INT PRIMARY KEY AUTO_INCREMENT,
    id_doctor VARCHAR(20) NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    id_estado INT DEFAULT 1,
    FOREIGN KEY (id_doctor) REFERENCES Usuario(identificacion),
    INDEX idx_horarios_doctor (id_doctor, dia_semana)
);

-- CITAS
CREATE TABLE Cita (
    id_cita INT PRIMARY KEY AUTO_INCREMENT,
    identificacion_cliente VARCHAR(20) NOT NULL,
    identificacion_doctor VARCHAR(20) NOT NULL,
    id_servicio INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    observacion VARCHAR(250),
    id_estado INT DEFAULT 1,
    FOREIGN KEY (identificacion_cliente) REFERENCES Usuario(identificacion),
    FOREIGN KEY (identificacion_doctor) REFERENCES Usuario(identificacion),
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
    INDEX idx_cita_doctor_fecha (identificacion_doctor, fecha, hora),
    INDEX idx_cita_cliente (identificacion_cliente),
    INDEX idx_cita_fecha (fecha)
);

-- HISTORIA CLINICA NEUROLOGICA (columnas exactas que usa HistoriaClinicaDAO)
CREATE TABLE HistoriaClinica (
    id_historia             INT PRIMARY KEY AUTO_INCREMENT,
    identificacion_paciente VARCHAR(20) NOT NULL,
    identificacion_doctor   VARCHAR(20) NOT NULL,
    motivo_consulta         TEXT,
    enfermedad_actual       TEXT,
    antecedentes            TEXT,
    examen_fisico           TEXT,
    diagnostico             TEXT,
    tratamiento             TEXT,
    observaciones           TEXT,
    fecha_registro          DATE NOT NULL DEFAULT (CURDATE()),
    id_estado               INT DEFAULT 1,
    FOREIGN KEY (identificacion_paciente) REFERENCES Usuario(identificacion),
    FOREIGN KEY (identificacion_doctor)   REFERENCES Usuario(identificacion),
    INDEX idx_hc_paciente (identificacion_paciente, fecha_registro),
    INDEX idx_hc_doctor (identificacion_doctor)
);

-- ADMINISTRADOR POR DEFECTO: usuario 'admin', clave '123' (guardada con BCrypt)
INSERT INTO Usuario (identificacion, nombre, apellido, email, telefono, especialidad, usuario, clave, id_perfil, id_estado)
VALUES ('1001', 'Admin', 'NeuroCitas', 'admin@neurocitas.com', '3000000000', NULL, 'admin', '$2a$10$AzOw9vURtc7saE/s38Vc4ueutxZ6kkqPZv8YPw.74uI5YLi41wk52', 1, 1);
