# ------------------- Initial Message for User ------------------- #


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show(
    "This script will check all the files in a specific directory and remove any file that contains an ID from a given list.

NOTE: It will also remove folders within your specified directory if they contain an ID from your list.

You will be prompted to select/input the following:
1- Folder (that contains the files you want to remove)
2- Text File (that lists those files you want to remove)
3- Number of characters your IDs have",
   
    "Information", "OK", "Information"
)

 
# ------------------- Get Folder, File, Character Length ------------------- #

 
# GUI for selecting a directory
function Get-FolderPath {
    Add-Type -AssemblyName System.Windows.Forms
    $folderDialog = New-Object System.Windows.Forms.OpenFileDialog
    $folderDialog.CheckFileExists = $false
    $folderDialog.ValidateNames = $false
    $folderDialog.FileName = 'Select Folder'
    $folderDialog.Title = "Pick the folder containing the files you want to remove"

    if ($folderDialog.ShowDialog() -eq 'OK') {
        return [System.IO.Path]::GetDirectoryName($folderDialog.FileName)
    }
    return $null
}
$directoryPath = Get-FolderPath

# GUI for selecting the text file
function GetFile($initialDirectory = "") {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "Pick Text File Containing IDs to Remove"

    if ($initialDirectory) {
        $openFileDialog.InitialDirectory = $initialDirectory
    }
    $openFileDialog.Filter = 'Text File (*.txt*)|*.txt*'

    if ($openFileDialog.ShowDialog() -eq "OK") {
        return $openFileDialog.FileName
    }
}
$textFilePath = GetFile

# Input box for ID length
Add-Type -AssemblyName Microsoft.VisualBasic
do {
    $substringLength = [Microsoft.VisualBasic.Interaction]::InputBox(
        "Enter the number of characters in your ID (e.g., URSIs- 9 characters; GUIDs- 12 characters).

Note: Must be an integer!",

        "Input Required - ID length"
    )

    if (-not $substringLength) {
        [System.Windows.Forms.MessageBox]::Show(
            ":(

You didn't input anything! Or you clicked Cancel. Exiting script. Better luck next time...",
           
            "Error", "OK", "Error"
        )
        return
    }
} while (-not ($substringLength -match '^\d+$'))

$substringLength = [int]$substringLength


# -------------------------- Process Files -------------------------- #

 
# Read the list of filenames from the text file
$filenamesToRemove = Get-Content $textFilePath

# Get all files in the selected directory
$allFiles = Get-ChildItem -Path $directoryPath

# Preallocate arrays for readability
$filenamesToDelete = @()
$filesToDelete = @()

# Check if filenames match IDs in the text file
foreach ($file in $allFiles) {
    $filename = $file.Name.Substring(0, $substringLength)
    if ($filenamesToRemove -contains $filename) {
        $filenamesToDelete += $filename
        $filesToDelete += $file.FullName
    }
}

# Confirm file deletion
if ($filesToDelete.Count -gt 0) {
    $fileList = ($filenamesToDelete -join "`n")  # Format file list with line breaks
    $message = "WAIT!! The following files will be deleted:

$fileList

This is not reversible (i.e., ctrl + z won't get your files back). Are you sure you want to proceed?"

    $result = [System.Windows.Forms.MessageBox]::Show($message, "Confirm Deletion", "YesNo", "Warning")

    if ($result -eq "Yes") {
        $filesToDelete | ForEach-Object { Remove-Item -Path $_ -Force }
        [System.Windows.Forms.MessageBox]::Show("Files deleted successfully!", "Operation Completed", "OK", "Information")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Operation canceled. No files were deleted.", "Canceled", "OK", "Information")
    }
} else {
    [System.Windows.Forms.MessageBox]::Show(
        "Whoops!

None of the IDs in your text file were found in this folder. There are no files to delete.

Did you select the correct folder and text file?",
       
        "Information", "OK", "Information"
    )
}
