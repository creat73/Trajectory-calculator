#include <iostream>
#include <math.h> 
using namespace std;

#define PI 3.14159265
#define G 9.81

double calculate_flight_time(double v0, double a, double h)
{
	return (v0 * sin(a*PI/180) + sqrt(pow(v0*sin(a*PI/180),2.0)+2*G*h))/G;
}

double calculate_max_height(double v0, double a, double h)
{
	return h + pow(v0,2.0) * pow(sin(a*PI/180),2.0) / (2*G);
}

double calculate_range(double v0, double a, double h)
{
	return ((v0*cos(a*PI/180))/G) * (v0 * sin(a*PI/180) + sqrt(pow(v0*sin(a*PI/180),2.0) + 2*G*h));
}

string get_flight_function(double v0, double a, double h)
{
	return "y = " + std::to_string(h) + " + " + std::to_string(tan(a*PI/180)) + "x - " + std::to_string(G / (2*pow(v0,2.0)*pow(cos(a*PI/180),2.0))) + "x^2";
}

//Oblicza czas lotu, wysokosc maksymalna, odleglosc rzutu oraz wyznacza funkcje trajektorii lotu obiektu
//Nie uwzglednia: oporu powietrza, rzutu w tyl lub do dolu (kat musi byc <= 90), rzutu z ujemnych wysokosci
//Wszystkie obliczenia oparte o wzory ze strony zjawiska na wikipedii https://en.wikipedia.org/wiki/Projectile_motion#Displacement

int main()
{
bool is_running = true;
while(is_running)
{	//oznaczenia skrocone dla lepszej czytelnosci
	//v0 - predkosc poczatkowa rzucanego obiektu
	// a - kat nachylenia rzutu
	// h - wysokosc z ktorej zostal oddany rzut
	double v0, a, h;
	
	cout<<"Podaj predkosc poczatkowa rzuconego objektu (m/s) (wpisz -1 aby wyjsc): ";
	cin>>v0;
	if(v0<0){break;}
	cout<<"Podaj kat rzutu: ";
	cin>>a;
	cout<<"Podaj wysokosc poczatkowa objektu: ";
	cin>>h;

	cout << "\nCzas lotu: " << calculate_flight_time(v0,a,h) << " s\n";
	cout << "Wysokosc maksymalna: " << calculate_max_height(v0, a, h) << " m \n";
	cout << "Odleglosc rzutu: " << calculate_range(v0, a, h) << " m \n";
	cout << "Wzór do wyznaczenia trajektorii: " << get_flight_function(v0, a, h) <<"\n\n"; 
	
}
return 0;
}
