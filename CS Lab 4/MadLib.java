import java.util.Scanner;
public class MadLib
{
 
//the chooseWord method uses the string PartofSpeech to get what Part of speech to use from the array words which is returned from the main method.

  public static void chooseWord(String PartofSpeech, String[] words, int number )
  {
    Scanner scan = new Scanner(System.in);
    System.out.printf("Enter " + PartofSpeech + ":");
    String word = scan.nextLine(); //gets the word and then prompts for the next question
    words[number] = word; //the index number is placed in the words array and what the user chooses for their word will be correspondent to the number in the array
  }//end chooseWord

//the printMadLib method prints the story shell by taking what the user has inputed from the arrays from chooseWord into the array with the corresponding number.
  public static void printMadLib(String[] words)
 {
  System.out.printf(" The SMU Dining Hall has really " + words[0] + " food.");
  System.out.printf(" Just thinking about it makes my stomach " + words[1] + ".");
  System.out.printf(" The spaghetti is " + words[2] + " and tastes like a " + words[3] + ".");
  System.out.printf(" One day, I swear one of my meatballs started to " + words[4] + ".");
  System.out.printf(" The tacos are totally " + words[5] + " and look kind of like old " + words[6] + ".");
  System.out.printf(" The meatloaf is actually popular, even though it's " + words[7] + " and " + words[8] + ".");
  System.out.printf(" I call it Mystery Meatloaf and think it's really made out of " + words[9] + ".");
 }//end 

//the main method creates a string that states which type of part of speech needs to be inputed by the user. 
 public static void main(String[] args)
  {
    String [] words = new String [ 10 ];
 
    chooseWord("adjective", words, 0);
    chooseWord("Verb",words,1);
    chooseWord("adjective",words,2);
    chooseWord("noun",words,3);
    chooseWord("verb",words,4);
    chooseWord("adjective",words,5);
    chooseWord("noun",words,6);
    chooseWord("adjective",words,7);
    chooseWord("adjective",words,8);
    chooseWord("plural noun",words,9);
    printMadLib(words);
  }//end main 



}// end class 