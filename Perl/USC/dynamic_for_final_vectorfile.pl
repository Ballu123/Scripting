#!/usr/bin/perl
open my $file, '<', "command.txt" or die $!;
my @array = <$file>;

#opening the vector file
my $filex = "filechecking.vec";
unless(open WRFILEX, '>'.$filex) {
	die "\nUnable to create $file\n";
}

print WRFILEX "radix 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 4 4 4 4 1 1 1 1 1 1 1 1 1 1 1
io    i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i i
vname Pre word_enable read_en di15 di14 di13 di12 di11 di10 di9 di8 di7 di6 di5 di4 di3 di2 di1 di0 write_en a5 a4 a3 a2 a1 a0 c_demux c_mux1 phi c_mux2 c_mux4 c_mux3 ai[15:12] ai[11:8] ai[7:4] ai[3:0] c_mux5 mi7 mi6 mi5 mi4 mi3 mi2 mi1 mi0 enable ls_enable
slope 0.01
vih 1.8
tunit 2ns
*			pre		word   read	 data	             write       address      demux     mux4,3  addi  c_mux5    muli       en,ls
0			1		0		1	0000000000000000		0	    0 0 0 0 0 0    1101      10     0000     0     00000000      10
1			0		0		1	0000000000000000   	 	0       0 0 0 0 0 0    1101      10     0000     0     00000000      10
6			1		0		1	0000000000000000		0       0 0 0 0 0 0    1101      10     0000     0     00000000      10
6.5			0		0		1	0000000000000000		0       0 0 0 0 0 0    1101      10     0000     0     00000000      10
8			1		0		1	0000000000000000		0       0 0 0 0 0 0    1101      10     0000     0     00000000      10
*eoip\n";
$time =8;
foreach $array_line (@array){
	@Singlevalue = split(" ", $array_line );
	
	if($array_line =~ m/STORE/){
		Store_Function($array_line);
	} #STORE Checking
	if($array_line =~ m/LOAD/){
		Load_Function($array_line);
	} #LOAD Checking
	if($array_line =~/\bADD\b/){ 
		Add_Function($array_line);
	} #ADD Checking
	
	if($array_line =~/\bADDI\b/){ 
		Add_Imm_Function($array_line);
	} #ADDI Checking
	
	if($array_line =~ m/\bMUL\b/){ 
		Mul_Function($array_line);
	} #MUL Checking
	
	if($array_line =~ m/\bMULI\b/){ 
		Mul_Imm_Function($array_line);
	} #MULI Checking
	if($array_line =~ m/\bNOP\b/){ 
		Nop_Function($array_line);
	} #NOP checking 
  #while looping checking
}
close $file;

sub Store_Function{
my($line) = @_;
@STORE_line = split(" ", $line);
	if($STORE_line[1] =~ m/^@/){
			#Data printing 
			chop($STORE_line[2]); 
			$STORE_line[2]= reverse($STORE_line[2]);
			chop($STORE_line[2]); 
			$STORE_line[2] = reverse($STORE_line[2]);
			$binary_string_data = sprintf "%016b", hex($STORE_line[2]);
			#print "\n$binary_string_data";
		
			#Address printing 
			$adding_slash = "/".$STORE_line[1];
			$adding_slash =~ s/[^a-zA-Z0-9]*//g;
			chop $adding_slash;
			$binary_string_address = sprintf "%06b", hex($adding_slash );
			#print "  $binary_string_address"; #giving two spaces b/w data and address
			# 1st reading the data at@1Ah and taking last 6 bit 
			
			#load for store IMMEdiate
			$time_store2 = $time +1;
			print WRFILEX "$time_store2        0       0       1     0000000000000000        0      $binary_string_address    1101      10     0000     0     00000000      10\n" ;
			$time_store2 = $time_store2 +.5;
			print WRFILEX "$time_store2      1       1       0     0000000000000000        0       $binary_string_address    1101      10     0000     0     00000000      10\n";
			$time_store2 = $time_store2 + 2;
			print WRFILEX "$time_store2      1       0       1     0000000000000000        0       $binary_string_address    1101      10     0000     0     00000000      11\n";
			
			
			$time_store2 = $time_store2 +1.5;
			print WRFILEX "$time_store2     0       0       1       0000000000000000        0       0 0 0 0 0 0    1101      10     0000     0     00000000      11\n";
			$time_store2 = $time_store2 +1;
			print WRFILEX "$time_store2		1		1		1		$binary_string_data        1       0 0 0 0 0 0    1101      10     0000     0     00000000      11\n";
			$time = $time_store2;
			print WRFILEX "* \@STORE END \n";
		}else{
		
			#Data printing 
			chop($STORE_line[2]); 
			$STORE_line[2]= reverse($STORE_line[2]);
			chop($STORE_line[2]); 
			$STORE_line[2] = reverse($STORE_line[2]);
			$binary_string_data = sprintf "%016b", hex($STORE_line[2]);
			
			#Address printing
			chop $STORE_line[1];
			$binary_string_address = sprintf "%06b", hex($STORE_line[1] );
			#print "  $binary_string_address";	#giving two spaces b/w data and address
			#final value to be print
			$time_store1 = $time +1;
			print WRFILEX "$time_store1    	   0       0       1    0000000000000000        0     $binary_string_address    1101      10     0000     0     00000000      10\n";
			$time_store1 = $time_store1 +1;
			print WRFILEX "$time_store1		   1	   1	   1	$binary_string_data        1     $binary_string_address    1101      10     0000     0     00000000      10\n";
			$time = $time_store1;
			print WRFILEX "* STORE END \n";
		}
	
}

