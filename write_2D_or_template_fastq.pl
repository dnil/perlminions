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
	my $ok=0;
	
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

	my $fastq;
	my $basecalled_2D = $newfile->group("/Analyses/Basecall_2D_000/BaseCalled_2D");
	if ($basecalled_2D) {
			
		$fastq =	$basecalled_2D->dataset('Fastq');
			if (!$fastq) {
			print STDERR "Could not open Basecall_2D_000/BaseCalled_2D fastq in HDF5-file: $filename.\n";
			next;
		}
		$ok=1;
	} else {
		print STDERR "Could not open Basecall_2D_000 in HDF5-file: $filename - trying template only.\n";
	
		my $basecalled_template = $newfile->group("/Analyses/Basecall_2D_000/BaseCalled_template");
		if (!$basecalled_template) {
			print STDERR "Could not open Basecall_2D_000/BaseCalled_template in HDF5-file: $filename.\n";
			next;
		}
	
		$fastq =	$basecalled_template->dataset('Fastq');
		if (!$fastq) {
			print STDERR "Could not open Basecall_2D_000 fastq in HDF5-file: $filename.\n";
			next;
		} 
		$ok=1; 
	}

	if($ok == 1) {
		my $fastq_pdl = $fastq->get();

		$fastq_pdl =~ s/^\'\@/\@/;
		$fastq_pdl =~ s/\'\ //s;
		chomp $fastq_pdl;
		print $fastq_pdl, "\n";
	
		$success++;
	}
}
print STDERR "Success in $success out of $tries files.\n";
