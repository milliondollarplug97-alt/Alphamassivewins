require('dotenv').config();
const express = require('express');
const cors = require('cors');
const twilio = require('twilio');

const app = express();
app.use(cors());
app.use(express.json());

// Serve the static website located in the parent folder of server/
const path = require('path');
const siteRoot = path.resolve(__dirname, '..');
app.use(express.static(siteRoot));

const PORT = process.env.PORT || 3000;
const ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID;
const AUTH_TOKEN = process.env.TWILIO_AUTH_TOKEN;
const FROM = process.env.TWILIO_WHATSAPP_FROM; // e.g. 'whatsapp:+14155238886'
const TO = process.env.RECIPIENT_WHATSAPP_TO; // e.g. 'whatsapp:+14192311363'

if (!ACCOUNT_SID || !AUTH_TOKEN || !FROM || !TO) {
  console.warn('Twilio credentials or numbers not fully configured. See .env.example');
}

const client = twilio(ACCOUNT_SID, AUTH_TOKEN);

app.post('/api/send', async (req, res) => {
  const { name, phone, dob, email, preferredGame, deposit } = req.body || {};
  if (!name || !phone || (typeof deposit === 'undefined')) {
    return res.status(400).json({ ok: false, error: 'Missing required fields' });
  }

  const messageBody = `New Registration\n\nName: ${name}\nPhone: ${phone}\nDOB: ${dob || 'N/A'}\nPreferred Game: ${preferredGame || 'N/A'}\nEmail: ${email || 'N/A'}\nDeposit: ${deposit}`;

  try {
    if (!ACCOUNT_SID || !AUTH_TOKEN || !FROM || !TO) {
      // If credentials not set, return success=false but echo message for testing
      return res.status(500).json({ ok: false, error: 'Server not configured with Twilio credentials', message: messageBody });
    }

    const msg = await client.messages.create({
      from: FROM,
      to: TO,
      body: messageBody
    });
    return res.json({ ok: true, sid: msg.sid });
  } catch (err) {
    console.error('Error sending Twilio message', err);
    return res.status(500).json({ ok: false, error: err.message });
  }
});

app.get('/', (req, res) => res.send('QuickCash WhatsApp server running'));

// Bind to 0.0.0.0 so it's accessible from other devices on the LAN
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server listening on port ${PORT}`);
  try {
    const os = require('os');
    const nets = os.networkInterfaces();
    const addresses = [];
    Object.keys(nets).forEach((name) => {
      for (const net of nets[name]) {
        if (net.family === 'IPv4' && !net.internal) addresses.push(net.address);
      }
    });
    if (addresses.length) {
      console.log('Accessible on your LAN at:');
      addresses.forEach(a => console.log(`  http://${a}:${PORT}/`));
    }
  } catch (e) { /* ignore */ }
});
