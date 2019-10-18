::
:: Daily AD replication check
:: Sends report to domain admins with results
::

c:
cd \ScheduledTaskProcess\replCheck
powershell.exe -NonInteractive -WindowStyle Hidden -command ". 'c:\Scripts\replCheck\replCheck.ps1"'


