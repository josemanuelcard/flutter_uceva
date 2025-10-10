# 🚀 **Flutter UCEVA – Taller: Procesos en Segundo Plano**

## 📘 **Descripción General**
Este proyecto Flutter forma parte de la asignatura de **Desarrollo Móvil**.  
Su propósito es demostrar el manejo de **procesos en segundo plano** en Flutter utilizando:

- 🔹 **Asincronía con Future / async / await**  
- 🔹 **Timer** (cronómetro o cuenta regresiva)  
- 🔹 **Isolate** para tareas pesadas sin bloquear la interfaz  

La aplicación ayuda a comprender cómo ejecutar operaciones prolongadas sin afectar la **experiencia del usuario**.

---

## 🎯 **Objetivos del Taller**

### 1️⃣ Asincronía con Future / async / await
- Simular una consulta de datos usando `Future.delayed`.
- Mostrar los estados: **Cargando… / Éxito / Error**.
- Imprimir en consola el orden de ejecución.

### 2️⃣ Timer (Cronómetro o Cuenta Regresiva)
- Control del tiempo con botones:
  - ▶️ **Iniciar**
  - ⏸️ **Pausar**
  - 🔁 **Reanudar**
  - 🔄 **Reiniciar**
- Actualización del tiempo cada segundo.
- Cancelación automática del `Timer` al salir de la vista.

### 3️⃣ Isolate
- Ejecución de una función pesada (ej. cálculo grande o generación masiva de datos).
- Uso de `Isolate.spawn` para evitar bloqueos en la interfaz.
- Comunicación de resultados mediante `SendPort` y `ReceivePort`.

---

## 🧩 **Estructura del Proyecto**
<p align="center">
  <img width="300" height="805" alt="Estructura del Proyecto" src="https://github.com/user-attachments/assets/3e7960a5-fc77-40b4-85f3-9db81c4e7b88" />
</p>

---

## 🧰 **Tecnologías Utilizadas**
- 🧠 **Flutter 3.x**
- 💡 **Dart**
- 🎨 **Material Design**
- ⚙️ **Isolate API**
- ⏱️ **Timer**
- 🔄 **Future / async / await**

---

## 🧪 **Resultados del Taller**

<p align="center">
  <img width="446" height="1021" alt="Demo 1" src="https://github.com/user-attachments/assets/8f08fcb2-33af-492d-9ffd-652dc8ec700d" />
</p>

<p align="center">
  <img width="982" height="296" alt="Demo 2" src="https://github.com/user-attachments/assets/25eba30f-001c-44d2-ac2a-96ceeb1054f6" />
</p>

---

## 👨‍💻 **Autor**
**José Manuel Cárdenas Gamboa**  
📍 Universidad Central del Valle del Cauca (UCEVA)  
📅 2025
