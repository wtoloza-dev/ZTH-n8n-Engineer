# 📚 Índice de Lecciones - ZTH: n8n Engineer

## 🎯 Cómo Navegar las Lecciones

1. **Lee el README.md de cada lección** - Contiene toda la teoría
2. **Haz los ejercicios en `/practica`** - Aprendizaje hands-on
3. **Consulta `/recursos`** - Material adicional y referencias
4. **Completa el checklist** al final de cada lección
5. **No saltes lecciones** - Cada una se construye sobre la anterior

---

## 🟢 NIVEL PRINCIPIANTE: Foundations

### [Lección 1: Fundamentos - ¿Qué es n8n?](./01-foundations)
**Duración:** 30 minutos | **Dificultad:** ⭐

📖 **Aprenderás:**
- Qué es n8n y para qué sirve
- Casos de uso reales
- Diferencia entre "usar" vs "implementar" n8n
- Arquitectura general a alto nivel

🧪 **Práctica:**
- Explorar n8n.io y casos de uso
- Identificar escenarios de automatización

🎯 **Objetivo:** Entender QUÉ vas a aprender a implementar

---

### [Lección 2: Docker Desde Cero](./02-docker-basics)
**Duración:** 1 hora | **Dificultad:** ⭐⭐

📖 **Aprenderás:**
- ¿Qué es un contenedor? (con analogías)
- ¿Por qué Docker resuelve "funciona en mi máquina"?
- Imágenes vs Contenedores
- Comandos esenciales de Docker
- Volúmenes y persistencia

🧪 **Práctica:**
- Instalar Docker Desktop
- Correr tu primer contenedor
- Explorar contenedores activos
- Crear un contenedor con volumen

🎯 **Objetivo:** Dominar conceptos básicos de Docker

---

### [Lección 3: Docker Compose](./03-docker-compose)
**Duración:** 1 hora | **Dificultad:** ⭐⭐

📖 **Aprenderás:**
- El problema de múltiples contenedores
- Sintaxis de docker-compose.yml
- Servicios, redes y volúmenes
- Comandos de Docker Compose
- depends_on y orden de inicio

🧪 **Práctica:**
- Crear tu primer docker-compose.yml
- Stack multi-contenedor (nginx + app)
- Conectar contenedores entre sí

🎯 **Objetivo:** Orquestar múltiples contenedores

---

### [Lección 4: Variables de Entorno](./04-variables-entorno)
**Duración:** 30 minutos | **Dificultad:** ⭐

📖 **Aprenderás:**
- ¿Qué son las variables de entorno?
- Archivos .env y .env.example
- Secretos y seguridad
- Local vs Producción
- .gitignore y seguridad

🧪 **Práctica:**
- Crear archivo .env
- Usar variables en docker-compose
- Separar configuración local/prod

🎯 **Objetivo:** Configurar aplicaciones de forma segura

---

## 🟡 NIVEL INTERMEDIO: Implementation

### [Lección 5: Arquitectura de n8n](./05-arquitectura-n8n)
**Duración:** 1 hora | **Dificultad:** ⭐⭐

📖 **Aprenderás:**
- Componentes de n8n (Web + Workers)
- El problema del threading explicado
- Queue Mode vs Main Mode
- Por qué Redis es necesario
- Diagrama de arquitectura completo

🧪 **Práctica:**
- Analizar diagramas de arquitectura
- Comparar Main Mode vs Queue Mode
- Identificar cuellos de botella

🎯 **Objetivo:** Entender cómo funciona n8n internamente

---

### [Lección 6: PostgreSQL para n8n](./06-postgresql)
**Duración:** 1 hora | **Dificultad:** ⭐⭐

📖 **Aprenderás:**
- ¿Por qué n8n necesita una base de datos?
- PostgreSQL vs SQLite vs MySQL
- Configuración de PostgreSQL para n8n
- Conexión y verificación
- Backups básicos de PostgreSQL

🧪 **Práctica:**
- Levantar PostgreSQL con Docker
- Conectar a PostgreSQL con CLI
- Ver tablas de n8n
- Hacer un backup manual

🎯 **Objetivo:** Configurar y gestionar PostgreSQL

---

### [Lección 7: Redis y Queue Mode](./07-redis-queue)
**Duración:** 1 hora | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- ¿Qué es Redis y por qué es rápido?
- Colas de trabajos explicadas
- Workers y paralelismo
- Escalado horizontal de workers
- Monitoreo de colas

🧪 **Práctica:**
- Levantar Redis con Docker
- Conectar a Redis con redis-cli
- Ver colas de n8n
- Simular carga de trabajo

🎯 **Objetivo:** Dominar Queue Mode con Redis

---

### [Lección 8: Setup Local Completo](./08-setup-local)
**Duración:** 2 horas | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- Arquitectura local completa
- docker-compose.local.yml explicado
- Debugging y logs efectivos
- Troubleshooting común
- Workflow de desarrollo

🧪 **Práctica:**
- Configurar n8n completo en local
- Crear y ejecutar workflows
- Debugging de problemas
- Exportar/importar workflows

🎯 **Objetivo:** n8n funcionando 100% en local

---

## 🔴 NIVEL AVANZADO: Production

### [Lección 9: Preparación para Producción](./09-preparacion-prod)
**Duración:** 1 hora | **Dificultad:** ⭐⭐

📖 **Aprenderás:**
- Diferencias críticas local vs producción
- Requisitos del servidor (VPS)
- Proveedores recomendados
- Estimación de costos
- Checklist de seguridad

