#!/bin/bash

is_game_active=0
num_rows=10
num_columns=50
count=0

trap "echo -e \"\e[$((num_rows + 1))B\"; echo Clearing up the screen; sleep 3; clear; exit" INT EXIT

render() {
    x=0
    while [ $x -lt $num_rows ]
    do 
        y=0
        while [ $y -lt $num_columns ]
        do 
            echo -e -n "$count"
            ((y++))
        done
        echo -e ""
        ((x++))
    done
    echo -e "\e[$((num_rows + 1))A"
    ((count++))
}

run() {
    render
}

while [ $is_game_active ]
do
    run
    sleep 2
done