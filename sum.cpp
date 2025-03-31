#include <iostream>
using namespace std;

void FindSum(int num1, int num2, int num3, int num4, int& sum){
   
   sum = num1 + num2 + num3 + num4;
   
}

int main() {
   int userNumber1;
   int userNumber2;
   int userNumber3;
   int userNumber4;
   
   cin >> userNumber1;
   cin >> userNumber2;
   cin >> userNumber3;
   cin >> userNumber4;
   int sum = 0;
   
   FindSum(userNumber1, userNumber2, userNumber3, userNumber4, sum);
   cout << "Sum: " << sum << endl;

   return 0;
}