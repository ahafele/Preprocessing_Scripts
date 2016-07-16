#!/s/sirsi/Perl/bin/perl

# created 7/14/2016
# Alissa Hafele


# /s/SUL/Bin/Eloader/Loeb/modify_loeb.pl
# Changes 050 or 082 2nd indicator from 0 to 4


use strict;
use warnings;
use open qw(:utf8 :std);


# variables for counting
my $n_bibs = 0;
my $n_lines = 0;
my $n_050_indic_changed = 0;
my $n_082_indic_changed = 0;

my $handle = "loeb.flat";
my @awk_output = `cat $handle | awk -f/s/SUL/Bin/join_flatskipped_lines.awk`;
close $handle; ## Best way to do this? always needed when lines could be on more than one?

foreach (@awk_output) {
	$n_lines++;

# #to test
# while (<STDIN>) {
# 	$n_lines++;

	# Change the 2nd indicator for 050 to 4
	if (/^\.050\./) {
		my $indicator_2 = substr($_, 7, 1);

		if ($indicator_2 ne "4") {
			substr($_, 7, 1) = "4";
			$n_050_indic_changed++;
		}

	}

	# Change the 2nd indicator for 082 to 4
	if (/^\.082\./) {
		my $indicator_2 = substr($_, 7, 1);

		if ($indicator_2 ne "4") {
			substr($_, 7, 1) = "4";
			$n_082_indic_changed++;
		}
}
			if ($_ eq "*** DOCUMENT BOUNDARY ***\n") {
				$n_bibs++;

			}

			print; # Most lines, including drop through from some blocks above
		}



print STDERR
     "$n_lines lines read\n",
     "$n_bibs bib records read\n",
	   "$n_050_indic_changed num 050 indicators changed\n",
	   "$n_082_indic_changed num 082 indicators changed\n";
