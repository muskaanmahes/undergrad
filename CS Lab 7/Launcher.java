//Muskaan Mahes, 48546802, lab 7-Spring 2023
//This is where the data from the other constructor complies into

import java.util.Scanner; 
public class Launcher
  {
   public static void main(String[] args)
    {
    Scanner input = new Scanner(System.in);
//Create new game
    SMUJourney7 game = new SMUJourney7();
//Prompt for winningAmount and send to the game
    System.out.print("How much is needed to win? $ ");
    int amt = input.nextInt();
    game.setWinningAmount(amt);
//prompt for total # of players
    System.out.print("How many players? ");
    int playerCount = input.nextInt();
//Create Players
    for(int x = 1; x <= playerCount; x++)
    {
     System.out.printf("Player #%d name: ",x);
     String name = input.next();
     game.addPlayer(name);
    }
     game.playGame();
    }//end main

  }//end Launcher