🧪 **Práctica:**
- Comparar proveedores de VPS
- Calcular recursos necesarios
- Revisar checklist de seguridad

🎯 **Objetivo:** Planificar deploy a producción

---

### [Lección 10: Deploy a Producción](./10-deploy-produccion)
**Duración:** 2 horas | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- Configurar servidor (VPS) desde cero
- docker-compose.prod.yml explicado
- Configuración de seguridad
- Firewall y puertos
- Primeros pasos en producción

🧪 **Práctica:**
- Configurar un VPS
- Instalar Docker en servidor
- Desplegar n8n en producción
- Verificar que funciona

🎯 **Objetivo:** n8n corriendo en producción

---

### [Lección 11: Nginx y HTTPS](./11-nginx-https)
**Duración:** 1.5 horas | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- ¿Qué es un reverse proxy?
- Configurar Nginx para n8n
- SSL/TLS con Let's Encrypt
- Renovación automática de certificados
- Configuración de seguridad

🧪 **Práctica:**
- Configurar Nginx
- Obtener certificado SSL
- HTTPS funcionando
- Redirección HTTP → HTTPS

🎯 **Objetivo:** n8n accesible por HTTPS

---

### [Lección 12: CI/CD con GitHub Actions](./12-cicd)
**Duración:** 2 horas | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- ¿Qué es CI/CD y por qué usarlo?
- GitHub Actions explicado
- Workflows de deploy
- SSH keys y seguridad
- Estrategias de rollback

🧪 **Práctica:**
- Configurar GitHub Actions
- Push to deploy automático
- Testing de deploys
- Simular rollback

🎯 **Objetivo:** Deploy automático con git push

---

## 🟣 NIVEL EXPERTO: Operations

### [Lección 13: Monitoreo y Logs](./13-monitoreo)
**Duración:** 1 hora | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- Logs de Docker
- docker stats y monitoring
- Health checks avanzados
- Alertas básicas
- Debugging en producción

🧪 **Práctica:**
- Configurar health checks
- Crear dashboard de monitoreo
- Simular y detectar problemas

🎯 **Objetivo:** Monitorear n8n en producción

---

### [Lección 14: Backups y Recuperación](./14-backups)
**Duración:** 1.5 horas | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- Estrategias de backup (3-2-1)
- Backups automáticos de PostgreSQL
- Disaster recovery planning
- Testing de backups
- Retención de backups

🧪 **Práctica:**
- Configurar backups automáticos
- Simular pérdida de datos
- Recuperar desde backup
- Documentar proceso

🎯 **Objetivo:** Sistema robusto de backups

---

### [Lección 15: Escalado y Performance](./15-escalado)
**Duración:** 2 horas | **Dificultad:** ⭐⭐⭐⭐

📖 **Aprenderás:**
- Escalar workers horizontalmente
- Optimización de PostgreSQL
- Redis tuning
- Load testing
- Identificar cuellos de botella

🧪 **Práctica:**
- Escalar a 5+ workers
- Load testing con herramientas
- Optimizar configuración
- Medir mejoras

🎯 **Objetivo:** n8n optimizado y escalado

---

### [Lección 16: Troubleshooting Avanzado](./16-troubleshooting)
**Duración:** 1 hora | **Dificultad:** ⭐⭐⭐

📖 **Aprenderás:**
- Problemas comunes y soluciones
- Debugging profundo
- Análisis de logs
- Performance issues
- Recovery de situaciones críticas

🧪 **Práctica:**
- Casos de troubleshooting reales
- Debugging en vivo
- Crear runbook de problemas

🎯 **Objetivo:** Resolver cualquier problema

---

## 🏆 PROYECTO FINAL

### [Proyecto: Deploy Profesional Completo](../projects/final-project)
**Duración:** 4-6 horas | **Dificultad:** ⭐⭐⭐⭐

🎯 **Objetivo:**
Desplegar n8n de manera 100% profesional desde cero.

**Incluye:**
- Setup desde cero en VPS
- PostgreSQL + Redis
- Queue Mode con 3 workers
- HTTPS con certificado válido
- CI/CD automático
- Backups automáticos
- Monitoreo básico
- Documentación completa

**Entregables:**
- Repositorio en GitHub
- n8n funcionando en producción
- Documentación del proceso
- Runbook de operaciones

---

## 📊 Progreso Recomendado

### Semana 1: Foundations
- [ ] Lección 1: Fundamentos
- [ ] Lección 2: Docker Basics
- [ ] Lección 3: Docker Compose
- [ ] Lección 4: Variables de Entorno

### Semana 2: Implementation
- [ ] Lección 5: Arquitectura n8n
- [ ] Lección 6: PostgreSQL
- [ ] Lección 7: Redis y Queue
- [ ] Lección 8: Setup Local

### Semana 3: Production
- [ ] Lección 9: Preparación
- [ ] Lección 10: Deploy Producción
- [ ] Lección 11: Nginx y HTTPS
- [ ] Lección 12: CI/CD

### Semana 4: Operations & Proyecto
- [ ] Lección 13: Monitoreo
- [ ] Lección 14: Backups
- [ ] Lección 15: Escalado
- [ ] Lección 16: Troubleshooting
- [ ] Proyecto Final

---

## 🎓 Certificación

Al completar todas las lecciones y el proyecto final:
- ✅ Conocimientos demostrables de n8n
- ✅ Portafolio en GitHub
- ✅ n8n en producción funcionando
- ✅ Habilidades de DevOps aplicadas

---

**¡Empieza por la [Lección 1: Fundamentos](./01-foundations)!**

