#!/usr/bin/perl -w
use warnings;

use PDL;
use PDL::IO::HDF5;
use PDL::IO::HDF5::Group;
use PDL::IO::HDF5::Dataset;

my $filename = $ARGV[0];

my $newfile = new PDL::IO::HDF5($filename);

my @groups = $newfile->groups;
print join "\t", @groups;
print "\n";


