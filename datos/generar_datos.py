#!/usr/bin/env python3
"""
Generador de DATOS SINTETICOS para NeuroCitas.

Todo lo que produce es ficticio: nombres combinados al azar, cedulas que empiezan
por 9 (rango no usado para personas reales aqui), correos @example.com y textos
clinicos de plantilla. No contiene ni un dato real de pacientes.

Uso:
    pip install bcrypt
    python generar_datos.py                      # 12 neurologos, 500 pacientes, 5000 citas
    python generar_datos.py --pacientes 5000 --citas 60000 --csv

Genera:
    datos_sinteticos.sql   -> INSERTs listos para MySQL (base NeuroCitas)
    csv/*.csv              -> (solo con --csv) los mismos datos para la ingesta Big Data

Clave de TODOS los usuarios generados: Demo123*   (se guarda con BCrypt, como la app)
"""
import argparse
import csv
import os
import random
from datetime import date, datetime, timedelta

import bcrypt

CLAVE_DEMO = "Demo123*"
HOY = date(2026, 10, 6)

NOMBRES = ["Carlos", "Maria", "Juan", "Luisa", "Andres", "Camila", "Santiago", "Valentina",
           "Felipe", "Daniela", "Sebastian", "Paula", "Mateo", "Laura", "Diego", "Sofia",
           "Alejandro", "Natalia", "Julian", "Carolina", "Esteban", "Juliana", "Nicolas",
           "Mariana", "David", "Isabela", "Miguel", "Andrea", "Jorge", "Catalina", "Ricardo",
           "Lucia", "Hector", "Gabriela", "Mauricio", "Angela", "Fernando", "Monica"]
APELLIDOS = ["Gomez", "Rodriguez", "Martinez", "Lopez", "Garcia", "Hernandez", "Ramirez",
             "Torres", "Diaz", "Vargas", "Castro", "Moreno", "Rojas", "Ortiz", "Jimenez",
             "Munoz", "Pineda", "Suarez", "Cardenas", "Mejia", "Salazar", "Restrepo",
             "Acosta", "Quintero", "Herrera", "Parra", "Cortes", "Velasquez", "Ospina", "Arias"]
ESPECIALIDADES = ["Neurologia general", "Epilepsia", "Neurologia pediatrica", "Cefaleas",
                  "Enfermedad cerebrovascular", "Trastornos del movimiento", "Neuromuscular"]
DIAS = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
DIA_IDX = {d: i for i, d in enumerate(DIAS)}
BLOQUES = [("07:00:00", "12:00:00"), ("14:00:00", "18:00:00")]

