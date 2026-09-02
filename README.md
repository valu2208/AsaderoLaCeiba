# 🍖🍗 Asadero La Ceiba

El proyecto utiliza una arquitectura moderna basada en una app móvil, un servidor backend y una base de datos, integrando las siguientes tecnologías:

* **Node.js + Express**: Backend
* **Supabase**: Base de datos en la nube
* **Cloudinary**: Almacenamiento e imágenes de productos
* **Flutter**: Frontend móvil (en construcción)
* **JWT**: Manejo de sesiones y autenticación

---

## 📌 Características del Proyecto

### 1. Autenticación y Seguridad
* **Registro e Inicio de Sesión:** Autenticación segura para usuarios mediante tokens (JWT) y contraseñas cifradas con `bcrypt`.
* **Control de Acceso Basado en Roles (RBAC):** Rutas y permisos diferenciados para los roles **Usuario** y **Admin**.
* **Protección de Rutas:** Middlewares (`verificarToken`, `verificarAdmin`) en el backend para restringir el acceso a endpoints sensibles según el rol.
* **Recuperación de Contraseña:** Generación de código de verificación con expiración, envío por correo (`nodemailer`) y restablecimiento seguro de contraseña.

### 2. Panel Administrativo (Gestión del Asadero)
* **CRUD de Productos:** Creación, actualización y eliminación de productos del menú, con carga de imágenes a Cloudinary.
* **Gestión por Categorías:** Consulta de productos filtrados por categoría.
* **Gestión de Usuarios:** Listado, consulta, edición y eliminación de usuarios (acceso restringido a administradores).
* **Módulo de Cocina:** Vista de pedidos y actualización de su estado (*Pendiente*, *En preparación*, *Listo*, *Entregado*) para el flujo de preparación en cocina.

### 3. Catálogo (Experiencia del Cliente)
* **Consulta de Productos:** Listado general, detalle por producto y filtrado por categoría.
* **Datos del Producto:** Nombre, precio, descripción, categoría e imagen.

### 4. Flujo Comercial y Pedidos
* **Creación de Pedidos:** Registro de pedido con número de mesa, productos, cantidades, teléfono, notas y método de pago.
* **Soporte Multi-moneda:** Registro del total en moneda local (COP) y, opcionalmente, en moneda extranjera.
* **Historial de Pedidos:** Cada usuario puede consultar únicamente sus propios pedidos (`/mis-pedidos`).
* **Gestión de Pedidos (Admin):** Los administradores pueden listar todos los pedidos y actualizar su estado.

---

## 🛠️ Instalación y Configuración

### 1. Clonar el repositorio
```bash
git clone https://github.com/jlombana/AsaderoLaCeiba.git
```

* Instalación de Node.js
* Ejecutar `npm install` (dentro de `backend/`)
* Iniciar librería de `express`
* Iniciar librería de `supabase`
* Instalación de Flutter SDK (para ejecutar el frontend en `frontend/`)

### 2. Ejecutar el Servidor
```bash
cd backend
npm run dev
```

---

## 📂 Estructura del Proyecto

```
AsaderoLaCeiba/
├── backend/
│   ├── config/          # Conexión a Supabase y Cloudinary
│   ├── controllers/     # Lógica de auth, usuarios, productos, pedidos y cocina
│   ├── middlewares/     # Validación de JWT y roles
│   ├── models/          # Acceso a datos (usuarios, productos, pedidos, recuperación)
│   ├── routes/          # Definición de rutas del API
│   ├── utils/           # Envío de correos (recuperación de contraseña)
│   └── index.js         # Servidor principal Express
└── frontend/
    └── lib/
        ├── componentes/  # Widgets reutilizables
        ├── core/         # Estilos y colores de la app
        ├── pantallas/    # Pantallas de la aplicación
        └── main.dart     # Punto de entrada de la aplicación
```

---

## 👥 Autores

* **Danna Valeria Sánchez Hernández**
* **Liceth Natalia Cabrera Perdomo**

Aprendices del **SENA**, en formación **Análisis y Desarrollo de Software**.
