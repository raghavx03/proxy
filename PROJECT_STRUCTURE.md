# Free Claude Code - Project Structure

## Overview
A production-grade proxy server for NVIDIA NIM APIs with Claude Code integration, supporting multiple AI providers and intelligent routing.

## 📁 Directory Structure

```
free-claude-code/
├── 📁 api/                    # REST API layer
│   ├── __init__.py
│   ├── app.py                # FastAPI application
│   ├── routes.py             # API endpoints
│   ├── dependencies.py       # Dependency injection
│   ├── detection.py          # Model detection utilities
│   ├── optimization_handlers.py # Request optimization
│   ├── request_utils.py      # HTTP utilities
│   └── command_utils.py      # CLI utilities
├── 📁 cli/                   # Command-line interface
│   ├── __init__.py
│   ├── entrypoints.py        # CLI commands
│   ├── manager.py            # Process management
│   ├── process_registry.py   # Process tracking
│   └── session.py            # Session management
├── 📁 config/                # Configuration management
│   ├── __init__.py
│   ├── settings.py           # Main settings
│   ├── nim.py               # NVIDIA NIM configuration
│   └── logging_config.py     # Logging configuration
├── 📁 messaging/             # Message handling & protocols
│   ├── __init__.py
│   ├── models.py            # Data models
│   ├── handler.py           # Message handlers
│   ├── commands.py          # Command processing
│   ├── session.py           # Session management
│   ├── limiter.py          # Rate limiting
│   ├── event_parser.py      # Event parsing
│   ├── transcript.py        # Transcript handling
│   └── transcription.py     # Audio transcription
├── 📁 providers/             # AI provider integrations
│   ├── __init__.py
│   ├── base.py              # Base provider interface
│   ├── openai_compat.py     # OpenAI compatibility
│   ├── rate_limit.py        # Rate limiting
│   ├── exceptions.py        # Provider exceptions
│   ├── logging_utils.py     # Provider logging
│   ├── llama_cpp/           # Llama.cpp provider
│   ├── lmstudio/            # LM Studio provider
│   ├── nvidia_nim/          # NVIDIA NIM provider
│   └── open_router/         # Open Router provider
├── 📁 tests/                 # Test suite
│   └── conftest.py          # Test configuration
├── 📁 .github/              # GitHub workflows
├── 📁 .claude/              # Claude configuration
├── 📄 server.py            # Main server entry point
├── 📄 pyproject.toml       # Python project configuration
├── 📄 uv.lock             # Package lock file
├── 📄 README.md           # Project documentation
├── 📄 LICENSE             # MIT License
├── 📄 AGENTS.md           # Agent documentation
└── 📄 CLAUDE.md           # Claude-specific instructions
```

## 🔧 Core Components

### 1. API Layer (`api/`)
- **FastAPI-based REST API**
- **Intelligent routing** between providers
- **Rate limiting** and request optimization
- **Health monitoring** and metrics

### 2. Providers (`providers/`)
- **NVIDIA NIM** - Primary provider for Claude models
- **LM Studio** - Local model support
- **Llama.cpp** - Local inference
- **Open Router** - Multi-provider routing
- **Rate limiting** per provider

### 3. CLI (`cli/`)
- **Process management** with PM2 integration
- **Session tracking** and health checks
- **Configuration management**
- **Log monitoring**

### 4. Configuration (`config/`)
- **Environment-based settings**
- **Provider configurations**
- **Logging setup**
- **Security configurations**

### 5. Messaging (`messaging/`)
- **Protocol handlers** for Claude Code
- **Session management**
- **Rate limiting**
- **Event processing**

## 🚀 Quick Start

```bash
# Install dependencies
uv sync

# Start server
python server.py

# Or use CLI
python -m cli.entrypoints start
```

## 📊 Key Features

- **Multi-provider support** (NVIDIA NIM, LM Studio, Open Router)
- **Intelligent routing** based on model availability
- **Rate limiting** and request optimization
- **Health monitoring** and automatic failover
- **Claude Code integration** with native protocol support
- **Production-ready** with proper logging and error handling

## 🔒 Security Features

- **No hardcoded secrets** (uses environment variables)
- **Rate limiting** per provider
- **Input validation** on all endpoints
- **Error handling** without sensitive data exposure
- **Health checks** and monitoring

## 📝 Configuration

See `.env.example` for configuration options and environment variables.