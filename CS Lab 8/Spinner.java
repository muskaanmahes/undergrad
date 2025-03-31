//Muskaan Mahes, 48546802, lab 7-Spring 2023
//The spin method gives the player a random number from 1-10 and depending on that value
//will state how much they need to move


import java.util.Random;
  public class Spinner
  {
   private int value;

 public int spin()
 {
   Random rand = new Random();
   value = rand.nextInt(10)+1;
   return value;
 }

 public void setValue(int x)
 {
  value = x;
 }

 public int getValue()
 {
  return value;
 }
 

 public String toString()
 {
   return "Random Value: " + value;
 }


}//end class