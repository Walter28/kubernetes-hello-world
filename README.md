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

## How it works

1. React frontend makes a GET request to `/api/hello`
2. Node.js backend responds with a JSON message
3. Frontend displays the message

Simple as that!
