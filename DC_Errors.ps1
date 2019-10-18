start-transcript -path c:\scripts\DC_Errors\log\DC_Errors.txt
c:
cd \scripts\DC_Errors
import-module activedirectory
####
##
## Read Domains and then all DCs from AD
## Then for each DC, attempt to read AD account'saservicenow'  ( exists everywhere )
## If the get-aduser fails, Save there server name, and error text for output later
##
## File: DC_Errors.csv will have the list of errored DCs and the error number
## File: DC_Errors.txt will list the errors encountered
##
####
$e = @()

(get-adforest).domains | 
  %{ Get-ADDomainController -filter * -Server $_  | ?{ $_.OperatingSystem -notmatch "2003" } |
    %{ $srvr = $_.hostname
       $error.clear()
       if ($u = get-aduser administrator -server $srvr) {}

       if ( $error.count -eq 1 )
         { 
            if ( $e.count -eq 0 ) { $e += $error[0] }
            $idx = -1
            $cc = -1   
            $e | %{ $idx ++; if ( [string]$error[0] -eq $_ ) {$cc = $idx} }
            if ( $cc -eq -1 ) { $e += [string]$error[0]; $cc = $e.count -1 }
            $srvr | select @{ n="Server"; e={ $_ }},           
                           @{ n="Error"; e={ $cc + 1}}
         }
     }  
   } | sort error,Server | export-csv DC_Errors.csv -notypeinformation

$cc = 0
"Errors Encountered" | out-file DC_Errors.txt
if ( $e.count -gt 0 )
   { $e | %{ "    " |out-file DC_Errors.txt -append 
             $cc ++
             [string]$cc + "   " + $_  | out-file DC_Errors.txt -append 
           }
##     Send-MailMessage -From ADHealthWatch@companyname.com -To cloudcowboy@companyname.com -Subject "Daily DC Error Check - OneLab" -SmtpServer smtp.companyname.com -Body "New automated DC Error check identifies DC that PowerShell has issues getting data from being delivered to Domain Admins`r`n`r`nPlease arrange to reboot any DC with the error 'The server was unable to process the request due to an internal error.'" -attachment "c:\scripts\DC_Errors\DC_Errors.csv","c:\scripts\DC_Errors\DC_Errors.txt"
     Send-MailMessage -From ADHealthWatch@companyname.com -To cloudcowboy@companyname.com,cloudcowgirl@companyname.com -Subject "Daily DC Error Check - servername.companyname.com" -SmtpServer 192.168.0.100 -Body "New automated DC Error check identifies DC that PowerShell has issues getting data from being delivered to Domain Admins`r`n`r`nPlease arrange to reboot any DC with the error 'The server was unable to process the request due to an internal error.'" -attachment "c:\scripts\DC_Errors\DC_Errors.csv","c:\scripts\DC_Errors\DC_Errors.txt"
 
   }
else
   { "No Errors found " |out-file DC_Errors.txt
##     Send-MailMessage -From ADHealthWatch@companyname.com -To tmrayer@companyname.com -Subject "Daily DC Error Check - OneLab" -SmtpServer smtp.companyname.com -Body "New automated DC Error check identifies DC that PowerShell has issues getting data from being delivered to Domain Admins`r`n`r`nPlease arrange to reboot any DC with the error 'The server was unable to process the request due to an internal error.'`r`n`r`nNO ERRPRS FOUND" -attachment "c:\scripts\DC_Errors\DC_Errors.csv","c:\scripts\DC_Errors\DC_Errors.txt"
     Send-MailMessage -From ADHealthWatch@companyname.com -To cloudcowboy@companyname.com,cloudcowgirl@companyname.com -Subject "Daily DC Error Check - severname.companyname.com - NO ERRORS FOUND" -SmtpServer 192.168.0.100 -Body "NO ERRORS FOUND TODAY`r`n`r`nNew automated DC Error check identifies DC that PowerShell has issues getting data from being delivered to Domain Admins`r`n`r`nPlease arrange to reboot any DC with the error 'The server was unable to process the request due to an internal error.'`r`n`r`nNO ERRORS FOUND" -attachment "c:\scripts\DC_Errors\DC_Errors.csv","c:\scripts\DC_Errors\DC_Errors.txt"
   }

stop-transcript