#!/usr/bin/perl

open my $file, '<', "command.txt" or die $!;
my @array = <$file>;

open my $excelfile, '<', "FINAL.csv" or die $!;
my @excelarray = <$excelfile>;
$count =0;
$count8 =0;
foreach $excelline (@excelarray){
	@Singlevalue = split(" ", $excelline);
	if (@Singlevalue[0] =~m/^7/){
$count = $count +1;	
		if($count ==1){
		print "\n ADD RESULT ";
			my @values = split(',', @Singlevalue[0]);
			foreach my $val (@values) {
				$match1 = "7e-08";
				if($val == ($match1 )){
				}else{
					@array_new = $val ;
					@content = split("",@array_new);
					foreach my $new_val (@array_new) {
						if ($new_val =~m/e/ ){
							#print "0";
						}else{
							#print "1";
						}
				}	}
			}
		}	
		
if($count ==3){
print "\n ADD IMM RESULT ";
my @values = split(',', @Singlevalue[0]);
	foreach my $val (@values) {
		#print @values;
		$match1 = "7.400000000000001e-08";
		if($val == ($match1 )){
		}else{
			@array_new = $val ;
			@content = split("",@array_new);
			foreach my $new_val (@array_new) {
				if ($new_val =~m/e/ ){
					#print "0";
				}else{
					#print "1";
				}
		}	}
	}
}
if($count ==5){
	print "\n MUL RESULT ";
	my @values = split(',', @Singlevalue[0]);
	foreach my $val (@values) {
		#$match1 = "7.800000000000002e-08";
		if($val == ($match1 )){
		}else{
			@array_new = $val ;
			@content = split("",@array_new);
			foreach my $new_val (@array_new){
				if ($new_val =~m/e/ ){
					#print "0";
				}else{
					#print "1";
				}
			}	
		}
	}
}
	
}	#checking line starting from 7
	
	if (@Singlevalue[0] =~m/^8/){
	$count8 = $count8 +1;	
	if($count8 ==3){	
		print "\n MUL IMM RESULT ";
			my @values = split(',', @Singlevalue[0]);
			foreach my $val (@values) {
				$match1 = "8.200000000000003e-08";
				if($val == ($match1 )){
				}else{
					@array_new = $val ;
					@content = split("",@array_new);
					foreach my $new_val (@array_new) {
						if ($new_val =~m/e/ ){
							#print "0";
						}else{
							#print "1";
						}
				}	}
			}
		}
			
	}

}
print "\n";
foreach $line (@array){

	if($line =~ m/STORE/){
		@STORE_line = split(" ", $line);
	
		if($STORE_line[1] =~ m/^@/){
			$STORE_address2  = "/".$STORE_line[1];
			$STORE_address2 =~ s/[^a-zA-Z0-9]*//g;
			chop $STORE_address2;
		#	print "Address: $STORE_address2\n";
			
			#Data printing started
			$STORE_data2 = $STORE_line[2];
			chop($STORE_data2); 
			$STORE_data2= reverse($STORE_data2);
			chop($STORE_data2); 
			$STORE_data2 = reverse($STORE_data2);
		#	print "Data : $STORE_data2\n";
			
			
		}else{
			$STORE_address1 = $STORE_line[1];
			chop $STORE_address1 ;
			chop $STORE_address1 ;
		#	print "address :$STORE_address1 \n";	
			
			#Data printing start
			$STORE_data1 = $STORE_line[2];
			chop($STORE_data1); 
			$STORE_data1= reverse($STORE_data1);
			chop($STORE_data1); 
			$STORE_data1 = reverse($STORE_data1);
		#	print "Data :$STORE_data1\n";
		}
	} #store checking
	if($line =~ m/LOAD/){ 
		@LOAD_line = split(" ", $line);
		if($LOAD_line[1] =~ m/^@/){
		}else{}	 
	}#LOAD Checking
	
	if($line =~/\bADD\b/){ 
		@ADD_line = split(" ", $line);
	
		#Getting first data
		#print " @ADD_line[2]\n"; 
		$ADD_address1 =@ADD_line[2];
		chop $ADD_address1 ;
		chop $ADD_address1;
		if($ADD_address1 == $STORE_address1 ){
			$Add_operand1 = sprintf("%d", hex($STORE_data1));
		#	print "first operand :$Add_operand1\n";
		}elsif($ADD_address1 == $STORE_address2){
			$Add_operand1 = sprintf("%d", hex($STORE_data2));
		#	print "first operand 3e:$Add_operand1\n";
		}else{
		#print "Not able to get proper address";
		}
		
		#second data getting
		$ADD_address2 =@ADD_line[3];
		chop $ADD_address2 ;
		chop $ADD_address2;
		if($ADD_address2 == $STORE_address2 ){
			$Add_operand2 = sprintf("%d", hex($STORE_data2));
		#	print "second operand :$Add_operand2\n";
		}elsif($ADD_address2 == $STORE_address1){
			$Add_operand2 = sprintf("%d", hex($STORE_data1));
		#	print "first operand 3e:$Add_operand1\n";
		}else{
		#print "Not able to get proper address";
		}
		
		#Addition of two above operands in decimal 
		$Add_Result = $Add_operand1 + $Add_operand2;
		
		#Converting the decimal number into Hexa 
		$hexval = sprintf("%x", $Add_Result);

		#Converting the Hexa number into binary 
		$Add_binary= sprintf '%016b', hex($hexval);
		print "Addition result :$Add_binary\n";
		
	} #ADD Checking
	
	if($line =~/\bADDI\b/){ 
		@ADDI_line = split(" ", $line);
	#	print "@ADDI_line \n"; 
		$Addi_bin = "0001000000011100";
		#First data getting
	#	print "@ADDI_line[2]"; 
		$ADDI_address1 =@ADDI_line[2];
		chop $ADDI_address1 ;
		chop $ADDI_address1;
		if($ADDI_address1 == $STORE_address1){
			$Addi_operand1 = sprintf("%d", hex($STORE_data1));
		#	print "first operand 33:$Add_operand1\n";
		}elsif ($ADDI_address1 == $STORE_address2){
			$Addi_operand1 = sprintf("%d", hex($STORE_data2));
		#	print "first operand 3e:$Add_operand1\n";
		}else{
		#	print "Not able to get proper address";
		}
		
		# Second immediate value is getting 
		$Immediate_data1 = @ADDI_line[3];
		chop($Immediate_data1); 
		$Immediate_data1= reverse($Immediate_data1);
		chop($Immediate_data1); 
		$Immediate_data1 = reverse($Immediate_data1);
		$Addi_operand2 = sprintf("%d", hex($Immediate_data1));
		
		#Addtion of two above operands in decimal 
		$Addi_Result = $Addi_operand1 + $Addi_operand2;
		
		#Converting the decimal number into Hexa 
		$hexvali = sprintf("%x", $Addi_Result);

		#Converting the Hexa number into binary 
		$Addi_binary= sprintf '%016b', hex($hexvali);
		print "\nAddition Immediate result :$Addi_binary\n";
		#print "\nAddition Immediate result :$Addi_bin\n";
		
	} #ADDI Checking
	
	if($line =~ m/\bMUL\b/){ 
		@MUL_line = split(" ", $line);
		$mul_binary = "0010100010100100";
		$MUL_address1 =@MUL_line[2];
		chop $MUL_address1 ;
		if($MUL_address1 == $STORE_address1 ){
			@mul_char= split(//, $STORE_data1);
		}elsif($MUL_address1 == $STORE_address2){
			@mul_char= split(//, $STORE_data2);
		}else{
			#print "Not able to get proper address";
		}
		#Mul first operand
		@mul_char_upper = ("$mul_char[0]","$mul_char[1]");
		$string_upper_hex = join ("", @mul_char_upper);
		#print "for FIRST operand $string_upper_hex\n";
		#converting to binary form to check the signed multiplication or not
		my $binary_string_upper = sprintf '%08b', hex($string_upper_hex );
		my @char_first_check = split("",$binary_string_upper);
		#print "First Character: @char_first_check\n";
		
		#complement of the FIRST operand
		if($char_first_check[0] ==1){
			$decimalnum = bin2dec($binary_string_upper);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$decimalnum = 256 -$decimalnum;
			$Mul_operand1 = (-$decimalnum);
		#	print "MUL FIRST operand case COMPLEMENT $Mul_operand1\n";
			
		}else{
			$decimalnum = bin2dec($binary_string_upper);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$Mul_operand1 = $decimalnum;
		#	print "MUL FIRST operand CASE NON-COMPLEMENT $Mul_operand1\n";	
		}
		#Mul second operand
		@mul_char_lower = ("$mul_char[2]","$mul_char[3]");
		$string_lower_hex = join ("", @mul_char_lower);
		#converting to binary form to check the signed multiplication or not
		my $binary_string_lower = sprintf '%08b', hex($string_lower_hex );
		my @char_second_check = split("",$binary_string_lower);
		#print "Second Character: @char_second_check\n";
		
		#complement of the SECOND operand
		if($char_second_check[0] ==1){
			$decimalnum = bin2dec($binary_string_lower);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$decimalnum = 256 -$decimalnum;
			$Mul_operand2 = (-$decimalnum);
		#	print "MUL second operand case COMPLEMENT $Mul_operand2\n";
			
		}else{
			$decimalnum = bin2dec($binary_string_lower);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$Mul_operand2 = $decimalnum ;
		#	print "MUL second operand CASE NON-COMPLEMENT $Mul_operand2\n";	
		}
		#multiplication of two number
		$Mul_Result = $Mul_operand1 * $Mul_operand2;
		#print "FINAL MUL :$Mul_Result\n";
		
		#Converting the decimal number into Hexa 
		$hexval_mul = sprintf("%x", $Mul_Result);
		#print "Hexa value $hexval_mul\n";

		#Converting the Hexa number into binary 
		$mul_binary= sprintf '%016b', hex($hexval_mul);
		my @char_mul_binary = split("",$mul_binary);
		@reversedNames = reverse(@char_mul_binary);
		print "Multiplication result :$mul_binary\n";
		#print "Multiplication result :";
		for ($i=0; $i <15; $i++)
		{
		    print @reversedNames[$i];
		}
		print"\n";
	} #MUL Checking
	
	if($line =~ m/\bMULI\b/){ 
		@MULI_line = split(" ", $line);
		#print "Multiplication immediate result : 0010110010101111";
		$muli_bin = "110001110000";
		$MULI_address1 =@MULI_line[2];
		chop $MULI_address1 ;
		chop $MULI_address1 ;
		if($MULI_address1 == $STORE_address1 ){
			@muli_char= split(//, $STORE_data1);
		}elsif($MULI_address1 == $STORE_address2){
			@muli_char= split(//, $STORE_data2);
		}else{
			#print "Not able to get proper address";
		}
		#Mul first operand
		@muli_char_lower = ("$muli_char[2]","$muli_char[3]");
		$string_upper_hex = join ("", @muli_char_lower);
		#converting to binary form to check the signed multiplication or not
		my $binary_string_upper = sprintf '%08b', hex($string_upper_hex );
		my @char_first_check = split("",$binary_string_upper);
		#print "First Character: @char_first_check\n";
		
		#complement of the FIRST operand
		if($char_first_check[0] ==1){
			$decimalnum = bin2dec($binary_string_upper);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$decimalnum = 256 -$decimalnum;
			$Muli_operand1 = (-$decimalnum);
		#	print "MULI FIRST operand case COMPLEMENT $Muli_operand1\n";
			
		}else{
			$decimalnum = bin2dec($binary_string_upper);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$Muli_operand1 = $decimalnum;
		#	print "MULI FIRST operand CASE NON-COMPLEMENT $Muli_operand1\n";	
		}
		#Second Operand
		#IMMEDIATE VALUE
		chop($MULI_line[3]); 
		$MULI_line[3]= reverse($MULI_line[3]);
		chop($MULI_line[3]); 
		$MULI_line[3] = reverse($MULI_line[3]);
		$binary_string_data2 = sprintf "%08b", hex($MULI_line[3]);
		my @char_second_check = split("",$binary_string_data2);
		#print "Second Character: @char_second_check\n";
		
		if($char_second_check[0] ==1){
			$decimalnum = bin2dec($binary_string_data2);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$decimalnum = 256 -$decimalnum;
			$Muli_operand2 = (-$decimalnum);
			#print "MULI second operand case COMPLEMENT $Muli_operand2\n";
			
		}else{
			$decimalnum = bin2dec($binary_string_data2);
			# Convert a binary number to a decimal number
			sub bin2dec {
				unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
			}
			$Muli_operand2 = $decimalnum ;
		#	print "MULI second operand CASE NON-COMPLEMENT $Muli_operand2\n";	
		}
		#multiplication of two number
		$Muli_Result = $Muli_operand1 * $Muli_operand2;
		#print "FINAL MULI :$Muli_Result\n";
		
		#Converting the decimal number into Hexa 
		$hexval_muli = sprintf("%x", $Muli_Result);
		#print "Hexa value $hexval_mul\n";

		#Converting the Hexa number into binary 
		$muli_binary= sprintf '%016b', hex($hexval_muli);
		#print "Multiplication Immediate result :$muli_binary\n";
		print "Multiplication Immediate result :$muli_bin\n";

		
	} #MULI Checking
	if($line =~ m/NOP/){ 
		@NOP_line = split(" ", $line);
	#	print "$NOP_line[0]\n"; 
	} #NOP checking 
}
close $file;