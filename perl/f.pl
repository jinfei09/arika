#!/usr/bin/perl
# time: 	2013.11.11
# who:  	chenfei
# function: compile apk without eclipse
#
#use strict;

my $current_path = qx(dirname $0);
my $TOOLS_AAPT = "/opt/android-sdk-linux/platform-tools/aapt";
my $TOOLS_JAVAC = "/opt/jdk1.6.0_37/bin/javac";
my $TOOLS_DX ="/opt/android-sdk-linux/platform-tools/dx";
my $TOOLS_APKBUILD = "/opt/android-sdk-linux/tools/apkbuilder";

my $SRC = "src";
my $DYNAMIC_LIB = "dynamic_lib";
my $JAR_PATH = "/opt/android-sdk-linux/platforms/android-14/android.jar";

sub clean_workspace() {
	if (-e "gen") {
		qx(rm -rf gen);
	}
	if (-e "out") {
		qx(rm -rf out);	
	}
	if (-e "pro_bin") {
		qx(rm -rf pro_bin);	
	}
	qx(mkdir -p gen);	
	qx(mkdir -p out);	
	qx(mkdir -p pro_bin);	
}


sub get_all_parameters() {
	# /opt/android-sdk-linux/platform-tools/aapt package -f -m -J gen  -S res -I /opt/android-sdk-linux/platforms/android-14/android.jar -M AndroidManifest.xml
}

sub get_java_R() {
	print "begin compile resources:\n";
	my $AAPT_COMPILE = 	"$TOOLS_AAPT package -f -m -J gen  -S res -I $JAR_PATH -M AndroidManifest.xml";
	print ($AAPT_COMPILE);
	system($AAPT_COMPILE);
}


sub java_codes_compile() {
	print "begin compile codes:\n";

	my @ALL_LIBS_JARS = glob 'libs/*.jar';
	my @ALL_JARS = @ALL_LIBS_JARS;
	push(@ALL_JARS, $JAR_PATH);
	my $ALL_DYNAMIC_JARS = join(":", @ALL_JARS);
	print "$ALL_DYNAMIC_JARS\n";
	my $ALL_JAVA_FILES=
	my @all_java_temp = qx(find . -name "*.java");
	foreach $one_file (@all_java_temp) {
		$one_file =~ s/\.\///;
		$one_file =~ s/\n$//;
		push(@ALL_JAVA_ARRAY, $one_file);	
	}	

	my $JAVAC_COMPILE = "$TOOLS_JAVAC -encoding UTF-8 -target 1.6 -g -sourcepath $SRC -extdirs $DYNAMIC_LIB -classpath $ALL_DYNAMIC_JARS -d pro_bin @ALL_JAVA_ARRAY";
	#print ($JAVAC_COMPILE);
	system($JAVAC_COMPILE);

}

sub java_resources_compile() {
	#my $AAPT_RESOURCES = "$TOOLS_AAPT crunch -v -S res -C pro_bin/res > /dev/null";
	#system($AAPT_RESOURCES);

	my $RESOURCES_TARGET = "$TOOLS_AAPT package -f -c zh_CN,en_US,zh_TW,ldpi,mdpi,nodpi,xxhdpi -M AndroidManifest.xml -S res -A assets -I $JAR_PATH -F pro_bin/resources.ap_";
	system($RESOURCES_TARGET);
}

sub generate_class_dex() {
	my $GEN_CLASS_DEX = "$TOOLS_DX -JXmx2048M --dex --output=pro_bin/classes.dex pro_bin @ALL_LIBS_JARS";
	print ("$GEN_CLASS_DEX");
	system($GEN_CLASS_DEX);
}

sub java_aidl_compile() {
	print "begin compile aidl:\n";
}
sub java_buildapk() { 
	my $APK_BUILDER = "$TOOLS_APKBUILD out/SCG_arm.apk -v -u -z pro_bin/resources.ap_ -f pro_bin/classes.dex -rf src -nf libs"; 
	system($APK_BUILDER); 
}

sub java_compile() {
	&get_java_R;
	&java_codes_compile;
	&generate_class_dex;
	&java_resources_compile;

	&java_buildapk;
	#&java_aidl_compile;
}

###############################Main##################################

&clean_workspace;
&get_all_parameters;
&java_compile;

__DATA__
/** Automatically generated file. DO NOT MODIFY */
package com.lenovo.scg;

public final class BuildConfig {
    public final static boolean DEBUG = true;
}
