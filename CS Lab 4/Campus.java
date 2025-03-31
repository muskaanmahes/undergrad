//Muskaan Mahes, 48546802, lab 6-Spring 2023
//Within this constructor it uses the array and places it in a list which then is used in
//the different place methods to get their location and how many points they have lost

import java.util.ArrayList;
public class Campus
{
 private ArrayList<Place> places;

 public Campus()
 {
  places = new ArrayList<Place>();
  createPlaces();
 }


 public void createPlaces()
 {
  places.add(new Place("Bishop Boulevard","admire the campus view",0));
  places.add(new Place("Perkins Theology School","visit the chapel",20));
  places.add(new Place("Meadows","attend a concert",-10));
  places.add(new Place("Washburne Soccer Stadium","cheer for the soccer team",-10));
  places.add(new Place("Cox School of Business","take a class",20));
  places.add(new Place("McFarlin Auditorium","watch a show",-10));
  places.add(new Place("Dedman Law Library","study",20));
  places.add(new Place("Dallas Hall","see the downtown skyline",0));
  places.add(new Place("Fondren Science","do an experiment",20));
  places.add(new Place("Simmons","take a class",20));
  places.add(new Place("Hughes-Trigg Student Center","get a snack",-10));
  places.add(new Place("Lyle","learn Java programming",20));
  places.add(new Place("Moody","watch a basketball game",-10));
  places.add(new Place("Residential Commons","take a nap",0));
  places.add(new Place("Ford Stadium","cheer for Mustang football",-10));
 }//end createPlaces


  public Place getFirstPlace()
  {
   return places.get(0);
  }

  public Place getNextPlace(Place y, int x)
  {
   int c = places.indexOf(y);
    if( c + x < 15)
    { 
      c += x;
    }
     else
     {
       c = (c + x) - 14;
     }
       System.out.printf("\nSpun: %d\n", x);
       return places.get(c);
   }//end getNextPlace


}//end Campus