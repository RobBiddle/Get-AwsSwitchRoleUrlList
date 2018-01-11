<#
.SYNOPSIS
    Generates a list of login URLs for each Account within an AWS Organization
.DESCRIPTION
    Pulls a list of Accounts withing an AWS Organization and then generates a Switch Role login URL for each account, using the IAM Role specified
    If OutputHtmlFile switch parameter is chosen then an HTML file containing Hyperlinked URLs will be generated.
.EXAMPLE
    PS C:\> Get-AwsSwitchRoleUrlList -IAMRole ExampleRoleNameToUse
    A list of URLs will be output like this:

    https://signin.aws.amazon.com/switchrole?account=111111111111&roleName=ExampleRoleNameToUse&displayName=Example-Sub-Account1
    https://signin.aws.amazon.com/switchrole?account=222222222222&roleName=ExampleRoleNameToUse&displayName=Example-Sub-Account2
    https://signin.aws.amazon.com/switchrole?account=333333333333&roleName=ExampleRoleNameToUse&displayName=Example-Sub-Account3

.EXAMPLE
    PS C:\> Get-AwsSwitchRoleUrlList -IAMRole ExampleRoleNameToUse -OutputHtmlFile
    A file named SwitchRoleUrlList.html will be created in the current working directory
    The file will contain an HTML table with the Id, Name & SwitchRole URL of each AWS Account within the Organization

.EXAMPLE
    PS C:\> Get-AwsSwitchRoleUrlList -IAMRole ExampleRoleNameToUse -OutputHtmlFile -OpenFileInBrowser
    Same as previous example but the file will automatically open in default browser

.NOTES
    Author: Robert D. Biddle
    Created: Jan.10.2018
#>
[CmdletBinding(
    SupportsShouldProcess = $false,
    PositionalBinding = $false,
    HelpUri = 'https://github.com/RobBiddle/Get-AwsSwitchRoleUrlList/',
    DefaultParameterSetName = 'DefaultSet'
)]
param (
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $false,
        ValueFromRemainingArguments = $false)]
    [ValidateNotNullOrEmpty()]
    [Parameter(ParameterSetName = 'DefaultSet')]
    [Parameter(ParameterSetName = 'OutputHTML')]
    [String]
    $IAMRole,

    [Parameter(ParameterSetName = 'OutputHTML')]
    [Switch]
    $OutputHtmlFile,

    [Parameter(ParameterSetName = 'OutputHTML')]
    [Switch]
    $OpenFileInBrowser
)
$UrlPart1 = "https://signin.aws.amazon.com/switchrole?account="
$UrlPart2 = "&roleName=$IAMRole&displayName="
$AccountList = Get-ORGAccountList | Where-Object Id -ne (Get-ORGOrganization).MasterAccountId | Sort-Object Name
$SwitchRoleUrlList = @()
foreach ($account in $AccountList) {
    $SwitchRoleUrl = "$URLPart1$($account.Id)$UrlPart2$($account.Name)"
    $obj = New-Object -TypeName psobject
    $obj | Add-Member -NotePropertyName 'Id' -NotePropertyValue $account.Id
    $obj | Add-Member -NotePropertyName 'Name' -NotePropertyValue $account.Name
    $obj | Add-Member -NotePropertyName 'URL' -NotePropertyValue $SwitchRoleUrl
    $obj | Add-Member -NotePropertyName 'HyperLink' -NotePropertyValue "<a href=`"$SwitchRoleUrl`">$SwitchRoleUrl</a>"
    $SwitchRoleUrlList += $obj
}
if ($OutputHtmlFile -or $OpenFileInBrowser) {
    $OutputFile = New-Item -ItemType File -Path ".\" -Name "SwitchRoleUrlList.html" -Force

    $Content = @'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<head>
<title>AWS SwitchRole URLs</title>
</head>
<body>
<div class="container-fluid">
<div class="table-responsive">
<table class="table table-striped">
<thead>
<tr>
  <th>Name</th>
  <th>Account Id</th>
  <th>SwitchRole URL</th>
</tr>
</thead>
<tbody>
'@
    foreach ($url in $SwitchRoleUrlList) {
        $Content += "<tr>"

        $Content += "<td>"
        $Content += $url.Name
        $Content += "</td>"
    
        $Content += "<td>"
        $Content += $url.Id
        $Content += "</td>"
    
        $Content += "<td>"
        $Content += $url.HyperLink
        $Content += "</td>"

        $Content += '</tr>'
    }
    $Content += '</tbody></div></body></html>'
    $Content | Out-File -FilePath $OutputFile.FullName -Encoding default -Force
    
    if ($OpenFileInBrowser) {
        Start-Process $OutputFile.FullName
    }
    Else {
        Get-Item $OutputFile.FullName
    }
}
Else {
    $SwitchRoleUrlList | Select-Object Id, Name, URL
}