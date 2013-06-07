# 
# Populate UD Table with Student CRS_ACADEMIC_TAG
#

function readSourceAndUpdateDatabase{
$counter = 1
$fileA = "C:\Temp\COURSE.txt"
ForEach ($a in Get-Content $fileA)
{
if ($counter -gt 1) {
	# $i = $a.split(",")
	$i = $a.split("`t") 

	#display on screen...
	 $i[0] + " " + $i[9] 

	 
	 $crsid = $i[0]
	 #$schyr = $i[1]
	 #$calmon = $i[2]
	 #$calyr = $i[3]
	 #$distcrsid = $i[4]
	 #$olddistcrsid = $i[5]
	 #$crsid = $i[6]
	 #$crstitle = $i[7]
	 #$crdatt = $i[8]
	 $acatype = $i[9]
	 #$crdcomp = $i[10]
	 #$grade = $i[11]
	 #$mark = $i[12]
	 #$numark = $i[13]
	 #$indistsch = $i[14]
	 #$outdistschallow = $i[15]
	 #$outdistschfedid = $i[16]
	 #$outdistschid = $i[17]
	 #$outdistschname = $i[18]
	 #$outdistschcity = $i[19]
	 #$outdistschstate = $i[20]
	 #$termcode = $i[21]
	 #$tchname = $i[22]
	 #$yrtptitle = $i[23]
	 #$clsbegindate = $i[24]
	 #$clsenddate = $i[25]
	 #$atttot = $i[26]
	 

		
#Update
#PROD
$Cmd.CommandText = "UPDATE rev.EPC_CRS set ACADEMIC_TYPE = `'$acatype`' where COURSE_ID = `'$crsid`'"

#TRAIN
#$Cmd.CommandText = "INSERT INTO rev.UD_STUCRSHISTORY (UDSTUCRSHISTORY_GU,ATTENDANCE_TOTAL,CALENDAR_MONTH,CALENDAR_YEAR,CLASS_END_DATE,COURSE_ID,COURSE_TITLE,CREDIT_ATTEMPTED,CREDIT_COMPLETED,CRS_HISTORY_TYPE,DISTRICT_COURSE_ID,GRADE,IN_DISTRICT_SCHOOL,MARK,SCHOOL_YEAR,STUDENT_GU,TEACHER_NAME) VALUES (`'$guid`',`'$atttot`',`'$calmon`',`'$calyr`',`'$enddate`',`'$crsid`',`'$crstitle`',`'$crdatt`',`'$crdcomp`',`'$histype`',`'$distcrsid`',`'$grade`',`'$indistsch`',`'$mark`',`'$schyr`',(select student_gu from rev.epc_stu where sis_number = `'$sisnum`'),`'$tchname`')"
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

