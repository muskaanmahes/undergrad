#include <iostream>
using namespace;

//objects and pointers

class MyClass{
public:
void display()
 int X;
 int Y;

};

MyClass::MyClass(){

X = 0;
Y = 0;

void MyClass::display(){

 cout << "Inside display methold of MyClass" << endl;
 cout << "X: " << X << endl;
 cout << "Y: " << Y << endl;

}

//uses dynamic memory allocation
int main(){

MyClass* myObject = new MyClass(); //create the insgance of class: a new object. Then, call default constructor

myObject->display(); //member access operator
//(*myObject).display() // regulat object.verb notation

delete myObject;

return 0;
}


}
