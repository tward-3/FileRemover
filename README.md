# FileRemover
This script will automatically remove files in a specified directory based on a text file list.

## You will need:
- **A text file** (.txt) containing a list of some sort identifier that specifies the files you want removed
    - Note: The identifier should be present at the beginning of the file name. For example,
      - File names: Subj1_file.jpg, Subj2_file.jpg
      - Text file list: Subj1, Subj2
- **The directory** containing those files to be removed
    - Note: The directory can also contain files you want to keep. Just make sure their IDs are not in your .txt file

The script uses GUIs to allow the user to select the directory and text file, so they don't actually have to edit any code. 

## How it works:
1) The script asks you to select the directory and the text file, and will ask for the character length of the ID
2) It checks the name of each file in that directory to see if it contains an ID that was provided in the text file
3) After you confirm, it deletes any file (or subfolder) within that directory that contains an ID from your list, and keeps any file (or folder) whose ID is not on your list
