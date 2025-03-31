#include <iostream>

//functions and pointers

void myFunction(int* myVar){

 *myVar = 100;


}

in main(){

int num = 45;
cout << "num: " << num;
myFunction(&num)
cout << "num: " << num << endl;

return 0;

}
