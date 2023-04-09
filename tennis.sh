#!/bin/bash
sum1=50
sum2=50
ball="0"
game_on=true
number1=0
number2=0


welcome_message() {
  echo " Player 1: $sum1         Player 2: $sum2  "
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " |       |       O       |       | "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "

}
player_pick(){
    echo "PLAYER 1 PICK A NUMBER: "
    read -s number1
    if [[ $number1 =~ ^[0-9]+$ ]]; then
        if [ $number1 -gt $sum1 ] || [ $number1 -lt 0 ]; then
        echo "NOT A VALID MOVE !"
        player_pick
        return;
        else
        sum1=$((sum1-number1))
        fi
    else
        echo "NOT A VALID MOVE !"
        player_pick
        return;  
    fi     
    echo "PLAYER 2 PICK A NUMBER: "
    read -s number2
    if [[ $number2 =~ ^[0-9]+$ ]]; then
        if [ $number2 -gt $sum2 ] || [ $number2 -lt 0 ]; then
        echo "NOT A VALID MOVE !"
        player_pick
        else
        sum2=$((sum2-number2))
        fi
    else
        echo "NOT A VALID MOVE !"
        player_pick
        return; 
    fi 
    if [ $number1 -gt $number2 ]; then
        case $ball in
    "1")
        ball="2"
        ;;
        
    "2")
        ball="3"
        ;;
    "0")
        ball="1"
        ;;
    "-1")
        ball="1"
        ;;        
    "-2")
        ball="1"
        ;;   
    *)
        esac
    fi

    if [ $number1 -lt $number2 ]; then
        case $ball in
    "-1")
        ball=-"2"
        ;;
        
    "-2")
        ball="-3"
        ;;
    "0")
        ball="-1"
        ;;
    "1")
        ball="-1"
        ;;        
    "2")
        ball="-1"
        ;;   
    *)
        esac
    fi  

}

print_board(){
  echo " Player 1: $sum1         Player 2: $sum2  "
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
        case $ball in
    "1")
        echo " |       |       #   O   |       | "
        ;;
        
    "2")
        echo " |       |       #       |   O   | "       
        ;;
    "3")
        echo " |       |       #       |       |O"        
        ;;
    "0")
        echo " |       |       O       |       | "
        ;;
    "-1")
        echo " |       |   O   #       |       | "
        ;;        
    "-2")
        echo " |   O   |       #       |       | "
        ;;   
    "-3")
        echo "O|       |       #       |       | "
        ;;   
    *)
        esac

  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "
  echo -e "       Player 1 played: ${number1}\n       Player 2 played: ${number2}\n\n"

}


check_winner(){
    if [ $ball == "-3" ]; then
        echo "PLAYER 2 WINS !"
        game_on=false
        return;
    fi
    if [ $ball == "3" ]; then
        echo "PLAYER 1 WINS !"
        game_on=false
        return;
    fi
    if [ $sum1 == 0 ] && [ $sum2 -gt 0 ]; then
        echo "PLAYER 2 WINS !"
        game_on=false
        return;
    fi
    if [ $sum2 == 0 ] && [ $sum1 -gt 0 ]; then
        echo "PLAYER 1 WINS !"
        game_on=false
        return;
    fi   
    if [ $sum1 == 0 ] && [ $sum2 == 0 ]; then
        case $ball in
    "-3" | "-2" | "-1")
        echo "PLAYER 2 WINS !"
        game_on=false
        return
        ;;
    "1" | "2" | "3")
        echo "PLAYER 1 WINS !"
        game_on=false
        return
        ;;
    "0")
        echo "IT'S A DRAW !"
        ;;
    *)
        esac
    fi
    
}

welcome_message
while $game_on
do
  player_pick
  print_board
  check_winner
done
