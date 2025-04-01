//Muskaan Mahes, 48546802, Lab 2-Spring 2023
//Problem 2: Salary Problem

import java.util.Scanner;
public class annualSalary
{ 
  public static void main(String [] args)
  {
   Scanner input = new Scanner(System.in);
//prompts the user to enter their salary and raise 
   System.out.print("Enter starting salary:");
   double startingSalary = input.nextDouble();
   System.out.print("Enter starting raise:");
   double startingRaise = input.nextDouble();

//declares the variables for each specific salary and raise
  double salaryCounter; 
  double percent;
  int startingYear;
  int year = 1;
  double salaryTwo;
  double raiseTwo;
  double salaryThree;
  double raiseThree;
  double salaryFour;
  double raiseFour;
  double salaryFive;
  double raiseFive;
  double salarySix;
  double raiseSix;
  double salarySeven;
  double raiseSeven;
  double salaryEight;
  double raiseEight;
  double salaryNine;
  double raiseNine;
  double salaryTen;
  double raiseTen;
  double totalSum;
 
//initialize the variables to specific values or formulas
  salaryCounter = 10;
  startingYear = 0;
  year = startingYear + 1;
  percent = startingRaise - 0.1;
  salaryTwo = (0.51 * 0.1 * startingSalary) + startingSalary;
  raiseTwo = startingRaise - 0.1;
  salaryThree = (0.5 * 0.1 * salaryTwo) + salaryTwo;
  raiseThree = raiseTwo - 0.1;
  salaryFour = (0.49 * 0.1 * salaryThree) + salaryThree;
  raiseFour = raiseThree - 0.1;
  salaryFive = (0.48 * 0.1 * salaryFour) + salaryFour;
  raiseFive = raiseFour - 0.1;
  salarySix = (0.47 * 0.1 * salaryFive) + salaryFive;
  raiseSix = raiseFive - 0.1;
  salarySeven = (0.46 * 0.1 * salarySix) + salarySix;
  raiseSeven = raiseSix - 0.1;
  salaryEight = (0.45 * 0.1 * salarySeven) + salarySeven;
  raiseEight = raiseSeven - 0.1;
  salaryNine = (0.44 * 0.1 * salaryEight) + salaryEight;
  raiseNine = raiseEight - 0.1;
  salaryTen = (0.43 * 0.1 * salaryNine) + salaryNine;
  raiseTen = raiseNine - 0.1;
  totalSum = startingYear + salaryTwo + salaryThree + salaryFour + salaryFive + salarySix + salarySeven + salaryEight + salaryNine + salaryTen;
   
// starts a loop for the each year which will list the salary and raise
     while (salaryCounter <= 10)
   {
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, startingSalary,startingRaise);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryTwo, raiseTwo);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryThree, raiseThree);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryFour, raiseFour);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryFive, raiseFive);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salarySix, raiseSix);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salarySeven, raiseSeven);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryEight, raiseEight);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryNine, raiseNine);
       System.out.printf("Year %d: $ %,.2f\n %,.2f%% \n", year++, salaryTen, raiseTen);
       System.out.printf("Total: $ %,.2f\n", totalSum);
       ++salaryCounter;
       ++startingYear;
     

  }
    System.out.println();
   
  


}
}