//Muskaan Mahes, 48546802, lab 7-Spring 2023
//The place constructor calculates the values for each player depending on their location

public class Place
{
 private String name;
 private String activity;
 private int value;


 public int getPlaceAmount(int SpinValue)
 {
   int Money = value;
    if(Money == 0)
    {
      System.out.printf("Spinning for win/loss amount...Spun %d\n", SpinValue);
      }

       if(SpinValue % 2 == 0) 
       {
        Money = SpinValue * 10;
       }

        else 
        {
          Money = SpinValue * -10;
        }
        
    if(Money > 0)
    {
     System.out.printf("Earned $ %d\n", Money);
    }
      
      else
      {
        System.out.printf("Lost $ %d\n", Money);
      }
       return Money;

 }//end getPlaceAmount


 public void setName(String n)
 {
  name = n;
 }

 public String getName()
 {
  return name;
 }

 public void setActivity(String a)
 {
  activity = a;
 }

 public String getActivity()
 {
  return activity;
 }

 public void setValue(int x)
 {
  value = x;
 }

 public int getValue()
 {
  return value;
 }

 public Place(String n, String a, int x)
 {
  setName(n);
  setActivity(a);
  setValue(x);
 }

 public String toString()
 {
  return "Name: " + name + "Activity: " + activity + "Value: " + value;
 }

}//end class 