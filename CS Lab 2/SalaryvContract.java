//Muskaan Mahes, 48546802, Lab 2-Spring 2023
//Problem 1: Salary vs Contract
import java.util.Scanner;
public class SalaryvContract
{
   public static void main(String [] args)
   {

//prompts the user to input their values that are related to their annual salary and contract rate
   Scanner input = new Scanner(System.in);
   System.out.print("Enter annual salary:");
   double annualSalary = input.nextDouble();

   System.out.print("Enter hourly contract rate:");
   double contractRate = input.nextDouble();

   System.out.print("Enter project duration in months:");
   double durationMonths = input.nextDouble();

   System.out.print("Enter work hours per day:");
   double workHours = input.nextDouble();

   System.out.print("Enter work days per month:");
   double workDays = input.nextDouble();

   System.out.print("Enter holidays:");
   double numHolidays = input.nextDouble();

   System.out.print("Enter vacation days:");
   double vacationDays = input.nextDouble();


//provides the math for the Salaried gross income
   double salariedgrossIncome = annualSalary/12 * durationMonths;
   System.out.println("\n Salaried:");
   System.out.printf("Gross Income:$ %,.2f" , salariedgrossIncome);


//next lines are to find the contract gross income, gross difference, medical insurance,
//self employement tax, unpaid holidays, and unpaid vacation
   double grossIncome = 42 * 8 * 5 * contractRate;
   System.out.println("\n Contract:");
   System.out.printf("Gross Income:$ %,.2f\n", grossIncome);

   double grossDifference = grossIncome - salariedgrossIncome;
   System.out.printf("Gross Difference: $ %,.2f\n", grossDifference);
   
   double medInsurance = 1000 * durationMonths;
   System.out.printf("Medical Insurance: $ %,.2f\n", medInsurance);
 
   double selfTax = grossIncome * 0.15;
   System.out.printf("Self employment tax: $ %,.2f\n", selfTax);

   double unpaidHolidays = numHolidays * contractRate * workHours;
   System.out.printf("Unpaid holidays: $ %,.2f\n", unpaidHolidays);
 
   double unpaidVacation = vacationDays * contractRate * workHours;
   System.out.printf("Unpaid vacation: $ %,.2f\n", unpaidVacation);
  
   double netDifference = selfTax - medInsurance - 26.67;
   System.out.printf("\n Net difference: $ %,.2f\n", netDifference);


}//end main 
 } //end class SalaryvContract

















