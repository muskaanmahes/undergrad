#include <iostream>
using namespace std;

//pointer basics


//pointers: variables for holding addresses
int main(){
 
  int num = 45;
  int* pointer;

  pointer = &num; // assign the memory address of num into pointer

  cout << "Value of num: " << num << endl;
  cout << "Address of num: " << &num << endl;
  cout << "Value of pointer: " << pointer << endl;
  cout << "Value at location pointed by pointer: " << pointer << endl; //dereferencing 

  *pointer = 100

  cout << "Value of num: " << num << endl;

  return 0;




}