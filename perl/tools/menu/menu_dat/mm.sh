foreach(2..50) 
{
	print $_,"\n"; 
	system("cp sub1.dat sub" . $_ . ".dat");
}
