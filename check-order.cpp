#include <iostream>
#include <string>

using namespace std;

template <typename TheType>
int CheckIrder(TheType int1, TheType item2, TheType item3){

if((item1 < item2) && (item2 < item3)){
   return 1;
}
 else if((item1 > item2) && (item2 > item3)){

  return -1;

 }
 else{
 
 return 0;

 }
}

 int main(){

string str1, str2, str3;
cin >> str1;
cin >> str2;
cin >> str3;

cout << "Order: " << CheckORder(str1, str2, str3) << endl;

int int1, int2, int3;
cin >> int1;
cin >> int2;
cin >> int3;

cout << "Order: " << CheckORder(int1, int2, int3) << endl;

 }