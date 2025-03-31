//Problem 2
import java.util.Scanner;
public class CashRegister
{
//the main method ask the user to input a price, but it will end once the user chooses 
//-1

  public static void main(String[] args)
  {
   Scanner input = new Scanner(System.in);
   double price; 
   double total = 0;
   double salesTax = 0.085;
   double totalCounter = 0;
   System.out.print("Enter price (or -1 when finished): ");
   price = input.nextDouble();

   while (price != -1)
   {
    total = total + price;
    totalCounter = totalCounter + 1;
    System.out.print("\nEnter price (or -1 when finished):");
    price = input.nextDouble();
    if (price == -1)
    System.out.printf("Total:$%.2f", total);
    calculateSalesTax(price, total);
    calculateGrandTotal(price,total,salesTax);
   }// end while
  
  }//ends main 
  
//this method calculates the salesTax by using the price from the main method and passing it through this method. With that the total is multipled with the tax and returned to the main method. 

  public static double calculateSalesTax(double price, double t)
  {
   double orginalPrice = price;
   double salesTax = 0.085 * t;
   if(orginalPrice == -1)
   System.out.printf("\nSales Tax: $%.2f", salesTax);
   return salesTax;
  }//end calculateSalesTax

//this method calculates the grand total by passing the price and total to this method. Then it is returned to the main method
  public static double calculateGrandTotal(double price, double t, double s)
  {
   double orginalPrice = price; 
   double grandTotal = (s*t)+t;
   if(orginalPrice == -1)
   System.out.printf("\nGrand Total: $%.2f", grandTotal);
   return grandTotal;
  }//end calculateGrandTotal


}//ends class