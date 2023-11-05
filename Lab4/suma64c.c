#include <stdio.h>

__int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64 v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);

int main()
{
	__int64 suma = suma_siedmiu_liczb(10, 20, 30, 40, 50, 60, 70);
	printf("\nSuma to %lld\n", suma);
	return 0;
}