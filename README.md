# 🎓 Zero to Hero: n8n Engineer

> De cero a experto en implementación y deployment de n8n

## 🎯 ¿Qué vas a aprender?

Este curso te enseña a **implementar, configurar y desplegar** n8n de manera profesional. NO es un curso de cómo usar n8n (eso es ZTH: n8n Developer), sino de cómo ser el **ingeniero** que lo instala y mantiene.

### Al finalizar sabrás:

✅ Qué es Docker y por qué es fundamental
✅ Cómo funciona Docker Compose
✅ La arquitectura interna de n8n
✅ Por qué n8n necesita Redis y PostgreSQL
✅ Configurar n8n en local para desarrollo
✅ Desplegar n8n en producción (VPS)
✅ Configurar SSL/HTTPS
✅ Implementar CI/CD automático
✅ Monitorear y mantener n8n en producción
✅ Troubleshooting de problemas comunes
✅ Backups y disaster recovery

---

## 📚 Estructura del Curso

### 🟢 Nivel Principiante (Foundations)

**Lección 1: Fundamentos - ¿Qué es n8n?**
- Qué es n8n y para qué sirve
- Casos de uso reales
- Arquitectura general
- Diferencia entre usar vs implementar
- 📖 Duración: 30 minutos

**Lección 2: Docker Desde Cero**
- ¿Qué es un contenedor?
- ¿Por qué Docker?
- Imágenes vs Contenedores
- Tu primer contenedor
- 📖 Duración: 1 hora
- 🧪 Práctica: Correr tu primer contenedor

**Lección 3: Docker Compose**
- El problema de múltiples contenedores
- Sintaxis de docker-compose.yml
- Redes y volúmenes
- Comandos esenciales
- 📖 Duración: 1 hora
- 🧪 Práctica: Stack multi-contenedor

**Lección 4: Variables de Entorno**
- ¿Qué son y por qué existen?
- Archivos .env
- Secretos y seguridad
- Local vs Producción
- 📖 Duración: 30 minutos
- 🧪 Práctica: Configurar .env

### 🟡 Nivel Intermedio (Implementation)

**Lección 5: Arquitectura de n8n**
- Componentes de n8n
- El problema del threading
- Queue Mode explicado
- Diagrama completo
- 📖 Duración: 1 hora

**Lección 6: PostgreSQL para n8n**
- ¿Por qué una base de datos?
- PostgreSQL vs SQLite vs MySQL
- Configuración para n8n
- Backups de PostgreSQL
- 📖 Duración: 1 hora
- 🧪 Práctica: Conectar n8n a PostgreSQL

**Lección 7: Redis y Queue Mode**
- ¿Qué es Redis?
- Colas de trabajos
- Workers explicados
- Escalado horizontal
- 📖 Duración: 1 hora
- 🧪 Práctica: Configurar Queue Mode

**Lección 8: Setup Local Completo**
- Arquitectura local
- docker-compose.local.yml
- Debugging y logs
- Troubleshooting común
- 📖 Duración: 2 horas
- 🧪 Práctica: n8n funcionando en local

### 🔴 Nivel Avanzado (Production)

**Lección 9: Preparación para Producción**
- Diferencias local vs producción
- Requisitos del servidor
- Proveedores de VPS
- Costos estimados
- Checklist de seguridad
- 📖 Duración: 1 hora

**Lección 10: Deploy a Producción**
- Configurar servidor (VPS)
- docker-compose.prod.yml
- Configuración de seguridad
- Primeros pasos en producción
- 📖 Duración: 2 horas
- 🧪 Práctica: n8n en producción

**Lección 11: Nginx y HTTPS**
- ¿Qué es un reverse proxy?
- Configurar Nginx
- SSL con Let's Encrypt
- Renovación automática
- 📖 Duración: 1.5 horas
- 🧪 Práctica: HTTPS funcionando

**Lección 12: CI/CD con GitHub Actions**
- ¿Qué es CI/CD?
- GitHub Actions explicado
- Deploy automático
- Rollback strategies
- 📖 Duración: 2 horas
- 🧪 Práctica: Push to deploy

### 🟣 Nivel Experto (Operations)

**Lección 13: Monitoreo y Logs**
- Logs de Docker
- Monitoring con Docker stats
- Alertas básicas
- Health checks
- 📖 Duración: 1 hora
- 🧪 Práctica: Dashboard de monitoreo

**Lección 14: Backups y Recuperación**
- Estrategias de backup
- Backups automáticos
- Disaster recovery
- Testing de backups
- 📖 Duración: 1.5 horas
- 🧪 Práctica: Plan de backup

**Lección 15: Escalado y Performance**
- Escalar workers
- Optimización de PostgreSQL
- Redis tuning
- Load testing
- 📖 Duración: 2 horas
- 🧪 Práctica: Escalar n8n

**Lección 16: Troubleshooting Avanzado**
- Problemas comunes
- Debugging profundo
- Logs analysis
- Performance issues
- 📖 Duración: 1 hora

### 🏆 Proyecto Final

