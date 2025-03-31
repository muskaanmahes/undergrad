//Muskaan Mahes, 48546802, lab 8-Spring 2023

import javax.swing.JFrame;
import java.awt.FlowLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class GUISMUJourney extends JFrame
{

//declare variables
 JLabel player1Label, player2Label, winningAmountLabel;
 JButton startButton, oneRoundButton;
 JTextField nameOne, nameTwo, winAnswer;
 JTextArea jta;
 JScrollPane jsp;

 private SMUJourney smu;
 
 public GUISMUJourney()
 {
  super("SMU Journey");
  setLayout(new FlowLayout() );
  TheInnerClass = new TheInnerClass();

  //create label for player 1's name
  add(new JLabel("Player 1 Name: ") );

  player1 = new JLabel();
  add(player1Label);

  //create a textfield for player one to insert their name
  nameOne = new JTextField("Blank");
  nameOne.setEnabled(true);
  add(nameOne);  

  //create a label for player 2's name
  add(new JLabel("Player 2 Name: ") );
  
  player2 = new JLabel();
  add(player2Label);

  //create a text field for player 2 to insert their name;
  nameTwo = new JTextField("Blank");
  nameTwo.setEnabled(true);
  add(nameTwo);  

  //create a label for how winning amount
  add(new JLabel("How much is needed to win?: ") );
  
  winningAmountLabel = new JLabel();
  add(player1Label);

  //create a text field to insert winning amount
  winAnswer = new JTextField("Blank");
  winAnswer.setEnabled(true);
  add(winAnswer);  

  //create a button to start game
  startButton = new JButton("Start Playing!");
  add(startButton);

  //create a button to play round
  oneRoundButton = new JButton("Play One Round");
  add(oneRoundButton);

  //create text area dimensions
  jta = new JTextArea(20, 50);
  jsp = new JScrollPane(jta);
  add(jsp);

  //ActionListerner added to buttons
  InnerGUI listen = new InnerGUI();
  startButton.addActionListener(listen);
  oneRoundButton.addActionListener(listen);  

 }//end constructor






 private class TheInnerClass implements ActionListener
 {
  public void actionPerformed(ActionEvent e)
  {
//if button pressed will enable winAnswer button
   if(e.getSource() == startButton)
   {
    String start = s;
    Int answerWin = Integer.parseInt(start) 
    smu.winAnswer(answerWin);

    winAnswer.setEditable(false);
   } 

   
// if OneRoundbutton is pressed then it will use the playRound() method to get the string returned
   if(e.getSource() == oneRoundButton)
   {
     String s == smu.playRound();
     jta.append(s);

     playRound.setEnabled(true);
   }



   }//end theInnerClass



 }//end TheInnerClass







}//end class