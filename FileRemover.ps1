# Path to text file
$textFilePath = ""
 
# Path to directory
$directoryPath = ""
 
# Read the list of filenames from the text file 
$filenamesToKeep = Get-Content $textFilePath
 
# Get a list of all files in the directory
$allFiles = Get-ChildItem -Path $directoryPath
 
# Loop through each file in the directory
foreach ($file in $allFiles) {
    $filename = $file.Name.Substring(0, 9)
    Write-Host "Checking filename $($filename)"
   
    # Check if the filename contains an ID from the list of IDs extracted from the text file
    if ($filenamesToKeep -contains $filename) {
        Write-Host "Filename $($filename) found in the text file."
    } else {
        Write-Host "Filename $($filename) not found in the text file. Removing file $($file.FullName)."
        Remove-Item -Path $file.FullName -Force
    }
}
