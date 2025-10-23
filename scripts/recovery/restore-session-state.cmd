@echo off
REM Windows wrapper for restore-session-state.sh
REM Requires Git Bash or WSL

bash "%~dp0restore-session-state.sh" %*
