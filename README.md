# 🎒 PackMin2

AI-powered packing list generator with capsule wardrobe principles. Web version with multi-user support.

## Features

- 🔐 **Google OAuth** - Sign in with your Google account
- 🤖 **Multiple AI Providers** - DeepSeek, OpenAI, Gemini, or Anthropic
- 🌤️ **Weather-Aware** - Fetches forecasts for accurate packing
- 📱 **Mobile-First** - Responsive design for all devices
- 📍 **Saved Locations** - Quick access to frequent destinations
- 🎒 **Custom Items** - Your must-pack essentials
- 🔄 **Capsule Wardrobe** - Maximum versatility, minimal items

## Quick Start (Docker)

### 1. Clone the repository

```bash
git clone https://github.com/min-hsao/packmin2.git
cd packmin2
```

### 2. Create environment file

```bash
cp .env.example .env
```

Edit `.env` and set:
- `SECRET_KEY_BASE` - Generate with: `openssl rand -hex 64`
- `GOOGLE_CLIENT_ID` - From Google Cloud Console
- `GOOGLE_CLIENT_SECRET` - From Google Cloud Console
- `DB_PASSWORD` - Choose a secure password

### 3. Get Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Create a new OAuth 2.0 Client ID
3. Set authorized redirect URI: `http://YOUR_HOST:3000/users/auth/google_oauth2/callback`
4. Copy Client ID and Secret to `.env`

### 4. Start the app

```bash
docker-compose up -d
```

The app will be available at `http://localhost:3000`

### 5. View logs

```bash
docker-compose logs -f web
```

## Synology NAS Deployment

### Option 1: SSH + Docker Compose

```bash
# SSH into your NAS
ssh admin@your-nas-ip

# Clone repo
git clone https://github.com/min-hsao/packmin2.git /volume1/docker/packmin2
cd /volume1/docker/packmin2

# Create .env file
cp .env.example .env
nano .env  # Edit with your values

# Start
docker-compose up -d
```

### Option 2: Container Manager UI

1. Open Container Manager in DSM
2. Go to Project → Create
3. Set project path to where you cloned the repo
4. Select docker-compose.yml
5. Add environment variables in the UI
6. Build and Start

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `SECRET_KEY_BASE` | Yes | Rails secret key (64+ hex chars) |
| `GOOGLE_CLIENT_ID` | Yes | Google OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | Yes | Google OAuth client secret |
| `DB_PASSWORD` | Yes | PostgreSQL password |
| `PORT` | No | Port to expose (default: 3000) |

## User Setup

After signing in with Google for the first time, you'll be prompted to:

1. **Choose AI Provider** - Select from DeepSeek, OpenAI, Gemini, or Anthropic
2. **Enter API Key** - Your AI provider's API key (encrypted in database)
3. **Weather API** (optional) - OpenWeatherMap API key for forecasts
4. **Traveler Defaults** - Pre-fill your typical travel profile

## Development

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Start development server
rails server
```

## Tech Stack

- Ruby 3.3 / Rails 7.1
- PostgreSQL 16
- Tailwind CSS
- Hotwire (Turbo + Stimulus)
- Docker

## License

MIT
