//Muskaan Mahes,48546802, Lab-7 Spring 2023
import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;

public class Campus7
{
 private ArrayList<Place> places;

 public Campus7()
 {
  places = new ArrayList<Place>();
  createPlaces();
 }


 public void createPlaces()
 {
   try
   { 
   Scanner inputFile = new Scanner(new File("places.txt") );
   inputFile.useDelimiter(",|\n");

        while(inputFile.hasNext() )
       {
        String line = inputFile.next();
        String[] placement = line.split(",");
        String name = placement[0];
        String activity = placement[1];
        int value = Integer.parseInt(placement[2]);
        Place place = new Place(name, activity, value);
        places.add(place);
       }
        inputFile.close();
     }
      catch(Exception e)
      {
       System.out.println("Error reading file");
      }
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