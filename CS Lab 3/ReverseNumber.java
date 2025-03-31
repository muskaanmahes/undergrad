//Problem 4
import java.util.Scanner;
public class ReverseNumber
{
//the main method recieves a number from the user
  static Scanner input = new Scanner(System.in);
  public static void main(String[] args)
  {
   System.out.print("Enter a 4-digit number: ");
   int number;
   number = input.nextInt();
   reverse(number);
   }//end main

//the reverse method uses the number from the main method and reverses it which is then 
//returned to the main method.
   public static int reverse(int number)
   { 
     int orginalNumber = number;
     int reverse1 = 0;
     while(number != 0)
     {
       int remainder = number % 10;
       reverse1 = (reverse1 * 10) + remainder;
       number /= 10;
     }
       System.out.printf("%d in reverse is %d", orginalNumber, reverse1);
       return reverse1;

   }//end reverse
  
  
}//end class