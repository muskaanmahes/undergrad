//Muskaan Mahes, 48546802, Lab 8-Spring 2023

import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;
import java.io.PrintWriter;

public class SMUJourney7
{
  private int winningAmount;
  private ArrayList<Player> players;
  private Campus7 theCampus;
  private Spinner theSpinner;
  Player winner;
  
 

  public SMUJourney7()
  {
   players = new ArrayList<Player>();
   theCampus = new Campus7();
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
     
     enterBonusRound(players.get(i) );

             loop = false;
             break;
        }
     }
   }// end while loop
   } 

  }//end playGame
   
 public void enterBonusRound(Player winner)
 {
   System.out.printf("Would you like to keep playing? (y/n)\n", winner.getName() );
   Scanner input = new Scanner(System.in);
   String answer = input.nextLine();
    if(answer.equals("y") )
    {
     theSpinner = new EvenSpinner();
     while(true)
     {
       winner.takeTurn(theCampus, theSpinner);
       if(winner.getMoney() < 0)
       {
         System.out.printf("\nGame over %s lost", winner.getName() );
         break;
        }
         System.out.printf("\nWould you like to keep playing?", winner.getName() );
         answer = input.nextLine();
         if(answer.equals("n") )
         {
          break;
         }
       }
      }
       else
       {
         System.out.println("\nGame over for real this time /nVoucher creation complete. Good-bye!");
           createVoucher(winner);
       }
    }//end enterBonusRound
 
 public void createVoucher(Player winner)
 {
  try
  {
   File voucherFile = new File("voucher.txt");
   PrintWriter pw = new PrintWriter(voucherFile);
   pw.printf("Your voucher is being created...");
   pw.close();
  }
 catch(Exception e)
 { 
  System.out.println("Error writing file");
 }    
 }

//added for GUI 
//return a boolean that indicates whether or not a player has won 
 public booleans checkForWinner(int playerNum)
 {
  Player p = players.get(playerNum);
  if(p.getMoney() >= winningAmount)
     return true;
  else
     return false;
 }

}//end SMUJourney