#include <iostream>
#include <vector>   // Must include vector library to use vectors
using namespace std;

int main() {
vector<int>userValues;
int currValue;
int numElements = 0;

cin >> currValue;
while((currValue >= 0) && (numElements < 9)){
    userValues.push_back(currValue);
    numElements++;
    cin >> currValue;

   }

     if(currValue >= 0){
    // too many elements
    cout << "Too many numbers" << endl;
   }
    else{ //find middle element, assume odd number of elements
     int mid = userValues.size() / 2;
     cout << "Middle item: "<< userValues.at(mid)<< endl;

    }

   return 0;
}
