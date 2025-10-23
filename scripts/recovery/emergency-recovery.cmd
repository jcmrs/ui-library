@echo off
REM Windows wrapper for emergency-recovery.sh
REM Requires Git Bash or WSL

bash "%~dp0emergency-recovery.sh" %*
