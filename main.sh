#!/bin/bash


# ========================================================
# is_game_active the flag that drives the main game loop
# num_rows & num_columns are display's width
# key is the key that user pressed
# ========================================================
is_game_active=0
num_rows=10
num_columns=50
count=0
key=0


# disable input buffering
stty -echo -icanon time 0 min 0  
# Clean up on quit script
trap "echo -e \"\e[$((num_rows + 1))B\"; echo Clearing up the screen; sleep 3; stty sane ; clear; exit" INT EXIT



render() {
    x=0
    while [ $x -lt $num_rows ]
    do 
        y=0
        while [ $y -lt $num_columns ]
        do 
            echo -e -n "x"
            ((y++))
        done
        echo -e ""
        ((x++))
    done
    echo -e "\e[$((num_rows + 1))A"
}

run() {
    key=$(dd bs=1 count=1 2>/dev/null)
    if [ "$key" == "w" ]
    then
        echo "UP"
    elif [ "$key" == "d" ]
    then 
        echo "RIGHT"
    elif [ "$key" == "a" ]
    then 
        echo "LEFT"
    elif [ "$key" == "s" ]
    then 
        echo "DOWN"
    elif [ "$key" == "q" ]
    then 
        echo "QUIT"
        QUIT
    else
        echo "DONT KNOW COMMAND"
    fi
    # render
}

while [ $is_game_active ]
do
    run
    sleep 2
done

stty sane 