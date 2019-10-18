start-transcript -path C:\scripts\replcheck\log\repl.txt

c:
cd \scripts\replcheck

#Collect the replication info
#Check the Replication with Repadmin
invoke-expression (" repadmin.exe /showrepl * /csv > c:\scripts\replcheck\repl.csv" )


$workfile = import-csv c:\scripts\replcheck\repl.csv

 
#Here you set the tolerance level for the report
$results = $workfile | where {$_.'Number of Failures' -gt 0 }

 
$results | export-csv c:\scripts\replcheck\Repl_Error_Report.csv -notypeinformation

if ($results.count -gt 0)
 {
##Send-MailMessage -From ADHealthWatch@companyname.com -To Cloudcowboy@companyname.com -Subject "Daily Forest Replication Status" -SmtpServer 192.168.0.100 -Body "New automated replication check report being delivered to Domain Admins" -attachment "c:\scripts\replcheck\Repl_Error_Report.csv"
   Send-MailMessage -From ADHealthWatch@companyname.com -To Cloudcowboy@companyname.com,Cloudcowgirl@companyname.com -Subject "Daily Forest Replication Status - servername.companyname.com" -SmtpServer 192.168.0.100 -Body "New automated replication check report being delivered to Domain Admins" -attachment "c:\scripts\replcheck\Repl_Error_Report.csv"
 }
Else
 {
   Send-MailMessage -From ADHealthWatch@companyname.com -To Cloudcowboy@companyname.com,Cloudcowgirl@companyname.com -Subject "Daily Forest Replication Status - servername.companyname.com - NO ERRORS" -SmtpServer 192.168.0.100 -Body "New automated replication check report being delivered to Domain Admins - NO ERRORS FOUND TODAY" -attachment "c:\scripts\replcheck\Repl_Error_Report.csv"
 }

stop-transcript



