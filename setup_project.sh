#!/bin/bash

echo -e "Choose what to do: \n"
echo  "1: Make the directory structure. "
echo  "2: Dynamic Configuration (Stream Editing)"
echo  "3: Process Management (The Trap)"
echo  "4: Health Check and see if python is install successfully"
echo ""
read -p "Enter your choice(1-4): " x

case $x in
  1)
    dir=attendance_tracker
    while true; do
      read -p "Name your directory ${dir}_ : " y
      full_dir="${dir}_${y}"

      if [[ -d "$full_dir" ]]; then
        echo " Directory '$full_dir' already exists!"
        read -p "Do you want to (y) try a different name or (n) cancel? [yes(y)/no(n)]: " choice
        case $choice in
          y|Y) continue ;;
          n|N) echo "Cancelled."; break ;;
          *) echo "Invalid input. Please enter y or n." ;;
        esac
      else
        mkdir -p "$full_dir"
        echo "Directory '$full_dir' created successfully!"
        break
      fi
    done
  mkdir -p ${full_dir}/Helpers
  mkdir -p ${full_dir}/reports
echo "Directories successfully created"
    # ── attendance_checker.py ────────────────────────────────────────────────
cat > ${full_dir}/attendance_checker.py << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            email = row['Student number']
            attended = int(row['Attendance Count'])
            
            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF
# ___________end of file_________________________
#------------------Start of csv file--------------------------
cat > ${full_dir}/Helpers/assets.csv << 'EOF'
Student number,Names,Attendance Count,Absence Count
S001,Alice Johnson,14,1
S002,Bob Smith,7,8
S003,Charlie Davis,4,11
S004,Diana Prince,15,0
S005,Patrick Ishimwe,10,5
S006,Kevin Debryne,11,4
EOF
#__________________________End of file____________________________________
# ----------------Start of json file--------------------
cat > ${full_dir}/Helpers/config.json << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}

EOF
# ____________End of file______________________________________________
    ;;
  2)
    echo "Dynamic Configuration (Stream Editing) - not yet implemented"
    ;;
  3)
    echo "Process Management (The Trap) - not yet implemented"
    ;;
  4)
    echo "Health Check - not yet implemented"
    ;;
  *)
    echo "Invalid choice. Please enter 1-4."
    ;;
esac
  