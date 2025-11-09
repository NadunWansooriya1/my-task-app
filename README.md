# 📝 Task Management Application

A full-stack task management application with JWT authentication, built with Spring Boot, React, and PostgreSQL.

## 🏗️ Architecture

- **Frontend**: React 19 + TypeScript + Material-UI
- **Backend**: Spring Boot 3.5.7 + Spring Security + JWT
- **Database**: PostgreSQL 15
- **Deployment**: Docker + Docker Compose

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed and running
- At least 4GB RAM available
- Ports 3000, 8080, and 5432 available

### One-Command Deployment

**PowerShell (Windows):**
```powershell
.\deploy.ps1
```

**Bash (Linux/Mac):**
```bash
./deploy.sh
```

### Manual Deployment

```bash
# Stop existing containers
docker compose down

# Build and start all services
docker compose up -d --build

# Check status
docker compose ps

# View logs
docker compose logs -f
```

## 🌐 Access the Application

- **Frontend**: [http://localhost:3000](http://localhost:3000)
- **Backend API**: [http://localhost:8080](http://localhost:8080)
- **Health Check**: [http://localhost:8080/actuator/health](http://localhost:8080/actuator/health)

## 🔑 Login Credentials

- **Username**: `admin`
- **Password**: Any non-empty string (JWT-based authentication)

## 📚 Project Structure

```
my-task-app/
├── todo-api/               # Spring Boot Backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/.../todo_api/
│   │   │   │   ├── config/         # CORS & Security config
│   │   │   │   ├── controller/     # REST endpoints
│   │   │   │   ├── model/          # JPA entities
│   │   │   │   ├── repository/     # Data access
│   │   │   │   └── security/       # JWT & Security
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/
│   ├── Dockerfile
│   └── pom.xml
├── todo-frontend/          # React Frontend
│   ├── src/
│   │   ├── App.tsx         # Main app component
│   │   ├── Login.tsx       # Login page
│   │   ├── TaskList.tsx    # Task management UI
│   │   └── config.ts       # API configuration
│   ├── public/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── docker-compose.yml      # Multi-container orchestration
├── init-db.sql            # Database initialization
├── deploy.ps1             # Windows deployment script
├── deploy.sh              # Linux/Mac deployment script
├── DEPLOYMENT_GUIDE.md    # Detailed deployment guide
└── README.md              # This file
```

## 🔧 Features

- ✅ JWT-based authentication
- ✅ CRUD operations for tasks
- ✅ Date-based task management
- ✅ Responsive Material-UI design
- ✅ Docker containerization
- ✅ Health checks and monitoring
- ✅ PostgreSQL data persistence
- ✅ CORS configuration
- ✅ Multi-stage Docker builds

## 📖 API Endpoints

### Authentication
- `POST /api/auth/login` - User login (returns JWT token)

### Tasks
- `GET /api/tasks` - Get all tasks
- `GET /api/tasks/{id}` - Get task by ID
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task

### Monitoring
- `GET /actuator/health` - Health check
- `GET /actuator/info` - Application info
- `GET /actuator/prometheus` - Prometheus metrics

## 🛠️ Development

### Backend Development
```bash
cd todo-api
./mvnw spring-boot:run
```

### Frontend Development
```bash
cd todo-frontend
npm install
npm start
```

### Run Tests
```bash
# Backend tests
cd todo-api
./mvnw test

# Frontend tests
cd todo-frontend
npm test
```

## 🐳 Docker Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f [service-name]

# Rebuild specific service
docker compose up -d --build [service-name]

# Check status
docker compose ps

# Resource usage
docker stats
```

## 🔒 Security Features

- JWT token-based authentication
- Password authentication (extensible to bcrypt)
- CORS protection
- SQL injection prevention (JPA)
- XSS protection headers
- Health check endpoints

## 🌍 Environment Variables

### Backend (application.properties)
```properties
spring.datasource.url=jdbc:postgresql://postgres:5432/taskdb
spring.datasource.username=admin
spring.datasource.password=admin
jwt.secret=your-secure-secret-key-256bit-minimum
```

### Frontend (.env)
```properties
REACT_APP_API_URL=http://localhost:8080
```

## 📊 Database Schema

```sql
CREATE TABLE task (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT false,
    user_id VARCHAR(50),
    task_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🚨 Troubleshooting

### Backend won't start
```bash
docker compose logs backend
docker compose restart postgres
```

### Frontend can't connect to backend
1. Check backend health: `curl http://localhost:8080/actuator/health`
2. Check CORS settings in `WebConfig.java`
3. Verify API_URL in browser console

### Port already in use
```powershell
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
sudo lsof -i :8080
kill -9 <PID>
```

### Database issues
```bash
# Access database
docker exec -it postgres psql -U admin -d taskdb

# View tables
\dt

# Check data
SELECT * FROM task;
```

## 📈 Performance Tips

- Use connection pooling for database
- Enable response caching
- Optimize Docker image sizes
- Use nginx compression
- Set proper JVM heap sizes

## 🔄 Updates and Maintenance

### Update application
```bash
git pull origin main
docker compose down
docker compose up -d --build
```

### Backup database
```bash
docker exec postgres pg_dump -U admin taskdb > backup.sql
```

### Restore database
```bash
cat backup.sql | docker exec -i postgres psql -U admin -d taskdb
```

## 📝 Configuration for Production

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed production deployment instructions, including:
- Firewall configuration
- SSL/HTTPS setup
- Security hardening
- Monitoring setup
- Backup strategies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is for educational/demonstration purposes.

## 👨‍💻 Tech Stack

- **Frontend**: React 19, TypeScript, Material-UI, Axios
- **Backend**: Spring Boot 3.5.7, Spring Security, Spring Data JPA
- **Security**: JWT (jjwt 0.12.6)
- **Database**: PostgreSQL 15
- **Container**: Docker, Docker Compose
- **Build**: Maven, npm
- **Web Server**: Nginx (for frontend)

## 📞 Support

For issues or questions:
1. Check logs: `docker compose logs`
2. Review DEPLOYMENT_GUIDE.md
3. Check GitHub Issues
