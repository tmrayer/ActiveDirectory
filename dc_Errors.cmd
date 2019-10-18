::
:: once a dau, run a powershell script that will read:
:: get-aduser from all DCs to identify access errors
::

c:
cd \ScheduledTaskProcess\DC_Errors
powershell.exe -NonInteractive -WindowStyle Hidden -command ". 'c:\scripts\DC_Errors\DC_Errors.ps1"'