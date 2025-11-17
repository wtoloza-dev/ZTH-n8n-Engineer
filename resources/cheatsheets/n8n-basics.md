# 📄 Cheat Sheet: n8n Básico

Referencia rápida de conceptos fundamentales de n8n.

---

## 🎯 Conceptos Clave

| Término | Definición | Analogía |
|---------|------------|----------|
| **Workflow** | Secuencia automatizada de acciones | Receta de cocina |
| **Node** | Bloque que realiza UNA acción | Ingrediente o paso |
| **Trigger** | Evento que inicia el workflow | Alarma que despierta |
| **Connection** | Línea que une nodos | Tubería que pasa datos |
| **Execution** | Una corrida del workflow | Una vez que haces la receta |
| **Credential** | Datos de autenticación (API keys, etc) | Llaves de tu casa |

---

## 🔧 Componentes de n8n

```
┌─────────────────────────────────────┐
│            N8N STACK                │
│                                     │
│  ┌───────────┐  ┌────────────────┐│
│  │  N8N WEB  │  │  N8N WORKERS   ││
│  │  (UI/API) │  │  (Ejecutores)  ││
│  └─────┬─────┘  └────────┬───────┘│
│        │                 │        │
│        └────────┬────────┘        │
│                 ↓                 │
│       ┌──────────────────┐       │
│       │   POSTGRESQL     │       │
│       │ (Base de datos)  │       │
│       └──────────────────┘       │
│                 +                │
│       ┌──────────────────┐       │
│       │     REDIS        │       │
│       │ (Cola trabajos)  │       │
│       └──────────────────┘       │
└─────────────────────────────────────┘
```

### Función de cada componente:

**N8N Web**
- ✅ Interfaz visual
- ✅ Editor de workflows
- ✅ API endpoints
- ❌ NO ejecuta workflows (usa workers)

**N8N Workers**
- ✅ Ejecutan los workflows
- ✅ Pueden ser múltiples (escala)
- ✅ Trabajan en paralelo

**PostgreSQL**
- ✅ Guarda workflows
- ✅ Guarda credenciales (encriptadas)
- ✅ Historial de ejecuciones

**Redis**
- ✅ Cola de trabajos (queue)
- ✅ Coordina workers
- ✅ Caché temporal

---

## 🔄 Tipos de Triggers

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Webhook** | URL que recibe datos | Formulario web envía datos |
| **Schedule** | Se ejecuta en horario | Todos los días a las 9am |
| **Poll** | Revisa algo periódicamente | Cada 5 min revisa email |
| **Manual** | Lo ejecutas tú | Botón "Test workflow" |

---

## 📝 Tipos de Nodos Comunes

### 🔄 **Core Nodes** (Nodos de control)

| Nodo | Función |
|------|---------|
| **IF** | Divide flujo según condición |
| **Switch** | Múltiples opciones (como IF múltiple) |
| **Merge** | Une datos de múltiples ramas |
| **Set** | Crea/modifica variables |
| **Code** | JavaScript custom |
| **HTTP Request** | Llamada a cualquier API |

### 🔗 **Integration Nodes** (Integraciones)

Ejemplos populares:

- 📧 **Gmail, Outlook** - Email
- 💬 **Slack, Discord, Telegram** - Mensajería
- 📊 **Google Sheets, Airtable** - Hojas de cálculo
- 🗄️ **PostgreSQL, MongoDB** - Bases de datos
- ☁️ **AWS, Google Cloud** - Cloud providers
- 🎨 **Notion, Trello** - Productividad

---

## 🌊 Flujo de Datos

Los datos fluyen de nodo en nodo:

```
[Nodo A] → dato1, dato2, dato3
              ↓
[Nodo B] → recibe dato1, dato2, dato3
              procesa
              ↓
              outputDatoX
              ↓
[Nodo C] → recibe outputDatoX
```

### Expresiones para acceder a datos:

```javascript
{{ $json.campo }}        // Campo del nodo anterior
{{ $node["NodoX"].json.campo }}  // Campo de nodo específico
{{ $now }}               // Fecha/hora actual
{{ $workflow.id }}       // ID del workflow
```

