#!/s/sirsi/Perl/bin/perl

# created 7/15/2016
# Alissa Hafele

# Changes 050 or 082 2nd indicator from 0 to 4
# Removes $3 from all of the 856 tags
## .856. 40|3Stanford scholarship online|uhttp://dx.doi.org/10.11126/stanford/9780804791953.001.0001

use strict;
use warnings;
use open qw(:utf8 :std);

# variables for counting
my $n_bibs = 0;
my $n_lines = 0;
my $n_050_indic_changed = 0;
my $n_082_indic_changed = 0;
my $n_856sub3_removed = 0;

# variables for storing data
my $new_field856;

while (<STDIN>) {
	$n_lines++;

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


	if (/^\.856\./) {
		# remove |3 and |z from field 856
		chomp;
		my $field856_tag = substr ($_, 0, 8);
		my $field856 = substr ($_, 8);
		my @field_856_parts = split /\|/, $field856;

		foreach my $field_856_parts (@field_856_parts) {
			if ($field_856_parts =~ /^[3].+/) {
				$field_856_parts = "";
				$n_856sub3_removed++;
			}
		}

		$new_field856 = join "|", @field_856_parts;

		# Remove extra pipes caused by empty array element within field
		$new_field856 =~ s/\|{2,}/\|/;

		# Remove extra pipes for empty array elements at the end of the field
		until (substr($new_field856, -1, 1) ne "|") {
			substr($new_field856, -1, 1) = "";
		}

		print $field856_tag . $new_field856 . "\n";
		next;
	}

	if ($_ eq "*** DOCUMENT BOUNDARY ***\n") {
		$n_bibs++;

		# clear variables for the next record
			$new_field856 = "";
}

	print; # Most lines, including drop through from some blocks above
}

print "$n_lines lines read\n",
       "$n_bibs bib records read\n",
	   "$n_050_indic_changed num 050 indicators changed\n",
	   "$n_082_indic_changed num 082 indicators changed\n",
	   "$n_856sub3_removed number of 856 subfields 3 removed\n";
