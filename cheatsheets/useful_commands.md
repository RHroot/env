# Linux System Information Commands

A concise reference of useful commands to inspect system, hardware, and OS details.

---

## 🧠 Core System Overview

### `hostnamectl`

Provides a structured summary of system identity, OS, kernel, and firmware.

```bash
hostnamectl
```

---

### `uname`

Low-level kernel/system info.

```bash
uname -a    # everything
uname -r    # kernel version
uname -m    # architecture
```

---

## ⚙️ CPU Information

### `lscpu`

Detailed CPU architecture and features.

```bash
lscpu
```

---

### `/proc/cpuinfo`

Raw CPU details from kernel.

```bash
cat /proc/cpuinfo
```

---

## 💾 Memory

### `free`

Shows RAM and swap usage.

```bash
free -h
```

---

## 💽 Disk & Storage

### `lsblk`

Lists block devices (disks, partitions).

```bash
lsblk
```

---

### `df`

Filesystem disk usage.

```bash
df -h
```

---

## 🧱 Hardware Information

### `lshw` (may need install)

Detailed hardware inventory.

```bash
sudo lshw -short
```

---

### `inxi` (optional tool)

Clean, human-readable system summary.

```bash
inxi -Fx
```

---

## 🔌 Firmware / BIOS

### `hostnamectl`

Already includes firmware version and age.

---

### `fwupdmgr`

Manage firmware updates.

```bash
fwupdmgr get-devices
fwupdmgr get-updates
```

---

## 🌐 Network

### `ip`

Modern network interface tool.

```bash
ip a
```

---

### `ss`

Socket statistics (replacement for netstat).

```bash
ss -tuln
```

---

## 🔍 Logs & Boot Info

### `journalctl`

System logs.

```bash
journalctl -b
```

---

### `uptime`

System running time and load.

```bash
uptime
```

---

## 🧪 Quick Combined View (Alias)

Add this to your shell config (`.zshrc` / `.bashrc`):

```bash
alias sysinfo="hostnamectl && echo && lscpu | head -15 && echo && free -h"
```

---

## ✅ Notes

- Prefer modern tools (`ip`, `ss`) over deprecated ones (`ifconfig`, `netstat`)
- `hostnamectl` is best for quick overview
- Combine commands depending on use case (debugging vs monitoring)

---

## 📌 Minimal Daily Set

If you only remember a few commands:

```bash
hostnamectl
lscpu
free -h
lsblk
df -h
```

---

End of file.
