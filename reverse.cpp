#include <iostream>
#include <vector>   // Must include vector library to use vectors
using namespace std;

int main() {
   vector<int> userValues; // A vector to hold the user's input integers
   int numValues;
   int currValue;


   cin >> numValues;

   //read user integers, assign them into vector
    for(int i = 0; i<numValues; i++){
       cin >> currValue;
       userValues.push_back(currValue);
       //userValues,at(i)= currValue; (another way to extend the array, but need to know the size of the vector by using userValue.resize(numValues);)

   }
    // read vectors element in reverse order
     for(int j=userValues.size()-1; j>=0; j--){
     cout << userValues.at(j) << ",";
     }

    cout << endl;

   return 0;
}
