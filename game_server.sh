#name: Gregory Sin-Chan
#Student ID 1947636

#script Overview:
#Generates a random from 0-10. Another terminal opens the other end of the pipe and sends guesses 
#This scipt checks the client side input to see if the number matches the random one and...
#notifies the player if they are too high/low or if they have won by sending a message back through the pipe, which is read on the other end


#Making a variable for the pipe so that it's easier to change the name
pipe="asg3_game"

#delete the existing pipe just to make sure it's not clogged
#realpath gets the absolute path of the file
rm $(realpath $pipe) 2>/dev/null
#make new pipe where ever the script is run
mkfifo $pipe

#Prints pipe path so client knows where to get the pipe
echo Game Server has started, using pipe: $(realpath $pipe)


while :
do
#makes a random number that has to be guessed
num=$RANDOM
let " num= $num%10 "

#prompts user that it is waiting to receive input on the client side
echo Waiting for player
#Player is being asked there name on client side
name=$(cat < $pipe) #out 1


win=0
#when the player wins, $win is set to 1 and the loop will end, allowing the next player to play
while [ $win -ne 1 ]
do
echo Still playing with $name
#client guesses number
#server stores guess
guess=$(cat < $pipe) #out 2
if [[ $guess -eq $num ]]
then
	win=1
	echo $name has won! > $pipe #in 3
	echo $name has won
elif [ $guess == 'quit' ]
then
	break

elif [[ $guess -gt $num ]]
then
	echo Guess is too high > $pipe #in 3
else
	echo Guess is too low > $pipe #in 3
fi
done

done
