//Muskaan Mahes, 48546802, Lab 6-Spring 2023
//within this method, it creates several methods where you get the winning Amount from 
//what the user inputted, it gets the player's and their starting balance, and allows 
//the player to take turns

import java.util.ArrayList;
import java.util.Scanner;
public class SMUJourney
{
  private int winningAmount;
  private ArrayList<Player> players;
  private Campus theCampus;
  private Spinner theSpinner;

  public SMUJourney()
  {
   players = new ArrayList<Player>();
   theCampus = new Campus();
   winningAmount = 0;
   theSpinner = new Spinner();
  }

  public void setWinningAmount(int x)
  {
    winningAmount = x;
  }

  public int getWinningAmount()
  {
   return winningAmount;
  }
   

  public void addPlayer(String s)
  {
   players.add(new Player(s, 100, theCampus.getFirstPlace() ) );
  }

  public void playGame()
  {
    Scanner input = new Scanner(System.in);

    boolean loop = true;
   while(loop)
   {
    for(int i = 0; i < players.size(); i++)
    { 
     players.get(i).takeTurn(theCampus, theSpinner);
    {
       if(players.get(i).getMoney() >= winningAmount)
       {
        System.out.printf("\nGame over. %s has $%d\n", players.get(i).getName(), players.get(i).getMoney() );

        System.out.printf("%s is the winner!", players.get(i).getName() );

             loop = false;
             break;
        }
     }
   }// end while loop
   } 

  }//end playGame



}//end SMUJourney