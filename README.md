# Grading Helper

Function for W271 Graders to do the following:  

1. Clone student repositories
2. Pull weekly student work into its own branch

Required:  
`student_list.txt` file with each student GitHub handle on its own line

Args:  
   `-w` : week number (int between 1 - 14)  
   `-d` : due datetime (e.g. `2018-09-17 16:00:00`)  
   
Example Call:  
`./grading_helper.sh -w 2 -d '2018-09-17 16:00:00'`

If the script is executed without -w or -d flags, it will just clone all student repositories based on the schema `f18-<handle>` in which <handle> is provided by the `student-list.txt` file.

# Getting Started

1. Create a directory for each section (e.g. `section-01`)

2. Copy `grading_helper.sh` and `student-list.txt` into the directory

3. Edit `student-list.txt` to include handle names for those specific sections

4. To clone all student repositories run `./grading_helper.sh` without arguments
   from the section directory.
   
5. You can also specify a deadline and run with the following arguments
   `./grading_helper.sh -w 2 -d '2018-09-17 16:00:00'`
   This action will create a branch named `week-2` and pull all commits before '2018-09-17 16:00:00'
   
6. For each week, change the `-w` and `-d` parameter to pull commits up to
   the deadline period and checkout into that branch
   
If no arguments are provided, it will simply try and clone all repositories.

# Configuration

These scripts were written with a single class in mind, thus there are some hardcoded values in the shell script that need to be updated to be used with other classes. Currently this is configured to work for W271 Fall 2018 student repositories. In particular the following code should be updated:

 - Any occurrence of `f18-$i` should be updated to reflect the repo naming schema
 - `--committer=steveyang90 --invert-grep` This line is a little hacky... Mainly it's to avoid picking up my own commits (e.g. course material updates) when they interfere with picking up student work that was commited before the deadline. For example, if a student commits before a deadline, and I subsequently commit some course updates unrelated to the assingment, checking out my commit would result in a state that does not have the student assignment submission. This line prevents my commit from being collected.
