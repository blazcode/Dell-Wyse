#Wyse Management Suite credentials
$Form = @{
    j_username  = 'user'
    j_password  = 'password'
}

#WMS login URL
$LoginUri = "https://us1.wysemanagementsuite.com/ccm-web/j_spring_security_check"

#Device export URL w/ query string
$CSVUri = "https://us1.wysemanagementsuite.com/ccm-web/admin/devices/exportDeviceList?sortBy=lastCheckinTime&asc=false&pageSize=25&startRow=0&searchStr=&groupId=0&type=0&deviceType=0&subnet=&timezone=&osType=-1&platformType=-1&isActive=true&isExport=false&osVersion=&osVersionCompare=0&agentVersion=&agentVersionCompare=0&deviceTag=&searchFields="

#Login to WMS, generate session
Invoke-WebRequest $LoginUri -SessionVariable 'session' -Body $Form -Method Post

#Request device export, remove first row, and save a .csv
Add-Content -Path "C:\Scripts\WMSDeviceExport\Devices.csv" -Value $($(Invoke-WebRequest $CSVUri -WebSession $Session).Content -Replace 'Device Summary','')

#Remove blank lines, save new copy of .csv
Select-String -Pattern "\w" -Path "C:\Scripts\WMSDeviceExport" | % { $_.line } | Set-Content -Path "C:\installs\ThinClients_Devices.csv"

#Delete orginal .csv
Remove-Item -Path "C:\Scripts\WMSDeviceExport\Devices.csv"