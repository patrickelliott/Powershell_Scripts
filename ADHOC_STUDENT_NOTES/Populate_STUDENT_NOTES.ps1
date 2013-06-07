# 
# Populate Student NOTES
#

function readSourceAndUpdateDatabase{
$counter = 1
$fileA = "C:\Temp\STUDENTNOTES.txt"
ForEach ($a in Get-Content $fileA)
{
if ($counter -gt 1) {
	# $i = $a.split(",")
	$i = $a.split("`t") 

	 $guid = [system.guid]::newguid()
	 
	 $sisnum = $i[0]
	 $school = $i[1]
	 $date = $i[2]
	 $note = $i[3]

	 
	 
	 $spldate = $date.split("/")
	 $yr = $spldate[2]
	
	if (($yr -eq "2013" -AND $mo -lt "06") -OR ($yr -eq "2012" -AND $mo -gt "07" )){$schyr = "2012"}
	if (($yr -eq "2012" -AND $mo -lt "06") -OR ($yr -eq "2011" -AND $mo -gt "07" )){$schyr = "2011"}
	if (($yr -eq "2011" -AND $mo -lt "06") -OR ($yr -eq "2010" -AND $mo -gt "07" )){$schyr = "2010"}
	if (($yr -eq "2010" -AND $mo -lt "06") -OR ($yr -eq "2009" -AND $mo -gt "07" )){$schyr = "2009"}
	if (($yr -eq "2009" -AND $mo -lt "06") -OR ($yr -eq "2008" -AND $mo -gt "07" )){$schyr = "2008"}
	if (($yr -eq "2008" -AND $mo -lt "06") -OR ($yr -eq "2007" -AND $mo -gt "07" )){$schyr = "2007"}
	if (($yr -eq "2007" -AND $mo -lt "06") -OR ($yr -eq "2006" -AND $mo -gt "07" )){$schyr = "2006"}
	if (($yr -eq "2006" -AND $mo -lt "06") -OR ($yr -eq "2005" -AND $mo -gt "07" )){$schyr = "2005"}
	if (($yr -eq "2005" -AND $mo -lt "06") -OR ($yr -eq "2004" -AND $mo -gt "07" )){$schyr = "2004"}
	if (($yr -eq "2004" -AND $mo -lt "06") -OR ($yr -eq "2003" -AND $mo -gt "07" )){$schyr = "2003"}
	if (($yr -eq "2003" -AND $mo -lt "06") -OR ($yr -eq "2002" -AND $mo -gt "07" )){$schyr = "2002"}
	if (($yr -eq "2002" -AND $mo -lt "06") -OR ($yr -eq "2001" -AND $mo -gt "07" )){$schyr = "2001"}
	

	#display on screen...
	 $i[0] + " " + $i[1] + " " + $schyr 

	
	#PROD
$Cmd.CommandText = "insert into rev.EPC_STU_SCH_YR_NOT (STU_SCH_YR_NOT_GU,STUDENT_SCHOOL_YEAR_GU, ENTERED_BY_GU, NOTE_DATE, NOTE) VALUES (`'$guid`', (select TOP 1 ssy.STUDENT_SCHOOL_YEAR_GU FROM rev.EPC_STU AS stu inner join REV.REV_PERSON per on (per.PERSON_GU = stu.STUDENT_GU) inner join REV.EPC_STU_YR syr on (syr.STUDENT_GU = stu.STUDENT_GU) inner join REV.REV_YEAR yr on (yr.YEAR_GU = syr.YEAR_GU) inner join REV.EPC_STU_SCH_YR ssy on (ssy.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU) where stu.SIS_NUMBER = `'$sisnum`' and yr.SCHOOL_YEAR = `'$schyr`'), (select TOP 1 ssy.STAFF_SCHOOL_YEAR_GU from rev.EPC_STAFF s INNER JOIN rev.REV_PERSON p on s.STAFF_GU = p.PERSON_GU INNER JOIN rev.EPC_STAFF_SCH_YR ssy on s.STAFF_GU = ssy.STAFF_GU INNER JOIN rev.REV_ORGANIZATION_YEAR oy on ssy.ORGANIZATION_YEAR_GU = oy.ORGANIZATION_YEAR_GU INNER JOIN rev.REV_ORGANIZATION o on oy.ORGANIZATION_GU = o.ORGANIZATION_GU INNER JOIN rev.EPC_SCH sch on o.ORGANIZATION_GU = sch.ORGANIZATION_GU INNER JOIN rev.REV_YEAR y on oy.YEAR_GU = y.YEAR_GU where  s.BADGE_NUM = '99999' and sch.SCHOOL_CODE = `'$school`' and y.SCHOOL_YEAR = `'$schyr`') , `'$date`', `'$note`')"

$Cmd.ExecuteNonQuery()

 }
$counter++ 
}

#Close SQL Connection
$Connection.close()

}

