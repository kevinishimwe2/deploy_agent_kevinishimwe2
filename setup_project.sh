#!/bin/bash

create_directory() {
    dir=attendance_tracker
    while true; do
        read -p "Name your directory suffix ${dir}_ : " y
        full_dir="${dir}_${y}"
        if [[ -d $full_dir ]]; then
            echo "Directory '$full_dir' already exists!"
            read -p "Do you want to (y) try a different name or (n) cancel? [yes(y)/no(n)]: " choice
            case $choice in
            y|Y) continue ;;
            n|N) echo "Cancelled."; break ;;
            *)   echo "Invalid input. Please enter y or n." ;;
            esac
        else
            mkdir -p "$full_dir"
            echo "Directory '$full_dir' created successfully!"
            break
        fi
    done
    mkdir -p ${full_dir}/Helpers
    mkdir -p ${full_dir}/reports
    chmod +rwx ${full_dir}
    echo "Directories successfully created"

    cat > ${full_dir}/attendance_checker.py << 'EOF'
    import csv
    import json
    import os
    from datetime import datetime

    def run_attendance_check():
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        for row in reader:
            name = row['Names']
            email = row['Student number']
            attended = int(row['Attendance Count'])
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

    cat > ${full_dir}/Helpers/assets.csv << 'EOF'
    Student number,Names,Attendance Count,Absence Count
    S001,Alice Johnson,14,1
    S002,Bob Smith,7,8
    S003,Charlie Davis,4,11
    S004,Diana Prince,15,0
    S005,Patrick Ishimwe,10,5
    S006,Kevin Debryne,11,4
EOF

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
}

# ── Reusable directory resolver to check the availability of the directories in case 2 and 3 ───────────────────────────────────────────────
resolve_directory() {
    while true; do
        read -rp "  Enter your directory(project) suffix [attendance_tracker_{input}]: " input
        curr_dir="attendance_tracker_${input}"
        if [[ -d $curr_dir ]]; then
            break
        else
            echo "The directory '${curr_dir}' doesn't exist."
            read -rp "Do you want to create a project? [y/n] " ans
            case $ans in
            y|Y) create_directory; curr_dir="${full_dir}"; continue ;;
            n|N) echo "Cancelled."; break ;;
            *)   echo "Invalid input. Please enter y or n." ;;
            esac
        fi
    done
}

#------------------------------------------- Menu ----------------------------------------------------------------──
echo -e "Choose what to do: \n"
echo "1: Make the directory structure."
echo "2: Dynamic Configuration (Stream Editing)"
echo "3: Process Management (The Trap)"
echo "4: Health Check and see if python is installed successfully"
echo ""
read -p "Enter your choice(1-4): " x

case $x in
1)
    create_directory
    ;;

2)
    resolve_directory
    CONFIG_FILE="${curr_dir}/Helpers/config.json"

    if [[ -f $CONFIG_FILE ]]; then
        read -rp "  Do you want to update the attendance thresholds? [y/n]: " new
        case $new in
        y|Y)
            while true; do
                read -rp "  Enter new Warning threshold % [default 75]: " new_warn
                [[ -z $new_warn ]] && new_warn=75
                [[ $new_warn =~ ^[0-9]+$ ]] && ((new_warn >= 1 && new_warn <= 100)) && break
                echo "Invalid — enter a whole number between 1 and 100."
            done

            while true; do
                read -rp "  Enter new Failure threshold % [default 50]: " new_fail
                [[ -z $new_fail ]] && new_fail=50
                [[ $new_fail =~ ^[0-9]+$ ]] && ((new_fail >= 1 && new_fail <= 100)) && break
                echo "Invalid — enter a whole number between 1 and 100."
            done

            sed -i "s/\"warning\": [0-9]*/\"warning\": ${new_warn}/" "$CONFIG_FILE"
            sed -i "s/\"failure\": [0-9]*/\"failure\": ${new_fail}/" "$CONFIG_FILE"

            echo "config.json updated — Warning: ${new_warn}%, Failure: ${new_fail}%"
            cat "$CONFIG_FILE"
            ;;
        n|N) echo "No changes made." ;;
        *)   echo "Invalid input. Please enter y or n." ;;
        esac
    else
        echo "Config file not found. Run option 1 first."
    fi
    ;;

3)
    resolve_directory

    cleanup() {
        echo ""
        echo "SIGINT detected — script interrupted."
        if [[ -d "$curr_dir" ]]; then
            tar -czf "${curr_dir}_archive.tar.gz" "${curr_dir}"
            echo "Archive created: ${curr_dir}_archive.tar.gz"
            rm -rf "${curr_dir}"
            echo "Workspace cleaned up."
        else
            echo "No directory found — nothing to archive."
        fi
        exit 130
    }

    trap cleanup SIGINT

    echo "Process running — press Ctrl+C to test the trap..."
    steps=(
        "1 : Validating permissions" 
        "2 : Reading config" "Processing data" 
        "3 : Generating report" 
        "4 : Finalising"
        )
    for i in "${!steps[@]}"; do
        echo -ne "  ${step}..."
        sleep 2
        echo " done"
    done

    echo "Process completed successfully."
    trap - SIGINT
    ;;

4)
    echo "Health Check - not yet implemented"
    ;;
*)
    echo "Invalid choice. Please enter 1-4."
    ;;
esac