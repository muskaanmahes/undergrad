//Muskaan Mahes, 48546802, Lab 7-Spring 2023

import java.util.Random;
import java.util.Scanner;
public class EvenSpinner extends Spinner
{

 public EvenSpinner()
 {
   super();
 }

 public int spin()
 {
  int value = super.spin();
  
   while(value % 2 == 1)
    value = super.spin();
    return value;
 }//end spin



}//end class