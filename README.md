# 📱 Taller: Navegación y Ciclo de Vida en Flutter con go_router

Este proyecto implementa una aplicación en **Flutter** que demuestra:

- Navegación con **go_router** (`go`, `push`, `replace`).  
- Paso de parámetros entre pantallas.  
- Uso de diferentes widgets (`GridView`, `TabBar`, widget personalizado).  
- Ciclo de vida de un **StatefulWidget** evidenciado en consola.  

El objetivo es comprender cómo funciona la navegación en Flutter, cómo se envían parámetros y cómo se ejecutan los métodos del ciclo de vida.

---

## 🚀 Arquitectura y Navegación

La app utiliza **go_router** para manejar las rutas:

- **`/home`** → Pantalla principal con un `GridView` de tarjetas (ej. Noticias, Deportes, Ciencia).  
- **`/detail/:id`** → Pantalla secundaria que recibe un parámetro (`id`) y muestra información detallada.  
- **`/tabs`** → Pantalla con `TabBar` para explorar distintas secciones.  

📸 *Ejemplo de la pantalla principal:*  
<img width="479" height="1035" alt="Captura de pantalla 2025-09-18 213523" src="https://github.com/user-attachments/assets/03e95b15-8e13-46fc-848a-615424d505cd" />

---

## 🔀 Diferencia entre `go`, `push` y `replace`

- **`go`** → Navega reemplazando la ruta actual.  
  👉 El botón **Atrás** del celular retorna al inicio de la aplicación, o sea al menu de apps del celular, saliendo de estaw  
  <img width="465" height="1003" alt="go ejemplo" src="https://github.com/user-attachments/assets/9c05f56d-1026-4fdd-a3aa-0d6eae12a99f" />

- **`push`** → Apila la nueva ruta encima de la actual.  
  👉 El botón **Atrás** regresa a la pantalla anterior.  
  <img width="517" height="1060" alt="push ejemplo" src="https://github.com/user-attachments/assets/3078d3b9-3958-43bf-8f84-7d14f2aa343b" />

- **`replace`** → Sustituye la pantalla actual por la nueva.  
  👉 La anterior se elimina del stack de navegación.  
  <img width="491" height="1039" alt="replace ejemplo" src="https://github.com/user-attachments/assets/bbb192f3-2b84-42cb-b600-bb07a717323e" />

---

## 🔄 Evidencia del Ciclo de Vida

El ciclo de vida del **StatefulWidget** se registró en consola, mostrando la ejecución de los métodos:  
- `initState()`  
- `didChangeDependencies()`  
- `build()`  
- `setState()`  
- `dispose()`  

📸 *Ejemplo de la consola durante las pruebas:*  
<img width="1919" height="1079" alt="ciclo de vida consola" src="https://github.com/user-attachments/assets/ab101cf3-2353-47b5-828a-9aeb93c37c75" />

---

## 👨‍🎓 Datos del Estudiante

- **Nombre completo:** José Manuel Cárdenas Gamboa  
- **Código:** 230221051  
