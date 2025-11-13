#!/bin/bash


# ========================================================
# file dependencies
# ========================================================
source ./queue.sh

# ========================================================
# is_game_active the flag that drives the main game loop
# num_rows & num_columns are display's width
# key is the key that user pressed
# ========================================================
is_game_active=0
num_rows=10
num_columns=50
key=0

snake_facing="RIGHT"
queue_new snake_position_x
queue_new snake_position_y
snake_length=3

# disable input buffering
stty -echo -icanon time 0 min 0  
# Clean up on quit script
trap "echo -e \"\e[$((num_rows + 1))B\"; echo Clearing up the screen; sleep 3; stty sane ; clear ; exit" INT EXIT


init() {
    queue_enqueue snake_position_x 0
    queue_enqueue snake_position_y 1
}

print_char() {
    local x="$1"
    local y="$2"

    if queue_find snake_position_x $x && queue_find snake_position_y $y; then
        echo -e -n "x "
    else
        echo -e -n "  "
    fi
}

draw_a_line() {
    echo -n "+"
    for ((i=0; i < $num_columns * 2; i ++)); do echo -n "-"; done
    echo "+"
}

render() {
    y=$num_rows

    draw_a_line

    while [ $y -gt 0 ]
    do 
        echo -n "|"
        x=0
        while [ $x -lt $num_columns ]
        do 
            print_char $x $y
            ((x++))
        done
        echo -e -n "|"
        echo -e ""
        ((y--))
    done

    draw_a_line

    echo -e "\e[$((num_rows + 3))A"
}

handle_input() {
    key=$(dd bs=1 count=1 2>/dev/null)

    if [ "$key" == "w" ]
    then
        snake_facing="UP"
    elif [ "$key" == "d" ]
    then 
        snake_facing="RIGHT"
    elif [ "$key" == "a" ]
    then 
        snake_facing="LEFT"
    elif [ "$key" == "s" ]
    then 
        snake_facing="DOWN"
    elif [ "$key" == "q" ]
    then 
        echo "QUIT"
        QUIT
    else
        echo -n ""
    fi
}

move() {
    local last_x=$(queue_peek_back snake_position_x)
    local last_y=$(queue_peek_back snake_position_y)

    if [ "$snake_facing" == "UP" ]
    then
        queue_enqueue snake_position_x $last_x
        queue_enqueue snake_position_y $(( $last_y + 1 ))
    elif [ "$snake_facing" == "RIGHT" ]
    then 
        queue_enqueue snake_position_x $(( $last_x + 1 ))
        queue_enqueue snake_position_y $last_y 
    elif [ "$snake_facing" == "LEFT" ]
    then 
        queue_enqueue snake_position_x $(( $last_x - 1 ))
        queue_enqueue snake_position_y $last_y 
    else
        queue_enqueue snake_position_x $last_x 
        queue_enqueue snake_position_y $(( $last_y - 1 ))
    fi


    local queue_length=$(queue_size snake_position_x)
    if [[ $queue_length -gt $snake_length ]]; then 
        queue_dequeue snake_position_x > /dev/null
        queue_dequeue snake_position_y > /dev/null
    fi
}

run() {
    handle_input
    move
    render
}

init
while [ $is_game_active ]
do
    run
done