@echo off
REM Windows wrapper for validate-setup.sh
REM Requires Git Bash or WSL

bash "%~dp0validate-setup.sh" %*
