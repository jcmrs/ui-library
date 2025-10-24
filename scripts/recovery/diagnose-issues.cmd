@echo off
REM Windows wrapper for diagnose-issues.sh
REM Requires Git Bash or WSL

bash "%~dp0diagnose-issues.sh" %*