##############################################
######################################  Connect to SQL
#
function sqlConnection([string]$serverName,[string]$dbaseName,[string]$authType){

$Connection = New-Object System.Data.SQLClient.SQLConnection
IF ($authType -eq "Checked") 
	{
		$credential = Get-Credential
		$userName = $credential.UserName -replace("\\","")
		$Password = $credential.GetNetworkCredential().password

		$ConnectionString = "server=" + $serverName + ";user id=" + $userName + ";password=" + $Password + ";database=" + $dbaseName + ";trusted_connection=false;"
	}
ELSE {
	$ConnectionString = "server=" + $serverName + ";database=" + $dbaseName + ";trusted_connection=true;"
}

$Connection.ConnectionString = $ConnectionString
$Connection.Open()
$Cmd = New-Object System.Data.SQLClient.SQLCommand
$Cmd.Connection = $Connection

readSourceAndUpdateDatabase
}
##############################################


##############################################
######################################  User Input Prompt
#
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
function PromptForInput{
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Synergy Database Info"
$objForm.Size = New-Object System.Drawing.Size(300,300) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$serverName=$objTextBoxServerName.Text;$dbaseName=$objTextBoxDBaseName.Text;$authType=$objcheckBoxSQLAuth.checkstate.tostring();$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,180)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$serverName=$objTextBoxServerName.Text;$dbaseName=$objTextBoxDBaseName.Text;$authType=$objcheckBoxSQLAuth.checkstate.tostring();$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(155,180)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabelServerName = New-Object System.Windows.Forms.Label
$objLabelServerName.Location = New-Object System.Drawing.Size(10,20) 
$objLabelServerName.Size = New-Object System.Drawing.Size(280,20) 
$objLabelServerName.Text = "Server-Instance (ex: `"SIS-INSTANCE-B\INSTB`"):"
$objForm.Controls.Add($objLabelServerName) 

$objTextBoxServerName = New-Object System.Windows.Forms.TextBox 
$objTextBoxServerName.Location = New-Object System.Drawing.Size(10,40) 
$objTextBoxServerName.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBoxServerName) 

$objLabelDBaseName = New-Object System.Windows.Forms.Label
$objLabelDBaseName.Location = New-Object System.Drawing.Size(10,80) 
$objLabelDBaseName.Size = New-Object System.Drawing.Size(280,20) 
$objLabelDBaseName.Text = "Database Name:"
$objForm.Controls.Add($objLabelDBaseName) 

$objTextBoxDBaseName = New-Object System.Windows.Forms.TextBox 
$objTextBoxDBaseName.Location = New-Object System.Drawing.Size(10,100) 
$objTextBoxDBaseName.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBoxDBaseName) 

$objcheckBoxSQLAuth = New-Object System.Windows.Forms.CheckBox
$objcheckBoxSQLAuth.UseVisualStyleBackColor = $True
$objcheckBoxSQLAuth.Location = New-Object System.Drawing.Size(12,140)
$objcheckBoxSQLAuth.Size = New-Object System.Drawing.Size(125,23)
$objcheckBoxSQLAuth.Text = "SQL Authentication"
#$objcheckBoxSQLAuth.Name = "objcheckBoxSQLAuth"
$objForm.Controls.Add($objcheckBoxSQLAuth)

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

#$listBox1 = New-Object System.Windows.Forms.ListBox

sqlConnection $serverName $dbaseName $authType
}
#
##############################################  

PromptForInput

