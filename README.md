# workflow-automation
scripts of dialy tasks at my work

# Content
* File Search and Archiving Script: This PowerShell scripts searches a directory and its subdirectories for files that haven't been modified in 2 years. The directory is an optional command parameter with a default value. The script creates a JSON file that lists all the affected files, limits the search to the top level of the directory tree, and compresses each folder into a ZIP archive. The archive files are then moved to a target directory, and the original directory is moved to a backup directory.
* Script Create Projecfolder: create default layout of a working directory
