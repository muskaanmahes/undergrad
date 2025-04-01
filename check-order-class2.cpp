#include <iostream>
include <string>
using namespace std;


template <typename TheType>
class Triple{

private: 
TheType item1;
TheType item2;
TheType item3;


public:
Triple(TheType i1, TheType i2, TheType i3);
int CheckOrder();

};


template <typename TheType>
Triple<TheType>::Triple(TheType i1, TheType i2, TheType i3){
item1 = i1;
item2 = i2; 
item3 = i3;


}

template <typename TheType>
Triple<TheType>::CheckOrder(){
    
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