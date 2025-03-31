import java.util.Scanner;
import java.util.Random;
public class LifeIsAGamble
{

 static Scanner input = new Scanner(System.in);

 //the main method will give the user the option on whether they want to play the game or not by using a loop.
 public static void main(String[] args)
 {
  System.out.print("WELCOME TO LIFE IS A GAME!");
  boolean playing = true;//the boolean expression will continue to the game as a loop
  int Value = 20; //starting value
  while(playing)
  {
   System.out.print("\nSpin? (Y/N): ");
   String choice = input.next();
      if (choice.equalsIgnoreCase("N") ) 
       { 
       System.out.printf("\nDone playing - you now have $%d", Value);
       playing = false; //the game will stop if the user chooses "N" and it will show their current value
       break;
       } 

    Random rand = new Random();
 
    if(choice.equalsIgnoreCase("Y") )
    {
     System.out.println("\nYou paid $5 to take a turn");
     Value -= 5;
     System.out.printf("\nYou now have $%d", Value);//will take the current value the player has and subtract 5 from it. 
     
     int result = spin();// where the spin method is returned
     System.out.printf("\nSpun %d", result); //will show what value was choosen
     Value += result; //will add the current value to the final result
    }
       int winningValue = Value - 20;
       if(winningValue > 0) //if the current value is greater then zero than it will state the value won from the game
       {
        System.out.printf("\nYou won $%d.", winningValue);
       }
          else if(winningValue < 0) // if current value is less than zero then it will state what you lost from the game
         {
          System.out.printf("\nYou lost $%d.", Math.abs(winningValue) );
         }
          else
          {
           System.out.println("\nYou broke even.");
          }
  }
 }//end main

//The spin method uses the random array which chooses a number from 1-10.
 public static int spin()
 {
  Random rand = new Random();
  int spin1;
  spin1 = rand.nextInt(10)+1;
  return spin1;
 }//end spin




}//end class