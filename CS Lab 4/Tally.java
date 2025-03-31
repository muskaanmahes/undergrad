import java.util.Scanner;
public class Tally
{
//the main method prompts for the user to choose an integer 
  public static void main(String[] args)
  {
   Scanner input = new Scanner(System.in);
   System.out.print("Enter an integer: ");
   int number = input.nextInt(); //will print the result of the number on the next line
   String tally = tally(number); // where the tally method is returned
   System.out.printf("Result: %s", tally(number) );

  }//end main

//the tally method converts the numbers into a string
  public static String tally(int number)
  {
    String answer = " ";

  int TenXCounter = number/10; //takes the number inputted and divides it by ten and places in a counter for the for loop
  for(int i = 0; i < TenXCounter; i++) 
  {
   answer += "X"; //the loop will display the 10's in the number inputted as "X"
  }
    

   number -= TenXCounter * 10; //takes the number inputted and multiples it by 10 and places it in the for loop
   int FiveVCounter = number/5;
   for(int i = 0; i < FiveVCounter; i++)//loop that starts the FiveCounter
   {
    answer += "V";//the loop will display the 5's in the number inputted as "V"
   }

     number -= FiveVCounter * 5;//takes the number inputted and multiples it by 5 and places it in the for loop
     for( int i = 0; i < number; i++)
     {
      answer += "|";// the loop will display the remainder of the numbers (1-4) as "|"
     }
       return answer;

  }//end String Tally


}//end class