# Cuadros clinicos de plantilla (diagnostico -> textos)
CUADROS = [
    {"dx": "Migrana sin aura", "serv": [1, 2, 8],
     "motivo": "Dolor de cabeza pulsatil recurrente",
     "actual": "Cefalea hemicraneal de {n} meses de evolucion, intensidad {i}/10, con fotofobia y nauseas.",
     "ant": "Madre con migrana. Sin cirugias previas.",
     "examen": "Alerta, orientado. Pares craneales normales. Fuerza y sensibilidad conservadas.",
     "trat": "Analgesia de rescate, profilaxis con topiramato. Higiene del sueno.",
     "obs": "Control en 8 semanas con diario de cefalea."},
    {"dx": "Cefalea tensional cronica", "serv": [1, 2, 8],
     "motivo": "Dolor opresivo holocraneano",
     "actual": "Cefalea en banda de {n} meses, sin signos de alarma, relacionada con estres laboral.",
     "ant": "Sin antecedentes neurologicos. Refiere insomnio ocasional.",
     "examen": "Examen neurologico sin focalizacion. Contractura de musculatura cervical.",
     "trat": "Amitriptilina nocturna a dosis baja, terapia fisica, pausas activas.",
     "obs": "Reevaluar respuesta en 6 semanas."},
    {"dx": "Epilepsia focal", "serv": [5, 7, 2],
     "motivo": "Episodios de perdida de conciencia",
     "actual": "Crisis focales con alteracion de la conciencia, frecuencia de {n} por mes.",
     "ant": "Trauma craneoencefalico leve en la infancia.",
     "examen": "Sin deficit motor. Lenguaje fluido. Reflejos simetricos.",
     "trat": "Levetiracetam, ajuste segun respuesta. Evitar privacion de sueno.",
     "obs": "Solicitar EEG de control. Educacion sobre conduccion y seguridad."},
    {"dx": "Accidente cerebrovascular isquemico (secuelas)", "serv": [2, 3, 4],
     "motivo": "Control posterior a evento cerebrovascular",
     "actual": "Evento isquemico hace {n} meses, con hemiparesia leve residual en rehabilitacion.",
     "ant": "Hipertension arterial y dislipidemia.",
     "examen": "Hemiparesia 4/5 derecha, marcha con leve claudicacion.",
     "trat": "Antiagregacion, estatina, control de tension arterial, fisioterapia.",
     "obs": "Revisar resonancia y perfil lipidico en proximo control."},
    {"dx": "Enfermedad de Parkinson", "serv": [2, 1],
     "motivo": "Temblor en reposo y lentitud de movimientos",
     "actual": "Temblor de mano izquierda y bradicinesia de {n} meses de evolucion.",
     "ant": "Sin antecedentes familiares relevantes.",
     "examen": "Rigidez en rueda dentada, bradicinesia, marcha con disminucion del braceo.",
     "trat": "Inicio de levodopa/carbidopa. Terapia ocupacional y fisica.",
     "obs": "Evaluar fluctuaciones motoras en el seguimiento."},
    {"dx": "Neuropatia periferica diabetica", "serv": [1, 2],
     "motivo": "Hormigueo y ardor en pies",
     "actual": "Parestesias distales simetricas de {n} meses, empeoran en la noche.",
     "ant": "Diabetes mellitus tipo 2 de larga data.",
     "examen": "Hipoestesia en guante y calcetin, reflejo aquileo disminuido.",
     "trat": "Pregabalina, control glucemico estricto, cuidado de pies.",
     "obs": "Solicitar electromiografia si no hay mejoria."},
    {"dx": "Sindrome vertiginoso periferico", "serv": [1, 2],
     "motivo": "Mareo con sensacion de giro",
     "actual": "Episodios de vertigo de segundos con cambios de posicion durante {n} semanas.",
     "ant": "Sin hipoacusia ni tinnitus.",
     "examen": "Maniobra de Dix-Hallpike positiva. Sin nistagmo espontaneo.",
     "trat": "Maniobra de reposicion canalicular, ejercicios vestibulares.",
     "obs": "Reconsulta si aparecen signos de alarma."},
    {"dx": "Deterioro cognitivo leve", "serv": [1, 3, 4],
     "motivo": "Olvidos frecuentes",
     "actual": "Fallas de memoria reciente progresivas hace {n} meses, funcional para actividades basicas.",
     "ant": "Hipertension controlada. Escolaridad media.",
     "examen": "MoCA con puntaje limitrofe. Sin focalizacion.",
     "trat": "Control de factores vasculares, estimulacion cognitiva, ejercicio.",
     "obs": "Solicitar resonancia cerebral y laboratorio de demencia."},
    {"dx": "Temblor esencial", "serv": [1, 2],
     "motivo": "Temblor en manos al escribir",
     "actual": "Temblor postural bilateral de {n} anos, mejora con reposo.",
     "ant": "Padre con temblor similar.",
     "examen": "Temblor postural y cinetico, sin rigidez ni bradicinesia.",
     "trat": "Propranolol, evitar cafeina.",
     "obs": "Seguimiento anual."},
    {"dx": "Esclerosis multiple remitente-recurrente", "serv": [2, 3, 1],
     "motivo": "Control de enfermedad desmielinizante",
     "actual": "Brotes previos con alteracion visual y parestesias; ultimo brote hace {n} meses.",
     "ant": "Diagnostico hace 3 anos.",
     "examen": "EDSS estable, sin nuevos deficits.",
     "trat": "Terapia modificadora de enfermedad segun protocolo.",
     "obs": "Resonancia de control anual."},
    {"dx": "Sindrome del tunel carpiano", "serv": [1, 2],
     "motivo": "Adormecimiento de mano al dormir",
     "actual": "Parestesias en territorio del mediano de {n} meses.",
     "ant": "Trabajo con digitacion prolongada.",
     "examen": "Tinel y Phalen positivos.",
     "trat": "Ferula nocturna, ergonomia, antiinflamatorio corto.",
     "obs": "Solicitar estudio de conduccion nerviosa."},
]