#Loadl function
sub Load_Function{
my($line) = @_;
	$count++;
	
	@LOAD_line = split(" ", $line);
		#print "@LOAD_line[0]\n";
		
		# print "balrm --$load_line[1]\n";
		if($LOAD_line[1] =~ m/^@/){
		
			#Address printing
			$adding_slash = "/".$LOAD_line[1];
			$adding_slash =~ s/[^a-zA-Z0-9]*//g;
			chop $adding_slash;
			$binary_string_address1 = sprintf "%06b", hex($adding_slash);
			
			
			$time_load2 = $time +1;
			print WRFILEX "$time_load2       0     0       1       0000000000000000        0       $binary_string_address1    0000      01      0000    0     00000000      00\n" ;
			$time_load2 = $time_load2 +.8;
			print WRFILEX "$time_load2        1     1       0       0000000000000000        0       $binary_string_address1    0000      01      0000    0     00000000      00\n";
			$time_load2 = $time_load2 + 2.2;
			print WRFILEX "$time_load2        1     0       1       0000000000000000        0       $binary_string_address1   0000      01      0000    0     00000000      00\n";
		
			$time_load2 = $time_load2  +1;
			print WRFILEX "$time_load2         0       0       1    0000000000000000        0     000000   0000      01     0000     0     00000000      01\n" ;
			$time_load2 = $time_load2 +.8;
			print WRFILEX "$time_load2       1       1       0    0000000000000000        0     000000    0000      01     0000     0     00000000      01\n";
			$time_load2 = $time_load2 + 2.2;
			print WRFILEX "$time_load2       1       0       1    0000000000000000        0     000000    0000      01     0000     0     00000000      01\n";
			

			$time = $time_load2;
			print WRFILEX "* \@LOAD END \n";
			
		}else{
		
			#Address1 for Loading data1
			chop $LOAD_line[1];
			$binary_address1 = sprintf "%06b", hex($LOAD_line[1] );

			$time_load1 = $time +1;
			print WRFILEX "$time_load1     0       0       1 	0000000000000000        0     $binary_address1    0000      01     0000     0     00000000      00\n" ;
			$time_load1 = $time_load1 + .8;
			print WRFILEX "$time_load1       1       1       0    0000000000000000        0     $binary_address1    0000      01     0000     0     00000000      00\n";
			$time_load1 = $time_load1 + 2.2;
			print WRFILEX "$time_load1       1       0       1    0000000000000000        0     $binary_address1    0000      01     0000     0     00000000      00\n";
			
			$time = $time_load1;
			print WRFILEX "* LOAD END \n";
		}	
}

