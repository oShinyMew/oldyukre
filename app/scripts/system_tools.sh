#!/bin/bash

# System cleanup functions
cleanup_system_cache() {
    rm -rf /var/mobile/Library/Caches/* 2>/dev/null
    rm -rf /var/mobile/Library/Logs/* 2>/dev/null
    rm -rf /var/log/* 2>/dev/null
    sync
    return 0
}

# Security functions
harden_security() {
    # Disable SSH if running
    if pgrep -x "sshd" > /dev/null; then
        launchctl unload /Library/LaunchDaemons/com.openssh.sshd.plist 2>/dev/null
    fi
    
    # Set strict permissions
    chmod 700 /var/mobile 2>/dev/null
    chmod 700 /var/root 2>/dev/null
    
    return 0
}

# Network functions
configure_network() {
    # Flush DNS cache
    killall -HUP mDNSResponder 2>/dev/null
    
    # Reset network settings
    if [ -f "/var/mobile/Library/Preferences/com.apple.network.identification.plist" ]; then
        rm "/var/mobile/Library/Preferences/com.apple.network.identification.plist" 2>/dev/null
    fi
    
    return 0
}

# Diagnostics
run_diagnostics() {
    # Check system integrity
    echo "Running system integrity check..."
    
    # Check important system files
    critical_paths=(
        "/System/Library/CoreServices"
        "/usr/lib"
        "/usr/bin"
        "/var/mobile"
    )
    
    for path in "${critical_paths[@]}"; do
        if [ ! -d "$path" ]; then
            echo "Warning: Critical path $path is missing"
        fi
    done
    
    # Check disk space
    df -h / | tail -n 1
    
    return 0
}

# Main command handler
case "$1" in
    "cleanup")
        cleanup_system_cache
        ;;
    "harden")
        harden_security
        ;;
    "network")
        configure_network
        ;;
    "diagnostics")
        run_diagnostics
        ;;
    *)
        echo "Usage: $0 {cleanup|harden|network|diagnostics}"
        exit 1
        ;;
esac