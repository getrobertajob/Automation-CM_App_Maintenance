# Automation-CM_App_Maintenance
Windows Batch script to Automate nightly maintenance tasks for the CM App.
1) Launched by Windows Task Scheduler via time trigger.
2) If batch matching batch service is configured than stops batch service.
3) Sends windows command to launch App stop executable.
4) If services still running after pause for stop executable than send windows task kill command.
5) Deletes temp folders.
6) Compresses current logs as zip and moving to archive storage with date appended to file name.
7) Cleans up logs folder.
8) Sends windows App executable.
