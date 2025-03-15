#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    echo "CPU Usage:"
    mpstat 1 1 | awk '/all/ {print "  Usage: " 100 - $NF "%"}'
}

# Function to get memory usage
get_memory_usage() {
    echo "Memory Usage:"
    free -m | awk 'NR==2{printf "  Used: %s MB\n  Free: %s MB\n  Usage: %.2f%%\n", $3, $4, $3*100/($3+$4)}'
}

# Function to get disk usage
get_disk_usage() {
    echo "Disk Usage:"
    df -h --total | awk '/total/ {printf "  Used: %s\n  Free: %s\n  Usage: %s\n", $3, $4, $5}'
}

# Function to get top 5 processes by CPU usage
get_top_cpu_processes() {
    echo "Top 5 Processes by CPU Usage:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

# Function to get top 5 processes by memory usage
get_top_memory_processes() {
    echo "Top 5 Processes by Memory Usage:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

# Additional system stats
get_extra_stats() {
    echo "System Info:"
    echo "  OS: $(lsb_release -d | cut -f2)"
    echo "  Uptime: $(uptime -p)"
    echo "  Load Average: $(uptime | awk -F 'load average:' '{print $2}')"
    echo "  Logged-in Users: $(who | wc -l)"
    echo "  Failed Login Attempts: $(journalctl _SYSTEMD_UNIT=ssh.service | grep 'Failed password' | wc -l)"
}

# Run all functions
echo "Server Performance Stats"
echo "========================="
get_cpu_usage
get_memory_usage
get_disk_usage
get_top_cpu_processes
get_top_memory_processes
get_extra_stats
