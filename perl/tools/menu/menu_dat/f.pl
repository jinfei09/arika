#!/usr/bin/perl

foreach(2..30)
{
	printf $_;
	printf "\n";
	system("cp sub1.dat sub" . $_ . ".dat");
}
