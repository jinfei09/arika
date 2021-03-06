#!/usr/bin/perl
use strict;
use Cwd;

my $FLAG=shift;
my $BusiNo=0;
my $FuncNo=0;
my @Nr;
my $g_title;
my $g_filename;
my $cwd=getcwd();

sub GetFileNum()
{
	my $F=shift;
	my $Dir=$ENV{"HOME"} . "/" . substr($F,0,2) . "/" . substr($F,2,2) . "/" . substr($F,4,2);
	my $n=`cd $Dir && ls -l |wc -l`;
	$n;
}

sub GetArea()
{
	my @x=split(/\//,$_);
	#system("f.sh");
	1;
}

sub GetCode()
{
	my $key=shift;
	my @mynr=@_;
	my $i=1;
	foreach(@mynr)
	{
		if($_=~/^$key\-/i)
		{
			my @x=split(/\-/,@mynr[$i-1]);
			return($i . "|" . @x[0]);
		}
		$i++;
	}
	my @x=split(/\-/,@mynr[$key-1]);
	return($key . "|" . @x[0]);
}

sub MakePublic()
{
	my $type=shift;
	my $code=shift;
	my $wcode=shift;
	my @x;
	push(@x,"SYS_JYBM=$code");
	push(@x,"SYS_MBLYBS=$wcode");
	push(@x,"SYS_TXMBFBS=1234");
	my $File=$ENV{"RUNDIR"} . "/testdat/pub/public.$type.$code.$wcode.dat";
	#my $File1=$ENV{"RUNDIR"} . "/testdat/public.dat";
	&SaveFile($File, @x) unless(-f $File);
	#system("cp $File $File1");
}

sub DoMenu()
{
	my $t=shift;
	my ($MenuName,$n)=split(/\s+/,$t);
	my $code;
	while(1)
	{ 
		my $n=&Menu($MenuName,$n);
        my  $key=999;
        $key=<STDIN>;
		chop($key);
		last if($key eq "q");
		last if($key eq "0");
		my $s=&GetCode($key,@Nr);
		($key,$code)=split(/\|/,$s);
		print "key=$key,code=$code\n";
		$g_title=$Nr[$key-1];
		$g_filename=$Nr[$key-1] if($MenuName eq "main");
		if($key==99)
		{
			system("vi " . "menu_dat/" .  $MenuName . ".dat");
		}  
		elsif($key>0 && $key<=$n or ($key eq "e" && $MenuName ne "main") or ($key eq "ls" && $MenuName ne "main") or ($key eq "es" && $MenuName ne "main"))
		{
			if($MenuName eq "main")
			{
				next if ($key!~/^\d+$/);
				$BusiNo=$code;
				$MenuName="sub" . $key;
				my @t=split(/_/,$g_filename);
                #system("cp $File2 $File1"); 
                DoMenu($MenuName . &GetFileNum(@t[0]),$code);
				$MenuName="main";
			}
			else
			{
				#print "key=$key g_filename=$g_filename, g_title=$g_title\n";
				#exit;
				&RunSubMenu($key,$g_filename,$g_title);
	
			}
		}
		elsif($key eq "h")
		{
			system("clear && cat menu_dat/help.dat && read") 
		}
		elsif($key eq "log")
		{
			my $File=$ENV{"RUNDIR"} . "/ntest/nodetest.log";
			system("vi $File") 
		}
		else
		{
			print "Select Again! $key Error!\n";
		}
	}
}

sub myread{
    my $file=shift;
    -e $file || system("touch " . $file);
    open(File,"<$file")||die "can not open $file: $!";
    my @fields=grep(!/^#/,<File>);
    close(File);
    chop(@fields);
    @fields;
}

sub GetNr()
{
    my @d=grep(!/=/,@_);
    @d;
}

sub GetCfg()
{
      my $Name=shift;
      my @d=grep(/$Name=/,@_);
      substr($d[0],length($Name)+1);
}

sub PrintMenu1()
{
	my $l=shift;
	my $w=shift;
	my $r=shift;
	my @nr=@_;
	my $i=0;
        foreach(@nr)
        {
          my $nr=sprintf("%2d.%s",++$i,$_);
          print "|" . " " x $l .  $nr . " " x ($w - $l -length($nr)-2) . "|","\n";
        }
	$i;
}

sub PrintMenu()
{
	my $l=shift;
	my $w=shift;
	my $r=shift;
	my @nr=@_;
	my $n=@nr; 
	$r=$n if($n<$r);
	my $m;
        for(my $i=0;$i<$r;$i++) 
	{
          my $nr;
	  for(my $j=0;$j<$n/$r+1;$j++)
	  {
		$m=$i+$j*$r;
		last if($m>=$n);
		my $nr1=sprintf("%2d.%-33s",$m+1,@nr[$m]);
		$nr .= $nr1;
	  }
          print "|" . " " x $l .  $nr . " " x ($w - $l -length($nr)-2) . "|","\n";
        }
	$m;
}

sub Menu()
{
        system("clear");
	my $r=25;
	my $MenuName=shift;
	my $N=shift;
	my $ss=&GetArea($g_filename);
	print "MENUNAME=====$MenuName $N\n";
	my @d;
        @d=&myread("menu_dat/" . $MenuName . ".dat");
        my $w=&GetCfg("WIDTH",@d);
        my $h=&GetCfg("HIGH",@d);
        my $l=&GetCfg("LEFT",@d);
	$w=70 if($w=="");
	$h=2 if($h=="");
	$l=5 if($l=="");
	my $title=&GetCfg("TITLE",@d);
	$title=$g_title if($title eq "");
        my $n=($w-length($title))/2 -2;
        print " " . "=" x $n . " " . $title . " " . "=" x $n, "\n";
        print (("|" . " " x ($w-2) . "|","\n") x $h);
        my @nr=&GetNr(@d);
	my $i;
	@Nr=@nr;
	$i=&PrintMenu($l,$w,$r,@nr);
        my $nr=sprintf("%2d.%s",99,"Edit Menu");
        print "|" . " " x $l .  $nr . " " x ($w - $l -length($nr)-2) . "|","\n";
	if($MenuName eq "main") {$nr=" q.Exit";} else {$nr=" q.Back";}
        print "|" . " " x $l .  $nr . " " x ($w - $l -length($nr)-2) . "|","\n";
        print (("|" . " " x ($w-2) . "|","\n") x $h);
        print " " . "=" x ($w-2), "\n";
        print "Please Select(1-$i,99,e,ef,q,h=help):";
	$i;
    }

sub RunSubMenu()
{
	my $key=shift;
	my $file=shift;
	my $code=shift;
	return if ($key!~/^\d+$/ && $key!~/^\d+e$/ && $key ne "e" && $key ne "ls" && $key ne "es");
	if($key eq "ls")
	{
		my @t=split(/\./,$code);
		my @x=split(/_/,@t[0]);
		my @y=split(/_/,$file);
		print "@y\n";
		#my $Dir=$ENV{"HOME"} . "/" . substr(@y[0],0,2) . "/" . substr(@y[0],2,2) . "/" . substr(@y[0],4,2);
		my $Dir=$ENV{"HOME"} . "/" . substr(@y[0],0,2) . "/" . substr(@y[0],2,2) . "/" . substr(@y[0],4,2);
		print $Dir,"\n";
		system("cd $Dir && ls");
		print "$Dir Press Enter To Continue...\n";
    		$key=<STDIN>;
	}
	if($key=~/^e$/)
	{
		my @t=split(/\./,$code);
		my @x=split(/_/,@t[0]);
		my @y=split(/_/,$file);
		my $Dir=$cwd . "/" ."menu_dat" ."/" . "menu_info" . "/";
		print $Dir,"\n Enter CTL + C Back\n";
		system("cd $Dir && vi info.txt");
	}
	if($key=~/^es$/)
	{
		my @t=split(/\./,$code);
		my @x=split(/_/,@t[0]);
		my @y=split(/_/,$file);
		#my $Dir=$ENV{"HOME"} . "/" . substr(@y[0],0,2) . "/" . substr(@y[0],2,2) . "/" . substr(@y[0],4,2);
		my $Dir=$ENV{"HOME"} . "/" ."trunk2.0" ."/" . "pack4rd" . "/"  . @y[0] . "/Server";
		print $Dir,"\n��CTL + C ����\n";
		system("cd $Dir && vi s.sh");
	}
	if($key=~/^\d+$/)
	{
		my @t=split(/\./,$code);
		my @x=split(/_/,@t[0]);
		my @y=split(/_/,$file);
		my $Dir=$ENV{"HOME"} . "/" ."trunk2.0" ."/" . "pack4rd" . "/"  . @y[0] . "/Server";
		print $Dir,"\n��CTL + C ����\n";
		system("cd $Dir && ./s.sh");
		print "$Dir Press Enter To Continue...\n";
    		$key=<STDIN>;
	}
}

sub GenFile()
{
        my %h;
        my $f1=shift;
        my $f2=shift;
        my @x1=&myread($f1);
        my @x2=&myread($f2);
        foreach(@x2)
        {
                my @x=split(/;/,$_);
                foreach(@x)
                {
                        my @y=split(/:/,$_);
                        $h{@y[3]}="";
                }
        }
        foreach(@x1)
        {
                my @x=split(/=/,$_);
                foreach(@x)
                {
                        $h{@x[0]}=@x[1];
                }
        }
        open(FILE,">$f1")||die "Could not open $f1:$!";
        foreach(sort keys %h) {
                print FILE "$_=$h{$_}\n" if(length($_)>0);
        }
        close(FILE);
}

sub SaveFile()
{
  my $f1=shift;
  open(FILE,">$f1")||die "Could not open $f1:$!";
  foreach(@_) {
      print FILE "$_\n" if(length($_)>0);
  }
  close(FILE);
}

&DoMenu("main");
print "Good Bye!\n";
