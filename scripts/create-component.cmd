@echo off
REM Windows wrapper for create-component.sh
REM Requires Git for Windows (includes Git Bash)

bash "%~dp0create-component.sh" %*
