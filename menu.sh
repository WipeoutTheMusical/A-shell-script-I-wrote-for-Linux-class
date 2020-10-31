#!/bin/bash

#Braden Bender 
#CS140u
#November 28, 2019
#The function below prompts the user for a year between 1950 and 2020, and a month, and prints the calendar month from the year selected
    specific_date () {
        year="0"

        while [ "$year" -lt 1950 ] || [ "$year" -gt 2020 ]; do #sets a range of years that can be entered
            echo "Please enter a four digit year betweeen 1950 and 2020 you would like to view the calendar for"
            read "year"
            if [ "$year" -lt 1950 ] || [ "$year" -gt 2020 ]
            then
                echo "Invalid year entered"
            fi
        done
        month="0"

        while [ "$month" -lt 1 ] || [ "$month" -gt 12 ]; do #sets a rand of months that can be entered
            echo "Please enter a 2 digit month that you would like to view the calendar for."
            read "month"
            if [ "$month" -lt 1 ] || [ "$month" -gt 12 ]
            then
                echo "Invalid month entered"
            fi
        done
        cal "$month" "$year" #takes the year and month and prints the calendar month selected
    }
#The Function below prompts the user for a directory change, and checks if the entered path is a file
    change_directory () {
        path="none"
        c="cd"
        home="~"
        l="ls"
        ls
        until [ "$path" = "quit" ] && [ "$path" != " " ] #If nothing is entered, the function defaults to the home directory
        do
            read -p "Please enter the path of the desired directory. The default directory is your home directory.  To exit, type 'quit'" path
            if [ "$path" != "quit" ] && [ "$path" != " " ]
            then
                if [ -d $path ]
                then
                    eval "$c" "$path" 
                    pwd
                    eval "$l" "$path"
                else
                    echo "Not a directory"
                fi
            elif [ "$path" = " " ]
            then
                eval "$c" "$home"
                pwd
                eval "$l" "$home"
            fi
        done
    }
# The Function below checks if a file is a text file, and opens it in vi if it is a text file
    open_file_in_vi () {

        filename="none"
        yesno="none"
        while [ "$yesno" != "n" ]; do
            read -p "What is the file that you would like to open with vi?" filename
            if [ -e "$filename" ] && [ -f "$filename" ] #checks the file specified to make sure it exists, and is a regular file
            then
                file -b "$filename" | grep 'text' #checks the output of the file command for the string "text"
                if [ "$?" = "0" ] #checks the exit code of the last command, and if it equals 0, executes the code under the if statement
                then
                    vi "$filename" #opens the specified file in vi
                    read -p "Would you like to continue? y/n" yesno
                else
                    echo "The file selected is not a text file."
                    read -p "Would you like to select a different file? y/n" yesno
                fi
            else
                echo "The selected file does not exist."
                read -p "Would you like to create this file? y/n" createfile
                if [ "$createfile" = "y" ]
                then
                    vi "$filename"
                else
                    read -p "Would you like to continue? y/n" yesno
                fi
            fi
        done
    }
    send_message () {
        read -p "What is the subject of the email?" subject
        read -p "Which user would you like to send the message to?" user
        grep "$user" /etc/passwd

        if [ "$?" = "0" ]
        then
            read  -p "Which file would you like to attach to the email?" attachmentname
            if [ -e "$attachmentname" ] && [ -f "$attachmentname" ]
            then
                file -b "$attachmentname" | grep 'text' 
                if [ "$?" = "0" ]
                then 
                    mail "$subject" "$user" < "$attachmentname"
                else
                    echo "The attachment is not a text file. Please try again."
                fi
            else
                echo "The attempted attachment failed because the file either does not exist, or is a directory."
            fi
        else
            echo "User not found, please try again."
        fi

    }
answer="none"
until [ "$answer" =  "9" ] #Sets an exit condition

do
echo "Welcome to Braden's main menu"

echo "Please choose an option from the following"

echo "1. Display users currently logged in" #The following lines list the options for the user.

echo "2. Display a calendar for a specified month and year"

echo "3. Display the current directory path"

echo "4. Change directory"

echo "5. Long listing of visible files in the current directory"

echo "6. Display current time, date, and calendar"

echo "7. Start the vi editor" 

echo "8. Email a file to a user"

echo "9. Quit"

read -p "Please choose an option from the list above" answer #reads input from the user and sets answer equal to the input

echo

case $answer in #runs commands based on user input

1)
    who | more
    ;;

2)
    specific_date
    ;;
3)
    pwd
    ;;
4)
    change_directory  #calls the function change_directory
    ;;
5)
    ls -l | more #lists the files and details of the files in the working directory, and pipes the output to more 
    ;;
6)  
    date
    cal
    ;;
7)
    open_file_in_vi #calls the function open_file_in_vi
    ;;
8)
    send_message #calls the function send_message
    ;;
9)  echo "Quitting Program" #indicates to the user that the program is being terminated
    ;;

esac

read -n1 -r -p "Press Space to Continue..." key #waits for user input to continue

clear

done
