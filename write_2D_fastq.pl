#!/usr/bin/perl -w
use warnings;
use PDL;
use PDL::IO::HDF5;
use PDL::IO::HDF5::Group;
use PDL::IO::HDF5::Dataset;

#  ../bin/write_fastq.pl *.fast5 > ../r7_burnin_oldlib.fastq

if ( @ARGV < 1 ) {
	print STDERR "Usage: write_fastq.pl <filenames>\n";
}

my $success = 0;
my $tries = @ARGV;
foreach my $filename (@ARGV) {

	my $newfile = new PDL::IO::HDF5($filename);

	if (!$newfile) {
		print STDERR "Could not open HDF5-file: $filename.\n";
		next;
	}
	my @groups = $newfile->groups;
	if (!@groups) {
		print STDERR "Could not open root groups in HDF5-file: $filename.\n";
		next;
	}
	
	my $basecalled_2D = $newfile->group("/Analyses/Basecall_2D_000/BaseCalled_2D");
	if (!$basecalled_2D) {
		print STDERR "Could not open Basecall_2D_000/BaseCalled_2D in HDF5-file: $filename.\n";
		next;
	}
	
	my $fastq =	$basecalled_2D->dataset('Fastq');
	if (!$fastq) {
		print STDERR "Could not open Basecall_2D_000/BaseCalled_2D fastq in HDF5-file: $filename.\n";
		next;
	}

	my $fastq_pdl = $fastq->get();
	$fastq_pdl =~ s/^\'\@/\@/;
	$fastq_pdl =~ s/\'\ //s;
	chomp $fastq_pdl;
	print $fastq_pdl, "\n";
	
	$success++;
}
print STDERR "Success in $success out of $tries files.\n";
