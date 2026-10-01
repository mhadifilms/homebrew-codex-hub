# Codex Hub · Homebrew tap

Install [Codex Hub](https://github.com/mhadifilms/codex-hub) on macOS or Linux:

```sh
brew install mhadifilms/codex-hub/codex-hub
codex login
codex-hub
```

If Codex CLI is missing, use `brew install --cask codex` on macOS, or `npm install --global @openai/codex` on Linux (requires Node.js).

Update with `brew upgrade codex-hub`; remove with `brew uninstall codex-hub`. Configuration and chats remain in your Codex and Hub homes.

The formula installs tmux and a dedicated Python environment with checksummed dependencies. Windows users should use the [WSL installer](https://github.com/mhadifilms/codex-hub#install).

MIT licensed.
