@echo off
REM Windows wrapper for setup-new-project.sh
REM Requires Git Bash or WSL

bash "%~dp0setup-new-project.sh" %*
