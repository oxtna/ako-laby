#include <stdio.h>

int szukaj_max(int x, int y, int z);
int szukaj4_max(int a, int b, int c, int d);
void liczba_przeciwna(int* a);

int main()
{
int m = -5;

liczba_przeciwna(&m);
printf("\n m = %d\n", m);
return 0;


int a, b, c, d, wynik;
printf("\nProsze podac cztery liczby calkowite ze znakiem: ");
scanf_s("%d %d %d %d", &a, &b, &c, &d, 64);
wynik = szukaj4_max(a, b, c, d);
printf("\nSposrod podanych liczb %d, %d, %d, %d, liczba %d jest najwieksza\n", a, b, c, d, wynik);
return 0;
}