---

## 🎨 Modos de Ejecución

### Main Mode (Por defecto)
```
Todo corre en 1 proceso
┌───────────────┐
│    N8N        │
│  UI + Ejecución│
└───────────────┘

✅ Simple
❌ UI se bloquea con workflows pesados
❌ No escala
```

### Queue Mode (Producción)
```
Separado: UI y ejecución
┌────────┐   ┌─────────┐
│ N8N WEB│   │ WORKERS │
└────────┘   └─────────┘
     ↓            ↑
    ┌──────────────┐
    │    REDIS     │
    │   (Queue)    │
    └──────────────┘

✅ UI siempre responsive
✅ Escala horizontalmente
✅ Workflows en paralelo
```

---

## 🔐 Credenciales

Las credenciales NO se guardan en el workflow, están separadas.

```
Workflow:
  [Gmail Node] → Usa credencial "Gmail Production"

Credentials (separado):
  "Gmail Production"
    user: [email protected]
    password: ********** (encriptado)
```

**Importante:**
- ❌ Nunca hardcodees passwords en workflows
- ✅ Usa credentials
- ✅ Las credenciales están encriptadas en PostgreSQL

---

## 📦 Formatos de Datos

n8n trabaja principalmente con JSON:

```json
{
  "name": "Juan",
  "email": "[email protected]",
  "orders": [
    { "id": 1, "product": "Laptop" },
    { "id": 2, "product": "Mouse" }
  ]
}
```

Acceder en expresiones:
```javascript
{{ $json.name }}          // "Juan"
{{ $json.email }}         // "[email protected]"
{{ $json.orders[0].product }}  // "Laptop"
```

---

## 🚀 Ejecución de Workflows

### Estados de ejecución:

| Estado | Significa |
|--------|-----------|
| ⏳ **Running** | Ejecutando ahora |
| ✅ **Success** | Completado sin errores |
| ❌ **Error** | Falló en algún nodo |
| ⏸️ **Waiting** | Esperando (ej: webhook) |
| 🔄 **Queued** | En cola (con Queue Mode) |

---

## 💡 Tips Rápidos

### Debugging
```
1. Usa "Execute Node" para probar nodos individuales
2. Inspecciona JSON output de cada nodo
3. Usa nodo "Set" para ver variables
4. Activa "Save execution data" para ver historial
```

### Performance
```
1. Usa "Split in Batches" para grandes volúmenes
2. Activa "Always Output Data" en nodos que pueden fallar
3. Limpia ejecuciones viejas periódicamente
```

### Seguridad
```
1. NUNCA commitees credenciales a git
2. Usa variables de entorno para secretos
3. Limita acceso a n8n con autenticación
4. Usa HTTPS en producción
```

---

## 🆚 n8n vs Otras Herramientas

| Feature | n8n | Zapier | Make | Power Automate |
|---------|-----|--------|------|----------------|
| **Hosting** | Self-hosted | Cloud | Cloud | Cloud |
| **Costo** | Gratis | $20+/mes | $9+/mes | Incluido M365 |
| **Límites** | Ilimitado | 100-50k/mes | 1k-10k/mes | Varía |
| **Código custom** | Sí (JS) | No | Limitado | Limitado |
| **Open source** | Sí | No | No | No |
| **Curva aprendizaje** | Media | Baja | Baja | Media |

---

## 📚 Recursos Útiles

- 📖 [Docs oficiales](https://docs.n8n.io)
- 🎓 [n8n Academy](https://academy.n8n.io)
- 💬 [Community Forum](https://community.n8n.io)
- 🔧 [GitHub](https://github.com/n8n-io/n8n)
- 📺 [YouTube](https://youtube.com/@n8n-io)

---

## 🎯 Siguiente Paso

Ahora que conoces lo básico:
- **Para USAR n8n**: Lecciones de workflows
- **Para IMPLEMENTAR n8n**: Continúa con Docker

---

**💾 Guarda este cheatsheet** - Lo consultarás frecuentemente.

