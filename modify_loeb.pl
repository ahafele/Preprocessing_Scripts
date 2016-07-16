#!/s/sirsi/Perl/bin/perl

# /s/SUL/Bin/Eloader/Loeb/modify_loeb.pl

# created 7/14/2016
# Alissa Hafele

# Changes 050 or 082 2nd indicator from 0 to 4


use strict;
use warnings;
use open qw(:utf8 :std);

(my $this_script_name = $0) =~ s!^.*/!!; # Remove directory path

(@ARGV == 1)
or &ErrorExit("Invalid cmd line, one arg required: input path");
my $path = $ARGV[0];

&ToLog("Begin $this_script_name", "Input file: $path");

my @awk_output = `cat $path | awk -f/s/SUL/Bin/join_flatskipped_lines.awk`;

# variables for counting
my $n_bibs = 0;
my $n_lines = 0;
my $n_050_indic_changed = 0;
my $n_082_indic_changed = 0;

foreach (@awk_output) {
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
			if ($_ eq "*** DOCUMENT BOUNDARY ***\n") {
				$n_bibs++;

			}

			print; # Most lines, including drop through from some blocks above
		}

$n_bibs or &ErrorExit("No bib records in input from "
		                           . ($path eq "_" ? "STDIN" : $path));

&ToLog("Finished $this_script_name",
     "$n_lines lines read\n",
     "$n_bibs bib records read\n",
	   "$n_050_indic_changed num 050 indicators changed\n",
	   "$n_082_indic_changed num 082 indicators changed\n");

		 ######## GENERIC SUBS (should put in a module?) ############################

		 # File open wrapper with error message handling
		 sub FileOpen()
		 {
		   my $mode_path = shift;

		   $mode_path =~ s/^ *//; # Trim any leading space before verifying
		   my $mode;
		   my $path;
		   if ($mode_path =~ /^([><]+)\s*(.*[^\s]) *$/)
		   {
		     $mode = $1;
		     $path = $2; # Only for error message
		   }
		   else { $path = $mode_path; }

		   ($mode eq "<" || $mode eq ">" || $mode eq ">>")
		     or &ErrorExit("Invalid file open mode \"$mode\" for $path");

		   my $fh;
		   open ($fh, "$mode $path")
		     or &ErrorExit("Error opening $path for "
		                   . ($mode eq "<" ? "read"
		                                   : ($mode eq ">" ? "write" : "append") ),
		                   $!);
		   return $fh
		 }
		 # Wrappers for above, param is path only, returns file handle
		 sub OpenRead() { return &FileOpen("< " . $_[0]); }
		 sub OpenWrite() { return &FileOpen("> " . $_[0]); }
		 sub OpenAppend() { return &FileOpen(">> " . $_[0]); }

		 sub ToLogRaw()
		 {
		   # If more than one param, write as separate lines
		   my $log_entry;
		   for (@_)
		   {
		    $log_entry .= $_ . "\n";
		   }

		   print STDERR $log_entry;
		   return;
		 }

		 sub ToLog()
		 {
		   # Start log entry with time stamp
		   my ($sec, $min, $hour) = localtime;
		   my $log_entry = sprintf("%02d:%02d:%02d  ", $hour, $min, $sec);

		   # If more than one param, write as separate lines
		   for (@_)
		   {
		    $log_entry .= $_ . "\n";
		   }

		   chomp($log_entry); # ToLogRaw will add \n to last line of $log_entry
		   &ToLogRaw($log_entry);
		 }

		 sub ErrorExit()    # Assumes global var $this_script_name
		 {
		   # Use entire array as single error message
		   my $errmsg = "$this_script_name fatal error:\n";
		   for (@_)
		   {
		     $errmsg .= $_ . "\n";
		   }

		   chomp($errmsg); # ToLog will append \n to last line
		   &ToLog($errmsg);
		   exit 1;
		 }
