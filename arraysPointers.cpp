#include <iostream>
using namespace;

//arrays and pointers

in main(){

int num1 = 100;
int num2 = 200;
int num3 = 300;

int* myArray[3] = {&num1, &num2, &num3};

    for(int i= 0; i<3; i++){

        cout << "Array element" << i << ": " << *myArray[i] << endl;

    }

return 0;

}
