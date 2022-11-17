#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int add(int a, int b){
    int re = a;
    while(b){
        int tmp = a;
        a = a^b;
        b = (tmp&b)<<1;
        re = a;
    }
    return re;
}

int main()
{
    int a = -1;   
    printf("%x\n",a>>2);
    return 0;
}