def esc(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


def filas_insert(f, tabla, cols, filas, lote=500):
    for i in range(0, len(filas), lote):
        parte = filas[i:i + lote]
        f.write(f"INSERT INTO {tabla} ({', '.join(cols)}) VALUES\n")
        f.write(",\n".join("(" + ", ".join(esc(x) for x in r) + ")" for r in parte))
        f.write(";\n")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--neurologos", type=int, default=12)
    ap.add_argument("--pacientes", type=int, default=500)
    ap.add_argument("--citas", type=int, default=5000)
    ap.add_argument("--semilla", type=int, default=42)
    ap.add_argument("--csv", action="store_true", help="exporta tambien CSV para Big Data")
    ap.add_argument("--salida", default="datos_sinteticos.sql")
    a = ap.parse_args()
    rnd = random.Random(a.semilla)

    # Hash $2a$ para ser 100% compatible con jBCrypt 0.4
    h = bcrypt.hashpw(CLAVE_DEMO.encode(), bcrypt.gensalt(10)).decode()
    h = "$2a$" + h[4:]

    usados_id, usados_usr = {"1001"}, {"admin"}

    def persona(prefijo):
        while True:
            ident = "9" + str(rnd.randint(0, 999_999_999)).zfill(9)
            if ident not in usados_id:
                usados_id.add(ident)
                break
        nom, ape = rnd.choice(NOMBRES), rnd.choice(APELLIDOS)
        base = f"{prefijo}.{nom}.{ape}".lower()
        usr, k = base, 1
        while usr in usados_usr:
            k += 1
            usr = f"{base}{k}"
        usados_usr.add(usr)
        tel = "300" + str(rnd.randint(0, 9_999_999)).zfill(7)
        return ident, nom, ape, f"{usr}@example.com", tel, usr

    usuarios, neuros, pacs = [], [], []
    for _ in range(a.neurologos):
        i, n, ap_, em, tel, usr = persona("dr")
        esp = rnd.choice(ESPECIALIDADES)
        usuarios.append((i, n, ap_, em, tel, esp, usr, h, 2, 1))
        neuros.append(i)
    for _ in range(a.pacientes):
        i, n, ap_, em, tel, usr = persona("pac")
        usuarios.append((i, n, ap_, em, tel, None, usr, h, 3, 1))
        pacs.append(i)

    # Horarios: 3 a 5 dias por neurologo, un bloque (manana o tarde) por dia
    horarios, agenda = [], {}
    for d in neuros:
        for dia in rnd.sample(DIAS, rnd.randint(3, 5)):
            ini, fin = rnd.choice(BLOQUES)
            horarios.append((d, dia, ini, fin, 1))
            agenda.setdefault(d, {})[dia] = (ini, fin)

    def slots(ini, fin, minutos=30):
        t = datetime.strptime(ini, "%H:%M:%S")
        end = datetime.strptime(fin, "%H:%M:%S")
        while t < end:
            yield t.strftime("%H:%M:%S")
            t += timedelta(minutes=minutos)

    # Citas coherentes con el horario del neurologo, sin doble reserva
    ocupado, citas, plan_hist = set(), [], []
    inicio = HOY - timedelta(days=540)
    fin_rango = HOY + timedelta(days=45)
    intentos = 0
    while len(citas) < a.citas and intentos < a.citas * 30:
        intentos += 1
        doc = rnd.choice(neuros)
        f = inicio + timedelta(days=rnd.randint(0, (fin_rango - inicio).days))
        dia = DIAS[f.weekday()] if f.weekday() < 6 else None
        if dia is None or dia not in agenda[doc]:
            continue
        hora = rnd.choice(list(slots(*agenda[doc][dia])))
        clave = (doc, f, hora)
        if clave in ocupado:
            continue
        ocupado.add(clave)
        pac = rnd.choice(pacs)
        cuadro = rnd.choice(CUADROS)
        serv = rnd.choice(cuadro["serv"])
        if f < HOY:
            estado = rnd.choices(["Atendida", "Cancelada", "Pendiente"], [78, 17, 5])[0]
        else:
            estado = rnd.choices(["Pendiente", "Cancelada"], [90, 10])[0]
        obs = rnd.choice(["Primera vez", "Control", "Remitido por medicina general",
                          "Trae examenes previos", None])
        citas.append((pac, doc, serv, f.isoformat(), hora, estado, obs, 1))
        if estado == "Atendida" and rnd.random() < 0.85:
            plan_hist.append((pac, doc, f, cuadro))

    # Historias clinicas a partir de citas atendidas
    historias = []
    for pac, doc, f, c in plan_hist:
        n = rnd.randint(2, 18)
        historias.append((
            pac, doc, c["motivo"],
            c["actual"].format(n=n, i=rnd.randint(4, 9)),
            c["ant"], c["examen"], c["dx"], c["trat"], c["obs"], f.isoformat(), 1))

    cu = ["identificacion", "nombre", "apellido", "email", "telefono", "especialidad",
          "usuario", "clave", "id_perfil", "id_estado"]
    ch = ["id_doctor", "dia_semana", "hora_inicio", "hora_fin", "id_estado"]
    cc = ["identificacion_cliente", "identificacion_doctor", "id_servicio", "fecha", "hora",
          "estado", "observacion", "id_estado"]
    chc = ["identificacion_paciente", "identificacion_doctor", "motivo_consulta",
           "enfermedad_actual", "antecedentes", "examen_fisico", "diagnostico", "tratamiento",
           "observaciones", "fecha_registro", "id_estado"]

    with open(a.salida, "w", encoding="utf-8") as f:
        f.write("-- DATOS SINTETICOS (ficticios) para NeuroCitas\n")
        f.write(f"-- Clave de todos los usuarios generados: {CLAVE_DEMO}\n")
        f.write("USE NeuroCitas;\nSET NAMES utf8mb4;\nSET FOREIGN_KEY_CHECKS = 0;\nSTART TRANSACTION;\n\n")
        filas_insert(f, "Usuario", cu, usuarios)
        filas_insert(f, "horarios", ch, horarios)
        filas_insert(f, "Cita", cc, citas)
        filas_insert(f, "HistoriaClinica", chc, historias)
        f.write("\nCOMMIT;\nSET FOREIGN_KEY_CHECKS = 1;\n")

    if a.csv:
        os.makedirs("csv", exist_ok=True)
        for nombre, cols, filas in [("usuarios", cu, usuarios), ("horarios", ch, horarios),
                                    ("citas", cc, citas), ("historias_clinicas", chc, historias)]:
            with open(f"csv/{nombre}.csv", "w", newline="", encoding="utf-8") as fc:
                w = csv.writer(fc)
                w.writerow(cols)
                w.writerows(filas)

    print(f"Usuarios: {len(usuarios)} ({len(neuros)} neurologos, {len(pacs)} pacientes)")
    print(f"Horarios: {len(horarios)} | Citas: {len(citas)} | Historias: {len(historias)}")
    print(f"Archivo: {a.salida}" + (" + carpeta csv/" if a.csv else ""))


if __name__ == "__main__":
    main()