**Proyecto: Deploy Completo Profesional**
- Setup desde cero
- Producción con HTTPS
- CI/CD configurado
- Monitoring activo
- Documentación completa
- 📖 Duración: 4-6 horas

---

## 🗺️ Roadmap de Aprendizaje

### Path 1: Rápido (2-3 días intensivos)
```
Día 1: Lecciones 1-4 (Foundations)
Día 2: Lecciones 5-8 (Implementation)
Día 3: Lecciones 9-12 (Production)
```

### Path 2: Pausado (2 semanas, 1-2 horas/día)
```
Semana 1: Foundations + Implementation
Semana 2: Production + Operations
```

### Path 3: Profundo (1 mes, práctica extensa)
```
Semana 1: Lecciones 1-4 + ejercicios
Semana 2: Lecciones 5-8 + proyecto intermedio
Semana 3: Lecciones 9-12 + deploy real
Semana 4: Lecciones 13-16 + proyecto final
```

---

## 📦 Requisitos Previos

### Conocimientos
- [ ] Uso básico de terminal/línea de comandos
- [ ] Conceptos básicos de redes (IP, puertos, DNS)
- [ ] (Opcional) Experiencia con Linux

### Software Necesario
- [ ] Docker Desktop instalado
- [ ] Editor de código (VS Code recomendado)
- [ ] Git instalado
- [ ] Terminal (bash/zsh)

### Recursos
- [ ] Cuenta de GitHub
- [ ] (Para producción) VPS o servidor
- [ ] (Opcional) Dominio propio

---

## 🎯 Cómo Usar Este Curso

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/ZTH-n8n-Engineer.git
cd ZTH-n8n-Engineer
```

### 2. Seguir las Lecciones en Orden
```bash
cd lessons/01-foundations
# Leer README.md
# Hacer ejercicios prácticos
```

### 3. Hacer los Ejercicios
Cada lección tiene una carpeta `practica/` con ejercicios.

### 4. Proyecto Final
Al terminar todas las lecciones, completa el proyecto final.

---

## 📂 Estructura del Repositorio

```
ZTH-n8n-Engineer/
├── README.md                    # Este archivo
├── lessons/                     # Todas las lecciones
│   ├── 01-foundations/
│   │   ├── README.md           # Teoría de la lección
│   │   ├── practica/           # Ejercicios prácticos
│   │   └── recursos/           # Archivos adicionales
│   ├── 02-docker-basics/
│   ├── 03-docker-compose/
│   └── ...
├── resources/                   # Recursos compartidos
│   ├── diagrams/               # Diagramas y gráficos
│   ├── scripts/                # Scripts útiles
│   ├── templates/              # Plantillas reutilizables
│   └── cheatsheets/            # Hojas de referencia rápida
├── projects/                    # Proyectos prácticos
│   ├── final-project/          # Proyecto final del curso
│   └── mini-projects/          # Mini proyectos por módulo
└── solutions/                   # Soluciones a ejercicios
    └── (ocultas hasta que termines)
```

---

## 🎓 Metodología de Enseñanza

Cada lección sigue esta estructura:

### 1. 🎯 Objetivos
Lo que aprenderás en esta lección.

### 2. 📖 Teoría
Conceptos explicados con:
- Analogías del mundo real
- Diagramas visuales
- Ejemplos prácticos
- Comparaciones antes/después

### 3. 🧪 Práctica Guiada
Ejercicios paso a paso donde:
- Explico QUÉ estás haciendo
- Explico POR QUÉ lo estás haciendo
- Muestro el resultado esperado

### 4. 💪 Ejercicios Independientes
Desafíos para que practiques solo.

### 5. ✅ Checklist
Verificas que entendiste todo antes de continuar.

### 6. 🔗 Recursos Adicionales
Links, videos, documentación para profundizar.

---

## 🏅 Certificación (Informal)

Al completar el curso y el proyecto final:
1. Tendrás un portafolio en GitHub
2. n8n funcionando en producción
3. Conocimientos demostrables
4. Puedes agregar a tu CV: "n8n Infrastructure Engineer"

---

## 🤝 Contribuciones

Este es un curso abierto. Si encuentras:
- Errores
- Mejoras
- Temas adicionales

¡Abre un issue o PR!

---

## 📞 Soporte

- **Issues**: Para bugs o dudas técnicas
- **Discussions**: Para preguntas generales
- **Discord**: [Link a comunidad] (próximamente)

---

## 📄 Licencia

MIT License - Úsalo, modifícalo, compártelo.

---

## 🚀 ¡Empecemos!

```bash
# Siguiente paso:
cd lessons/01-foundations
cat README.md
```

**¡Nos vemos en la lección 1!** 🎉

---

## 🗺️ Cursos Relacionados

- **ZTH: n8n Developer** (próximamente) - Cómo USAR n8n para crear automatizaciones
- **ZTH: n8n Advanced** (próximamente) - Custom nodes, integraciones avanzadas
- **ZTH: Docker Mastery** - Profundiza en Docker y Kubernetes

---

**Creado con ❤️ para la comunidad de n8n**

_Última actualización: Noviembre 2024_

