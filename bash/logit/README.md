# Logit - A Lightweight Bash Logging Utility

![Logit Logo](https://img.shields.io/badge/Logit-Bash%20Logging%20Utility-blue)

Logit is a lightweight and configurable Bash logging utility that enables structured logging with levels (INFO, DEBUG, WARN, ERROR). It supports automatic command logging, customizable timestamps, log rotation, and silent mode, making it ideal for script debugging and system monitoring.

---

### 🛠️ **Installation**

1. Download the `logit.sh` script or clone the repository:

    ```bash
    git clone https://github.com/yourusername/logit.git
    ```

2. Source the script in your `.bashrc` or `.bash_profile` file:

    ```bash
    # Example of sourcing logit in .bashrc
    source /path/to/logit.sh
    ```

---

### 🚀 **Usage**

To log a message with a specific level, run:

```bash
logit INFO "Your info message"
logit DEBUG "Your debug message"
logit WARN "Your warning message"
logit ERROR "Your error message"
```

To start logging all executed commands, use:

```bash
logit start
```

To see the version of `logit`:

```bash
logit version
```

To get help:

```bash
logit help
```

To update (not yet implemented):

```bash
logit update
```

To uninstall (not yet implemented):

```bash
logit uninstall
```

---

### ⚙️ **Configuration**

- **Log Location**: By default, log entries are saved to `/var/log/<script_name>.log`. You can override the log directory and file location by setting the `LOGDIR` and `LOGFILE` environment variables.

    ```bash
    export LOGDIR=/path/to/custom/logs
    export LOGFILE=/path/to/custom/logfile.log
    ```

- **Timestamp Format**: You can customize the timestamp format used in log entries by setting the `LOGIT_DATE_FORMAT` variable:

    ```bash
    export LOGIT_DATE_FORMAT="%Y-%m-%d %H:%M:%S"
    ```

- **Silent Mode**: To suppress console output for non-error messages, set the `LOGIT_SILENT` variable:

    ```bash
    export LOGIT_SILENT=true
    ```

---

### 🧑‍💻 **Autocompletion**

Logit supports Bash autocompletion for commands like `help`, `version`, `update`, and `uninstall`. Autocompletion is enabled when using an interactive shell.

---

### 📜 **License**

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

### 👨‍💻 **Author**

- **Tal Mendelson** - Developer

---

### 📦 **Badges**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
[![Version](https://img.shields.io/badge/Version-0.0.2-blue.svg)](https://github.com/yourusername/logit)

