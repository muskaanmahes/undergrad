#include <iostream>
using namespace;


//objects and functions

class MyClass{
public:
void display():

void display(){

cout << "Inside display methold of MyClass" << endl;

}

//uses dynamic memory allocation
int main(){

MyClass* myObject = new MyClass(); //create the insgance of class: a new object. Then, call default constructor

myObject->display(); //member access operator
(*myObject).display() // regulat object.verb notation

delete myObject;

return 0;
}

}
