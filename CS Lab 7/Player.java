//Muskaan Mahes, 48546802, lab 7-Spring 2023
//Within this constructor it creates takeTurn method which will give us the players 
//location and their current value they have in their balance

public class Player
{
 private String name;
 private int money;
 private Place location;



  public void takeTurn(Campus7 loc, Spinner v)
  {
   int num = v.spin();
   location = loc.getNextPlace(location, num);
   money += location.getPlaceAmount(num);
   System.out.printf("%s landed on %s to %s\n", name, location.getName(), location.getActivity() );
 
   System.out.printf("%s now was $%d\n", name, money);
  }


 public void setName(String n)
 {
  name = n;
 }

 public String getName()
 {
  return name;
 }

 public void setMoney(int x)
 {
  money = x;
 }

 public int getMoney()
 {
  return money;
 }

 public Player(String n, int x, Place y)
 {
   money = x;
   name = n;
   location = y;
 }
  

 public String toString()
 {
  return "Money: " + money + "Name: " + name + "Location: " + location;
 }


}//end class