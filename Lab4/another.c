#include <stdio.h>

void przestaw(int tablica[], int n);

int main()
{
	int t[] = { 5, 7, -2, 10 };
	int n = sizeof(t) / sizeof(int);
	for (int i = n; i > 1; i--)
	{
		przestaw(t, i);
	}
	printf("\n%d %d %d %d\n", t[0], t[1], t[2], t[3]);
	return 0;
}
