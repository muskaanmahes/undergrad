//Muskaan Mahes,48546802, Lab-7 Spring 2023
import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

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
  File campusMap = new File("places.txt");
   try
   { 
   Scanner inputFile = new Scanner(new File("places.txt") );
   inputFile.useDelimiter(",|\n");

        while(inputFile.hasNext())
       { 
        String area = inputFile.next();
        String activity = inputFile.next();
        int point = inputFile.nextInt();
       }
       
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
   Spinner s = new Spinner(); 
   x = s.spin();
   int c = places.indexOf(y);
    if( c + x > 14)
   
    return places.get(x-15);
    	else
         return places.get(x);
      
   }//end getNextPlace


}//end Campus