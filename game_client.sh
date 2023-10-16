#Name: Gregory Sin-Chan
#Student ID: 1947636

#script Overview:
#Sending guesses to the other end of a pipe where it will be checked to see if it matches a randomly generated number
#the result is then sent back through the pipe, outputting here if the guess was too high/low or if it was right
#start by giving a name and if ever the player types quit during the guessing phase, it exits

#realpath finds the absolute path of the first argument passed and -e checks if its real
#the script must also take 1 and only 1 file
if [[ -e $(realpath $1) ]] && [ $# -eq 1 ] 
then
	#variable that holds pipe name incase a different pipe is used
	#basename is the opposite of dirname, showing the end of the directory
	#Ex: basename /home/something/test -> test
	pipe=$(basename $1)

	#read gets user input, -p in this context is allowing me to write on the same line as the prompt
	#and assigning the input to the variable $name
	read -p "What is your name? " name
	#sends player name to the server to be used for output 
	echo $name > $pipe #in 1
	echo $name, please guess a number from 0 to 10

	while :
	do
		read -p "$name please enter a number: " guess 
		#sends player guess into pipe, comes out on the server side to be checked
		echo $guess > $pipe #in 2
	
		#if the player types quit, the loop is broken which finishes the script
		if [ $guess == 'quit' ]
		then
			#breaks out of the current loop
			break
		fi

		#tells player if they are too high/low or won
		read line < $pipe #out 3
		echo $line
			
		#greps the result of the guess for the word "won"
		#-c returns the count of returned statements.
		#if the player has won, the count will be greater than 0
		#and the loop will be broken out of
		if [ $(echo $line | grep -c won) -ne 0 ]
		then
			break
		fi
	done
else 
	echo "Incorrect number of arguments or incorrect path"
fi
