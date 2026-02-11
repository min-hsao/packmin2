# PackMin2 🎒

AI-powered packing list generator built with Ruby on Rails 7.1.

## Features

- **AI Generation**: Uses DeepSeek, OpenAI, Gemini, or Anthropic to create tailored packing lists.
- **Context Aware**: Considers destination weather, trip duration, activities, and luggage constraints.
- **Personalized**: Remembers your gender, sizes, and preferences.
- **Custom Items**: Add items you always want to pack.
- **Saved Locations**: Quick access to frequent destinations.

## Tech Stack

- **Backend**: Ruby 3.3, Rails 7.1
- **Database**: MariaDB (External)
- **Frontend**: Tailwind CSS, Hotwire/Turbo
- **Infrastructure**: Docker, Docker Compose

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/min-hsao/packmin2.git
   cd packmin2
   ```

2. **Configure Environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Google OAuth Setup:**
   - Create a project in Google Cloud Console.
   - Enable Google+ API / People API.
   - Create OAuth credentials.
   - Add authorized redirect URI: `http://localhost:3000/auth/google_oauth2/callback`

4. **Run with Docker:**
   ```bash
   docker-compose up --build
   ```

5. **First Login:**
   - Go to `http://localhost:3000`
   - Sign in with Google
   - Complete the setup wizard (choose AI provider, enter API keys)

## Development

To run locally without Docker:

```bash
bundle install
bin/rails db:create db:migrate
bin/rails server
```
