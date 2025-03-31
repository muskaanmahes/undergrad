#include <iostream>
#include <vector>
using namespace std;

int main() {
   
   const int NUM_ELEMENTS = 5;
   vector<int>numVctr(NUM_ELEMENTS);
   int i, j;
   int tmp;
   
   cout << "Enter " << NUM_ELEMENTS << endl;
   
    for(i=0; i<numVctr.size(); i++){
      cout << "Value: ";
      cin >> numVctr.at(i);
   }
   
   //reverse
   for(i=0; i<numVctr.size(); i++){
     j = numVctr.size() - 1 - i;

     cout << "\ni: " << i << " j: " << j << endl;

     cout << "Before swap: " << endl;
     cout << "Element " << i << ": " << numVctr.at(i) << endl;
     cout << "Element " << j << ": " << numVctr.at(j) << endl;
      
     //swap 
     tmp = numVctr.at(i);
     numVctr.at(i)= numVctr.at(j);
     numVctr.at(j) = tmp;
 
     cout << "After swap: " <<endl;
     cout << "Element " << i << ": " << numVctr.at(i) << endl;
     cout << "Element " << j << ": " << numVctr.at(j) << endl;

   }



     //print out final vector

     for(i=0; i<numVctr.size(); i++){
    
      cout << numVctr.at(i);
   }
   
   return 0;
}