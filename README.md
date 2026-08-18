# Kali Manager 🐉

A simple, color-coded, all-in-one terminal menu for managing common **Kali Linux** system tasks — package updates, service control, network info, and power options — without memorizing commands.

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Kali%20Linux-557C94?style=flat&logo=kalilinux&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- **System maintenance** — update, full upgrade, clean cache, autoremove, all in one menu
- **Service control** — start / stop / restart / status for Apache and PostgreSQL, plus Metasploit DB startup (auto-initializes on first run)
- **Network & system info** — IP address, routing table, public IP (with timeout), disk usage, memory usage, CPU info, running services
- **Package management** — search, install, and remove packages with input validation
- **Power controls** — reboot / shutdown with a confirmation prompt so you never trigger them by accident
- **Color-coded output** — clear green ✓ / red ✗ / yellow ! feedback for every action
- **Safe interrupts** — `Ctrl+C` returns you to the menu instead of killing the whole session

## 📋 Requirements

- Kali Linux (or any Debian/Ubuntu-based distro with `apt` and `systemd`)
- Root privileges (the script will refuse to run otherwise)
- `curl` installed (used for the public IP check)

## 🚀 Installation

```bash
git clone https://github.com/shawon-mr6/kali-manager.git
cd kali-manager
chmod +x kali_manager.sh
```

## ▶️ Usage

Run the script with root privileges:

```bash
sudo ./kali_manager.sh
```

You'll see a numbered menu — just type the number of the action you want and press Enter.

```
==================================================
          KALI LINUX MANAGEMENT MENU
==================================================

  SYSTEM
  1. Update package list
  2. Full system upgrade
  3. Update + Full Upgrade
  4. Clean packages
  5. Autoremove unused packages

  SERVICES
  6. Start Apache
  7. Stop Apache
  8. Restart Apache
  9. Apache Status
 10. Start PostgreSQL
 11. Stop PostgreSQL
 12. Restart PostgreSQL
 13. PostgreSQL Status
 14. Start Metasploit Database

  NETWORK / SYSTEM INFO
 15. Show IP Address
 16. Show Routing Table
 17. Show Public IP
 18. Disk Usage
 19. Memory Usage
 20. CPU Information
 21. Running Services

  PACKAGES
 22. Search Package
 23. Install Package
 24. Remove Package

  POWER
 25. Reboot System
 26. Shutdown System

  0. Exit

==================================================
```

## ⚠️ Notes

- The script must be run as root (via `sudo`) — commands inside it are **not** individually prefixed with `sudo` since the whole script already runs with root privileges.
- Reboot and shutdown options (`25`, `26`) require a `y` confirmation before executing.
- This tool is intended for personal system administration on machines you own or manage. Use responsibly.

## 🤝 Contributing

Issues and pull requests are welcome! If you'd like to add support for more services or features, feel free to fork and submit a PR.

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 👤 Author

**shawon-mr6**
GitHub: [@shawon-mr6](https://github.com/shawon-mr6)
