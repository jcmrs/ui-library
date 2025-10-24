@echo off
REM Windows wrapper for where-am-i.sh
REM Requires Git Bash or WSL

bash "%~dp0where-am-i.sh" %*
