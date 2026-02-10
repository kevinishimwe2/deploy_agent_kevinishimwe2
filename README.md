Overview
setup_project.sh is a fully automated shell script that bootstraps a Student Attendance Tracker workspace. It creates the required directory architecture, populates all source files, allows dynamic configuration updates via sed, handles interrupts gracefully with a trap, and validates the environment before completing setup.

Repository Structure
deploy_agent_YourUsername/
├── setup_project.sh       # Master bootstrap script
└── README.md              # This file
After running the script, a new project directory is created in your current folder:

attendance_tracker_{input}/
├── attendance_checker.py       # Main Python application
├── Helpers/
│   ├── assets.csv              # Student attendance data
│   └── config.json             # Attendance threshold configuration
└── reports/
    └── reports.log             # Output log for attendance reports
How to Run
1. Clone the repository
bash
git clone https://github.com/YourUsername/deploy_agent_YourUsername.git
cd deploy_agent_YourUsername
2. Make the script executable
bash
chmod +x setup_project.sh
3. Run the script
bash
./setup_project.sh
You will be prompted to:

Enter a project name (e.g. cohort5, term2) — the workspace will be created as attendance_tracker_{input}
Optionally update attendance thresholds (Warning %, Failure %) in config.json
4. Run the Python tracker (after setup)
bash
cd attendance_tracker_{input}
python3 attendance_checker.py
Results are printed to the terminal and appended to reports/reports.log.

How to Trigger the Archive Feature (Ctrl+C Interrupt)
The script uses a SIGINT trap to handle cancellation gracefully.

To trigger it:

Start the script: ./setup_project.sh
Enter a project name when prompted
Press Ctrl+C at any point during execution
What happens:

The script catches the interrupt signal
It bundles the incomplete project directory into a compressed archive:
attendance_tracker_{input}_archive.tar.gz
It deletes the incomplete directory to keep your workspace clean
It exits with a non-zero status code
Example output:

⚠️  Interrupt detected (Ctrl+C)! Cleaning up incomplete workspace...
📦 Bundling current state into archive: attendance_tracker_cohort5_archive.tar.gz
🗑️  Removing incomplete project directory: attendance_tracker_cohort5
✅ Cleanup complete. Archive saved as: attendance_tracker_cohort5_archive.tar.gz
Configuration Details
The config.json file controls attendance thresholds:

Key	Default	Description
warning_threshold	75	Students below this % receive a WARNING
failure_threshold	50	Students below this % receive a FAIL
The script uses sed to update these values in-place without opening a text editor.

Environment Requirements
Tool	Purpose	Required?
bash	Run the shell script	✅ Yes
python3	Run the attendance tracker	✅ Yes (checked by script)
tar	Create the interrupt archive	✅ Yes (usually pre-installed)
sed	In-place config editing	✅ Yes (usually pre-installed)
Demo Video
🎬 [Link to run-through video — add your link here]

Author
[Kevin Karagire Ishimwe]
GitHub: @kevinishimwe2
ALU — January Term 2026


