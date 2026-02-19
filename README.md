# deploy_agent_kevinishimwe2

A shell script that automates the setup and management of a Student Attendance Tracker project.

---

## How to run the script

### 1. Clone the repository
```bash
git clone https://github.com/kevinishimwe2/deploy_agent_kevinishimwe2.git
cd deploy_agent_kevinishimwe2
```

### 2. Make the script executable
```bash
chmod +x setup_project.sh
```

### 3. Run the script
```bash
./setup_project.sh
```

### 4. Choose an option from the menu
```
1: Make the directory structure.
2: Dynamic Configuration (Stream Editing)
3: Process Management (The Trap)
4: Health Check
```

---

## What each option does

**Option 1 — Directory Structure**
Creates the full project folder with all required files inside it.
You will be asked to enter a suffix for the project name.
The folder will be named `attendance_tracker_{suffix}`.

**Option 2 — Dynamic Configuration**
Updates the warning and failure thresholds inside `config.json.`
using `sed` to edit the file directly.
You must have already run option 1 first.

**Option 3 — Process Management (The Trap)**
Runs a simulated deployment process.
If you press `Ctrl+C` during the process, the program will:

1.Intercept the interrupt signal.

2.Archive the project folder and delete it to keep the workspace clean. 

3.A compressed archive of the project directory is created.

T4.he original directory is deleted.

5.The script exits safely with status 130.

**Option 4 — Health Check**
Checks if Python3 is installed and verifies that all required
Files and folders exist inside the project directory.

---

## How to trigger the archive feature

1. Run the script and choose option **3**
2. Enter your project suffix when prompted
3. When you see:
```
Press Ctrl+C to test the trap
```
4. Press **Ctrl+C** on your keyboard

The script will then:
- Bundle the project folder into a `.tar.gz` archive
- Name it `attendance_tracker_{suffix}_archive.tar.gz`
- Delete the incomplete project folder
- Exit cleanly

To confirm the archive was created, run:
```bash
ls *.tar.gz
```

---

## Project structure

After running option 1, your project will look like this:

```
attendance_tracker_{suffix}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
```

---

## Requirements

- Bash
- Python3
- Git
