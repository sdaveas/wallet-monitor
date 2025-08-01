# Wallet Monitor

A cryptocurrency wallet monitoring system that tracks balance changes for Axelar network addresses and sends Telegram notifications when changes are detected.

## Features

- **Real-time monitoring**: Continuously monitors wallet balance changes every 10 seconds
- **Telegram notifications**: Sends instant alerts via Telegram bot when balance changes
- **Cross-platform support**: Works on both macOS and Linux (with Docker)
- **File-based change detection**: Uses filesystem monitoring for efficient change detection
- **Detailed balance tracking**: Monitors both available and delegated AXL tokens

## Prerequisites

- Bash shell
- Docker and Docker Compose (for containerized deployment)
- Telegram Bot Token and Chat ID (for notifications)

### Local Dependencies (if running without Docker)

- `curl` - for API requests
- `jq` - for JSON processing
- `bc` - for arithmetic calculations
- `fswatch` (macOS) or `inotify-tools` (Linux) - for file monitoring

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wallet-monitor
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```

3. **Configure environment variables**
   Edit the `.env` file with your settings:
   ```env
   ADDRESS=your_axelar_wallet_address
   BOT_TOKEN=your_telegram_bot_token
   CHAT_ID=your_telegram_chat_id
   ```

### Getting Telegram Credentials

1. **Create a Telegram Bot**:
   - Message [@BotFather](https://t.me/botfather) on Telegram
   - Use `/newbot` command and follow instructions
   - Save the Bot Token

2. **Get Chat ID**:
   - Start a chat with your bot
   - Send a message to your bot
   - Visit `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
   - Find your chat ID in the response

## Usage

### Docker Deployment (Recommended)

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down
```

### Local Execution

```bash
# Make scripts executable
chmod +x *.sh

# Start monitoring
./job.sh
```

## How It Works

1. **[`monitor.sh`](monitor.sh)** - Fetches wallet balance data from Axelar RPC endpoint every 10 seconds
2. **[`alert.sh`](alert.sh)** / **[`alert-linux.sh`](alert-linux.sh)** - Watches for file changes indicating balance updates
3. **[`text.sh`](text.sh)** - Sends Telegram notifications when changes are detected
4. **[`job.sh`](job.sh)** - Orchestrates the monitoring and alerting processes

### File Structure

```
.
├── alert.sh           # macOS file monitoring script
├── alert-linux.sh     # Linux file monitoring script  
├── job.sh             # Main orchestration script
├── monitor.sh         # Balance monitoring script
├── text.sh            # Telegram notification script
├── Dockerfile         # Container configuration
├── docker-compose.yml # Docker Compose setup
├── .env               # Environment variables (create from template)
├── .gitignore         # Git ignore rules
└── data/              # Directory for storing balance data
    └── .gitkeep       # Keeps data directory in git
```

## Monitoring Details

The system tracks:
- **Available AXL**: Liquid tokens in the wallet
- **Delegated AXL**: Tokens staked/delegated to validators
- **Total AXL**: Sum of available and delegated tokens

Balance data is fetched from the Lavender Five RPC endpoint and compared against previous readings to detect changes.

## Troubleshooting

### Common Issues

1. **RPC Rate Limits**: If you see rate limit errors, the script will exit with an error message
2. **Missing Environment Variables**: Ensure all required variables are set in `.env`
3. **Permission Errors**: Make sure scripts are executable (`chmod +x *.sh`)

### Logs and Debugging

- Check Docker logs: `docker-compose logs -f`
- Monitor file changes in the `data/` directory
- Verify Telegram bot configuration by testing [`text.sh`](text.sh) manually

## Security Notes

- Keep your `.env` file secure and never commit it to version control
- The `.env` file is already included in [`.gitignore`](.gitignore)
- Consider using environment variables or secrets management in production

## License

[Add your license here]