sub Add_Function{
	my($line) = @_;
	@ADD_line = split(" ", $array_line);
		
		#Address1 for storing data1
		chop $ADD_line[2];
		chop $ADD_line[2];
		$binary_address1 = sprintf "%06b", hex($ADD_line[2] );
		
		chop $ADD_line[3];
		$binary_address2 = sprintf "%06b", hex($ADD_line[3] );

		$time_load1 = $time +1;
		print WRFILEX "$time_load1    0       0       1     0000000000000000        0       $binary_address1     1101      10     0000     0     00000000      10\n" ;
		$time_load1 = $time_load1 + .5;
		print WRFILEX "$time_load1      1       1       0     0000000000000000        0       $binary_address1    1101      10     0000     0     00000000      10\n";
		$time_load1 = $time_load1 + 2;
		print WRFILEX "$time_load1      1       0       1     0000000000000000        0       $binary_address1    1101      10     0000     0     00000000      10\n";
			
			
			
		$time_load1 = $time_load1 +1.5;
		print WRFILEX "$time_load1       0       0       1     0000000000000000        0       $binary_address2    0100      10     0000     0     00000000      10\n" ;
		$time_load1 = $time_load1 +.5;
		print WRFILEX "$time_load1      1       1       0     0000000000000000        0      $binary_address2   0100      10     0000     0     00000000      10\n";
		$time_load1 = $time_load1 + 2;
		print WRFILEX "$time_load1      1       0       1     0000000000000000        0       $binary_address2    0100      10     0000     0     00000000      10\n";
		
		#Addition of the above data1 and data2
		$time_add= $time_load1 +1.5;
		print WRFILEX "$time_add        1	0	1		0000000000000000  	0	0 0 0 0 0 0    0110      00     0000     0     00000000      10\n" ;
		
		#Storing back to the ADDRESS which is given by the TEXT file
		#Address for storing data1 + data2
		chop $ADD_line[1];
		chop $ADD_line[1];
		$binary_address_final = sprintf "%06b", hex($ADD_line[1] );
		$time_add= $time_add +5;
		print WRFILEX"$time_add        0	0	1		0000000000000000  	0	$binary_address_final    0110      00     0000     0     00000000      10\n"; 
		$time_add= $time_add +1;
		print WRFILEX"$time_add        1	1	1		0000000000000000	1	$binary_address_final    0100      00     0000     0     00000000      10\n";	
		$time= $time_add ;
		print WRFILEX "* ADD END \n";
}

sub Add_Imm_Function{
	my($line) = @_;
	@ADDI_line = split(" ", $array_line);
		
		#address for LOAD(reading)
		chop $ADDI_line[2];
		chop $ADDI_line[2];
		$binary_address1 = sprintf "%06b", hex($ADDI_line[2] );
		
		#IMMEDIATE VALUE
		#STORING the immediate data
		chop($ADDI_line[3]); 
		$ADDI_line[3]= reverse($ADDI_line[3]);
		chop($ADDI_line[3]); 
		$ADDI_line[3] = reverse($ADDI_line[3]);
		#print "\n$binary_string_data2";
		
		#LOAD1 first value (Read the first value)
		$time_addi= $time +1;
		print WRFILEX"$time_addi         0       0       1    0000000000000000        0     $binary_address1    0000      10      $ADDI_line[3]    0     00000000      10\n";
		$time_addi= $time_addi +.5;
		print WRFILEX"$time_addi       1       1       0    0000000000000000        0     $binary_address1    0000      10      $ADDI_line[3]   0     00000000      10\n";
		$time_addi= $time_addi +2;
		print WRFILEX"$time_addi       1       0       1    0000000000000000        0     $binary_address1    0000      10      $ADDI_line[3]    0     00000000      10\n";
		#end of read -first (load the first value for add)
		
		#Addition of the above data1 and data2
		$time_addi= $time_addi +2.5;
		print WRFILEX "$time_addi        1	      0	    1	    0000000000000000	    0	  000000    0010      00     $ADDI_line[3]    0     00000000      10\n" ;
		
		#Storing back to the ADDRESS which is given by the TEXT file
		#Address for storing data1 + data2
		chop $ADDI_line[1];
		chop $ADDI_line[1];
		$binary_address_final = sprintf "%06b", hex($ADDI_line[1] );
		$time_addi= $time_addi +5;
		print WRFILEX"$time_addi        0	      0	      1	    0000000000000000	    0	  $binary_address_final    0010      00      $ADDI_line[3]    0     00000000      10\n"; 
		$time_addi= $time_addi +1;		
		print WRFILEX"$time_addi        1	      1	      1   	0000000000000000	    1	  $binary_address_final    0000      00     $ADDI_line[3]    0     00000000      10\n";	
		
		$time= $time_addi ;
		print WRFILEX "* ADD IMM END \n";
}

