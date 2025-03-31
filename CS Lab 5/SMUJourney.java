//Muskaan Mahes, 48546802, Lab 5-Spring 2023
import java.util.Scanner;
import java.util.Random;
public class SMUJourney
{
 static String [] locations;
 static String [] activities; 
 static int [] locationValues;


 public static void main(String[] args)
 {
  Scanner input = new Scanner(System.in); 
  //starting variables for the game
  String playerOne;
  String playerTwo;
  int currentLocationOne = 0;
  int currentLocationTwo = 0;
  int playerOneBalance = 100;
  int playerTwoBalance = 100;
  int winningAmount;

  populateArrays();

 //prompt for user's name
 System.out.print("Enter player 1's name: ");
 playerOne = input.next();

 System.out.print("Enter player 2's name: ");
 playerTwo = input.next();

 //prompt for winning amount
 System.out.print("Enter game winning amount: ");
 winningAmount = input.nextInt();

 //while loop that take turns for each player and gets their current location and balance 
 while(playerOneBalance <= winningAmount || playerTwoBalance <= winningAmount)
 {
   System.out.printf("%s's turn\n", playerOne);
   currentLocationOne = Move(currentLocationOne);
   String locationOne = locations[currentLocationOne];
   System.out.printf("%s landed on %s to %s\n", playerOne, locationOne, activities[currentLocationOne]);
   playerOneBalance = playerOneBalance + getMoney(currentLocationOne);

  System.out.printf("%s's turn\n", playerTwo);
  currentLocationTwo = Move(currentLocationTwo);
  String locationTwo = locations[currentLocationTwo];
  System.out.printf("%s landed on %s to %s\n", playerTwo, locationTwo, activities[currentLocationTwo]);
  playerTwoBalance = playerTwoBalance + getMoney(currentLocationTwo);

 }

//prints the winning player and both player's money and amounts
  System.out.printf("Game over. %s had %d and %s had %d\n", playerOne, playerOneBalance, playerTwo, playerTwoBalance);
 if(playerOneBalance > playerTwoBalance)
 {
  System.out.printf("%s is the winner!!!", playerOne);
 }
 else
 {
  System.out.printf("%s is the winner!!!", playerTwo);
 }
  
 }//end main


//the spin method returns a random number from 1-10
 public static int spin()
 {
   Random rand = new Random();
   int min = 1;
   int max = 10;
   int spinValues = rand.nextInt(max + min) + min;
   return spinValues;
 
 }//end spin


//the move method calls the spin Methof and gets a new location by moving them through the location list
 public static int Move(int currentLocationIndex)
 {
  int value = spin();
  currentLocationIndex = currentLocationIndex + value;
  if(currentLocationIndex > 14)
  {
    currentLocationIndex = currentLocationIndex - 14;
  }
   return currentLocationIndex;


 }//end Move



//the getMoney method determine the amount lost/won and returns the value won or lost
 public static int getMoney(int locationIndex)
 {
   int val = locationValues[locationIndex];
   if(val == 0)
   {
     int a = spin();
     if(a % 2 == 0)
     {
       val = val * 10;
       System.out.printf("Won %d\n", val);
       return val;
      }
       else
       {
         val = val * -10;
         System.out.printf("Lost %d\n", val);
         return val;
       }
        } else {
          if(val == 20)
          {
            System.out.printf("Won $20\n");
            return val;
           }
             else {
             System.out.printf("Lost $10\n");
             return val;
            }
        }


 }//end getMoney


 public static void populateArrays()
 {
  locationValues = new int[15]; 
  locationValues[0] = 0; 
  locationValues[1] = 20; 
  locationValues[2] = -10; 
  locationValues[3] = -10; 
  locationValues[4] = 20; 
  locationValues[5] = -10; 
  locationValues[6] = 20; 
  locationValues[7] = 0; 
  locationValues[8] = 20; 
  locationValues[9] = 20; 
  locationValues[10] = -10; 
  locationValues[11] = 20; 
  locationValues[12] = -10; 
  locationValues[13] = 0; 
  locationValues[14] = -10; 
  locations = new String[15]; 
  locations[0] = "Bishop Boulevard"; 
  locations[1] = "Perkins Theology School"; 
  locations[2] = "Meadows School of the Arts"; 
  locations[3] = "Washburne Soccer Stadium"; 
  locations[4] = "Cox School of Business"; 
  locations[5] = "McFarlin Auditorium"; 
  locations[6] = "Dedman Law Library"; 
  locations[7] = "Dallas Hall"; 
  locations[8] = "Fondren Science"; 
  locations[9] = "Simmons School of Education"; 
  locations[10] = "Hughes-Trigg Student Center"; 
  locations[11] = "Lyle School of Engineering"; 
  locations[12] = "Moody Coliseum"; 
  locations[13] = "Residential commons"; 
  locations[14] = "Ford Stadium"; 
  activities = new String[15]; 
  activities[0] = "admire the campus view"; 
  activities[1] = "take a Theology class"; 
  activities[2] = "attend a concert"; 
  activities[3] = "watch a Soccer"; 
  activities[4] = "take an Accounting Class"; 
  activities[5] = "watch a show"; 
  activities[6] = "study with the Law students"; 
  activities[7] = "see the downtown skyline"; 
  activities[8] = "do an experiment"; 
  activities[9] = "take an Education class"; 
  activities[10] = "get a snack"; 
  activities[11] = "learn Java programming"; 
  activities[12] = "watch a basketball game"; 
  activities[13] = "take a nap"; 
  activities[14] = "cheer for Mustang Football"; 
 }//end populateArrays 


}//end class