@echo off
REM Windows wrapper for sync-with-remote.sh
REM Requires Git Bash or WSL

bash "%~dp0sync-with-remote.sh" %*
