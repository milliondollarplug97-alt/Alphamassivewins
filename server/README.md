QuickCash WhatsApp Server (Twilio example)

Setup
1. Copy `.env.example` to `.env` and fill in your Twilio credentials and numbers.
2. Install dependencies:

```bash
cd server
npm install
```

3. Run server:

```bash
npm start
```

Local testing
- If you run client `home.html` from file://, fetch to `http://localhost:3000/api/send` will be blocked by CORS or mixed-context issues; use a local static server (see below) or open `home.html` via `http://localhost:5500` (VS Code Live Server) or similar.
- For testing from a remote device, expose your local server with `ngrok http 3000` and set the client to POST to that URL.

Notes
- This example uses Twilio to send WhatsApp messages. Twilio requires setup (WhatsApp sandbox or approved business number).
- For production use, secure the endpoint (authentication, input validation), and follow data privacy and consent requirements.
