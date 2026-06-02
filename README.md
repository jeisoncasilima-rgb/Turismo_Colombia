# 🇨🇴 TurismoLocal Colombia

En la actualidad, los viajeros y turistas que visitan Colombia carecen de una herramienta digital unificada que les permita descubrir, organizar y compartir lugares de interés (restaurantes, sitios turísticos, eventos culturales) de manera sencilla y sin depender de conexión a internet. Muchos recurren a búsquedas dispersas en redes sociales o aplicaciones genéricas que no ofrecen una experiencia personalizada ni la posibilidad de contribuir con nuevos lugares.

**TurismoLocal Colombia** es una aplicación móvil que resuelve esta problemática, permitiendo a los usuarios explorar los mejores lugares para visitar en las principales ciudades del país, filtrar por categorías, visualizar ubicaciones en un mapa interactivo y gestionar su propia información de forma 100% offline.

---

## 🚀 Características Principales

*   **Exploración Multiciudad:** Descubre lugares de interés en las principales ciudades de Colombia (Bogotá, Medellín, Cartagena, Neiva, entre otras).
*   **Filtros por Categorías:** Clasificación inteligente por comida, turismo y cultura para una búsqueda más rápida.
*   **Mapas Interactivos:** Visualización integrada de las ubicaciones de los sitios turísticos para facilitar la navegación del usuario.
*   **Arquitectura Offline-First:** Toda la información se almacena y gestiona localmente en el dispositivo, garantizando acceso total sin depender de una conexión a internet.
*   **Contribución de Usuarios:** Posibilidad de agregar nuevos lugares turísticos capturando fotos directamente desde la cámara del dispositivo, asignando ciudad, categoría y descripción.
*   **Gestión Dinámica:** Capacidad para crear y registrar nuevas ciudades que no se encuentren precargadas en la aplicación.
*   **Favoritos:** Guarda y organiza tus sitios preferidos para planificar tus rutas de viaje.

---

## 🎯 Público Objetivo

*   Turistas nacionales e internacionales que exploran Colombia.
*   Locales que desean redescubrir la oferta gastronómica, cultural y patrimonial de su propia ciudad.
*   Estudiantes de turismo y guías locales.
*   Cualquier persona interesada en explorar y compartir experiencias culturales en el país.

---

## 🛠️ Tecnologías y Herramientas Utilizadas

*   **Framework:** Flutter
*   **Lenguaje de Programación:** Dart
*   **Mapas:** Google Maps Flutter Integration
*   **Persistencia de Datos (Offline):** SQLite / Hive (Almacenamiento Local)
*   **Hardware del Dispositivo:** Integración con la Cámara nativa

---

## 🏗️ Estructura del Proyecto y Arquitectura

El proyecto sigue los principios de **Clean Architecture** (Arquitectura Limpia) y está organizado de manera modular en las siguientes capas y ramas de desarrollo estructural:

| Capa / Rama | Descripción |
| :--- | :--- |
| **`feature/data-layer`** | **Capa de Datos:** Implementa repositorios, fuentes de datos locales (SQLite/Hive), modelos y la lógica de persistencia offline. |
| **`feature/domain-usecase`** | **Capa de Dominio:** Contiene las entidades puras del negocio y los casos de uso independientes de cualquier framework o librería externa. |
| **`feature/viewmodels`** | **Capa de Presentación / Vista:** Aloja la interfaz de usuario (UI), componentes de Flutter, mapas, integración de cámara y la gestión del estado (ViewModels/Providers). |
| **`develop`** | Rama de integración para el desarrollo general de las características antes de pasar a producción. |
| **`main` / `master`** | Rama principal con las versiones estables y listas para despliegue de la aplicación. |

---

## 💻 Instrucciones de Instalación y Uso

1. Asegúrate de tener instalado el SDK de Flutter en tu máquina.
2. Clona este repositorio en tu entorno local:  
```bash
   git clone [https://github.com/tu-usuario/tu-repositorio.git](https://github.com/tu-usuario/tu-repositorio.git)
