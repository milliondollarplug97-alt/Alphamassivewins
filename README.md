# Local Development & Phone Testing

This project contains a static website at the repository root and an optional Express server in `server/` for serving files locally.

Goal: run the server so your phone can access the site over the local network (LAN).

Requirements
- Node.js (16+ recommended) OR use the PowerShell server script (no Node needed)

Quick start (PowerShell server - no Node needed)
1. Open PowerShell and navigate to the `server` folder:

```powershell
cd "c:\Users\PC\Desktop\website\server"
.\serve.ps1 -Port 3000
```

2. Note the printed LAN URL (e.g., `http://192.168.1.42:3000/`) and open it on your phone (phone and PC must be on the same Wi‑Fi).

Quick start (with Node.js)
1. Open a terminal and change to the `server` folder:

```bash
cd "c:\Users\PC\Desktop\website\server"
```

2. Install dependencies (only needed once):

```bash
npm install
```

3. Start the server:

```bash
npm start
```

The server will:
- Serve the static files from the project root.
- Listen on `0.0.0.0` so other devices on the same Wi‑Fi can reach it.
- Print LAN URLs after startup (e.g., `http://192.168.1.42:3000/`).

How to find your PC IP (alternative):
- On Windows, run `ipconfig` and look for the IPv4 address for your active adapter.

How it works
1. Fill out the signup form on `home.html`.
2. Enter a PIN on `login.html`.
3. The app redirects to WhatsApp with the application details (via wa.me link).

The site is fully static — no backend or Twilio needed. Everything runs on the frontend.