
#include <iostream>
using namespace std;
int Fibonacci(int n) {
int last;
int beforeLast;
int fib;
int i;
if (n < 0) return -1;
if (n == 0) return 0;
if (n == 1) return 1;
last = 1;
beforeLast = 0;
for (i=2; i<=n; i++){
fib = last + beforeLast;
beforeLast = last;
last = fib;
}
return fib;
}
int main() {
int startNum;
cin >> startNum;
cout << "Fibonacci(" << startNum << ") is " << Fibonacci(startNum) << endl;
return 0;
}
