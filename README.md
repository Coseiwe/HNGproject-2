# HNGproject-2
User Management Script (create_users.sh)
This Bash script automates user management tasks on a Linux system based on input from a user list file. It creates users, manages groups, sets up home directories with appropriate permissions, generates passwords, and logs all actions for auditing purposes.


Features
User Creation: Creates new users on the system.
Group Management: Handles user group assignments.
Home Directory Setup: Ensures correct permissions and ownership for user home directories.
Password Generation: Generates random passwords securely.
Logging: Logs all script actions to /var/log/user_management.log.
Error Handling: Gracefully manages errors such as existing users or group creation failures.

Requirements
Operating System: Linux-based OS (tested on Ubuntu).
Bash Shell: Scripting language used for automation.
User List File: Input file (user_list.txt) containing usernames and associated groups in the format username;groups.


Usage
Clone the Repository:

git clone <repository-url>
cd <repository-directory>

Set Permissions:
Ensure create_users.sh has executable permissions:
chmod +x create_users.sh

Prepare User List File:
Create a file named user_list.txt with entries formatted as:

username1;group1,group2
username2;group3

Execute the Script:
Run the script providing the user list file as an argument:

./create_users.sh user_list.txt

View Logs:
Logs of script actions are stored in /var/log/user_management.log.



Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or a pull request in this repository.

License
This project is licensed under the MIT License.

