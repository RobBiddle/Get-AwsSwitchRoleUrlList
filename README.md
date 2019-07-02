# Get-AwsSwitchRoleUrlList
Get a list of Switch Role login URLs for the Accounts within an AWS Organization for the specified IAM Role 

#### SYNOPSIS
    Generates a list of login URLs for each Account within an AWS Organization
#### DESCRIPTION
    Pulls a list of Accounts withing an AWS Organization and then generates a Switch Role login URL for each account, using the IAM Role specified
    If OutputHtmlFile switch parameter is chosen then an HTML file containing Hyperlinked URLs will be generated.
#### EXAMPLE
```PowerShell
PS C:\> Get-AwsSwitchRoleUrlList -IAMRole ExampleRoleNameToUse
```
    A list of URLs will be output like this:
    https://signin.aws.amazon.com/switchrole?account=111111111111&roleName=ExampleRoleNameToUse&displayName=Example-Sub-Account1
    https://signin.aws.amazon.com/switchrole?account=222222222222&roleName=ExampleRoleNameToUse&displayName=Example-Sub-Account2
    https://signin.aws.amazon.com/switchrole?account=333333333333&roleName=ExampleRoleNameToUse&displayName=Example-Sub-Account3
#### EXAMPLE
```PowerShell
PS C:\> Get-AwsSwitchRoleUrlList -IAMRole ExampleRoleNameToUse -OutputHtmlFile
```
    A file named SwitchRoleUrlList.html will be created in the current working directory
    The file will contain an HTML table with the Id, Name & SwitchRole URL of each AWS Account within the Organization
#### EXAMPLE
```PowerShell
PS C:\> Get-AwsSwitchRoleUrlList -IAMRole ExampleRoleNameToUse -OpenFileInBrowser
```
    Same as previous example but the file will automatically open in default browser