sub Mul_Function{
	my($line) = @_;
	@MUL_line = split(" ", $array_line);

	
		#Address1 for storing data1
		chop $MUL_line[2];
		$binary_address1 = sprintf "%06b", hex($MUL_line[2]);
		
		#LOAD (Reading the store value and selecting the respective mux and doing multiplication)
		$time_mul= $time +1;
		print WRFILEX"$time_mul        0     0       1       0000000000000000        0      $binary_address1    0000      01      0000    1     00000000      00\n";
		$time_mul= $time_mul +.5;
		print WRFILEX"$time_mul      1     1       0       0000000000000000        0      $binary_address1   0000      01      0000    1     00000000      00\n";
		$time_mul= $time_mul +2;
		print WRFILEX"$time_mul      1     0       1       0000000000000000        0       $binary_address1    0000      01      0000    1     00000000      00\n";
		
		#Multiplication of the above data1 and data2
		$time_mul= $time_mul +1.5;
		print WRFILEX "$time_mul        1     0       1       0000000000000000        0       000000    0000      01      0000    1     00000000      00\n" ;
		
		#Storing back to the ADDRESS which is given by the TEXT file
		#Address for storing Multiplication of 8 upper and 8 lower bit
		chop $MUL_line[1];
		chop $MUL_line[1];
		$binary_address_final = sprintf "%06b", hex($MUL_line[1] );
		$time_mul= $time_mul +6;
		print WRFILEX"$time_mul        0     0       1       0000000000000000        0       $binary_address_final   0000      01      0000    1     00000000      00\n";
		$time_mul= $time_mul +1;
		print WRFILEX"$time_mul       1     1       1       0000000000000000        1      $binary_address_final   0000      01      0000    1     00000000      00\n";	
		
		$time = $time_mul;
		print WRFILEX "* MUL END \n";
}
sub Mul_Imm_Function{
	my($line) = @_;
	@MULI_line = split(" ", $array_line);
		

		#Address1 for Reading  data (LOADING)
		chop $MULI_line[2];
		chop $MULI_line[2];
		$binary_address1 = sprintf "%06b", hex($MULI_line[2]);
	
	
		
		#IMMEDIATE VALUE
		chop($MULI_line[3]); 
		$MULI_line[3]= reverse($MULI_line[3]);
		chop($MULI_line[3]); 
		$MULI_line[3] = reverse($MULI_line[3]);
		$binary_string_data2 = sprintf "%08b", hex($MULI_line[3]);
		
		#LOAD (Reading the store value and adding the immediate value ,selecting the respective mux and doing multiplication)
		$time_muli= $time +1;
		print WRFILEX"$time_muli     		0     0       1       0000000000000000        0      $binary_address1    0000      01      0000    0     $binary_string_data2      00\n";
		$time_muli= $time_muli +.5;
		print WRFILEX"$time_muli      1     1       0       0000000000000000        0       $binary_address1    0000      01      0000    0     $binary_string_data2      00\n";
		$time_muli= $time_muli +2;
		print WRFILEX"$time_muli      1     0       1       0000000000000000        0       $binary_address1    0000      01      0000    0     $binary_string_data2      00\n";
		
		
		#Multiplication of the above data1 and data2
		$time_muli= $time_muli +1.5;
		print WRFILEX "$time_muli        1     0       1       0000000000000000        0       000000    0000      01      0000    0     $binary_string_data2      00\n" ;
		
		#Storing back to the ADDRESS which is given by the TEXT file
		#Address for storing Multiplication of 8 upper and 8 lower bit
		chop $MULI_line[1];
		chop $MULI_line[1];
		$binary_address_final = sprintf "%06b", hex($MULI_line[1] );
		$time_muli= $time_muli +6;
		print WRFILEX"$time_muli       0     0       1       0000000000000000        0       $binary_address_final    0000      01      0000    0     $binary_string_data2      00\n";  
		$time_muli= $time_muli +1;
		print WRFILEX"$time_muli        1     1       1       0000000000000000        1       $binary_address_final    0000      01      0000    0     $binary_string_data2      00\n";	
		$time = $time_muli;
		print WRFILEX "* MUL IMM END \n";
}

sub Nop_Function{
my($line) = @_;
# $time_nop= $time +1;
# print WRFILEX "$time_nop	1	0	1	0000000000000000	0	0 0 0 0 0 0    1101      10     0000     0     00000000      10\n";
# $time_nop= $time_nop +1;
# print WRFILEX "$time_nop	1	0	1	0000000000000000	0	0 0 0 0 0 0    1101      10     0000     0     00000000      10\n";
# $time_nop= $time_nop +1;
# print WRFILEX "$time_nop	1	0	1	0000000000000000	0	0 0 0 0 0 0    1101      10     0000     0     00000000      10\n";
# $time_nop= $time_nop +1;
# print WRFILEX "$time_nop	1	0	1	0000000000000000	0	0 0 0 0 0 0    1101      10     0000     0     00000000      10\n";
# $time= $time_nop ;
# print WRFILEX "* NOP END \n";
}