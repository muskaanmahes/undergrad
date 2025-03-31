#include <iostream>
#include <iomanip>
#include <cmath>
#include "car.h"
using namespace std;


int main(){


Car car1;

int userYear;
int userPrice;
int currYear;

cin >> userYear;
cin >> userPrice;
cin >> currYear;

car1.SetModelYear(userYear);
car1.SetPurchasePrice(userPrice);
car1.CalcCurrentValue(currYear);

cout << fixed << setprecision(0);
car1.PrintCarInfo();
return 0;

}
