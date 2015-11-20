#!/usr/bin/perl -w 

my $lensum=0 ; 

my $qualsum=0;
my $hiqual=0;
my $reads =0;
my $maxqual=0;
my $maxlen=0;

while(my $tmp = <>) {
	my $seq=<>;$tmp=<>;
	my $qual=<>;
	
	my $len=length($seq);
	if($len == 0) {
		next;
	}
	
	$lensum+=$len;
	if ($len > $maxlen) {
		$maxlen = $len;
	}

	my (@qualchr) = split(/ */, $qual);
	
	my $qualthr=15;
	
	while (my $qualchr = shift(@qualchr) ) {
		$qualval = ord($qualchr) - 33;
		if ($qualval > $qualthr) {	
			$hiqual++;
		}
		
		if($qualval > $maxqual) {
			$maxqual = $qualval;
		}
		$qualsum += $qualval;
	}
	$reads++;
}

print "Reads: $reads\n";
print "Total length: $lensum\nAvg len: ",sprintf("%.2f",$lensum/$reads),"\n";
print "Max length: ",$maxlen,"\n";
print "Number of hiqual bases: $hiqual\n";
print "Max qual: ", $maxqual,"\n";
print "Qual sum: ", $qualsum, " avg ",sprintf("%.2f",$qualsum/$lensum),"\n";


