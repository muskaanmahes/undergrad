//Problem 3
import java.util.Scanner;
public class CheckerBoard
{
 //the main method gets the character and size from what the user inputs. 
  public static void main(String[] args)
  {
   Scanner input = new Scanner(System.in);
   System.out.print("Enter character for blocked squares: ");
   String option = input.next();
   System.out.print("Enter size of the checker board: ");
   int size = input.nextInt();
   printCheckerBoard(size, option);
  }//end main

//this method uses for loops and if statements to choose which bracket will have the character in it. 
  public static void printCheckerBoard(int size, String option)
  {
    for(int i=0; i<size; i++)
    {
       for(int a = 0; a<size; a++)
       {
          if(i%2 == 0)
          {
            if(a%2 == 0)
            System.out.printf("[%s]", option);
         else
         System.out.print("[ ]");
       }//end if
        else
     {
         if(a%2 == 0)
            System.out.print("[ ]");
         else 
            System.out.printf("[%s]", option);
     }//end else
    }//end a loop
   }//end i loop
   
   System.out.printf("\n");


  }//end printCheckerBoard



}//end class