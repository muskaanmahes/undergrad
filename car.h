#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;

class Car {
private:
    int modelYear;
    int purchasePrice;
    int currentValue;
    //string carColor;

public:
    void SetModelYear(int userYear);
    int GetModelYear() const;
    void SetPurchasePrice(int price);
    int GetPurchasePrice() const;
    void CalcCurrentValue(int currentYear);
    void PrintInfo() const;
};




