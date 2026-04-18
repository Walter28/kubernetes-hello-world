# Full Stack Hello World App

Simple React + Node.js Hello World application.

## Structure

```
kubernetes-hello-world/
  client/          # React frontend
    src/
    public/
  server/          # Node.js backend
    index.js
  package.json     # Root package.json
```

## Installation

1. Install dependencies for both frontend and backend:
```bash
npm run install-all
```

## Running the Application

### Option 1: Run both frontend and backend together
```bash
npm run dev
```

### Option 2: Run separately
Backend:
```bash
npm run server
```

Frontend (in another terminal):
```bash
npm run client
```

## Endpoints

- Backend: `http://localhost:5000`
- Frontend: `http://localhost:3000`
- API: `http://localhost:5000/api/hello`

## Docker Deployment

### Prerequisites
- Docker installed
- Docker Compose installed

### Build and run with Docker Compose
```bash
# Build and start all services
docker-compose up --build

# Run in detached mode
docker-compose up -d --build

# Stop services
docker-compose down

# View logs
docker-compose logs -f
```

### Individual Docker builds
```bash
# Build backend
docker build -t hello-world-backend:latest ./server

# Build frontend
docker build -t hello-world-frontend:latest ./client

# Run backend
docker run -p 5000:5000 hello-world-backend:latest

# Run frontend (requires backend running)
docker run -p 3000:3000 hello-world-frontend:latest
```

### Docker Image Tags
- `hello-world-backend:latest` - Latest backend version
- `hello-world-backend:1.0.0` - Versioned backend
- `hello-world-frontend:latest` - Latest frontend version  
- `hello-world-frontend:1.0.0` - Versioned frontend

## Docker Features

- **Multi-stage builds** for optimized image sizes
- **Non-root users** for enhanced security
- **Health checks** for service monitoring
- **Read-only filesystems** where possible
- **Security hardening** with no-new-privileges
- **Proper tagging** with semantic versions
- **Optimized .dockerignore** files

## How it works

1. React frontend makes a GET request to `/api/hello`
2. Node.js backend responds with a JSON message
3. Frontend displays the message

Simple as that!
