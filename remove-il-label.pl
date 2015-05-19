#!/usr/bin/perl -w

use strict;

open(INFILE, "$ARGV[0]") || die("Cannot open file");

my @lines = <INFILE>;

close(INFILE);

my $label_pattern = qr/IL_[\dabcdef]{4}/o;

my %label_count;

foreach (@lines) {

	if (m/:.+($label_pattern)/) {
		$label_count{$1}++;
	}
}

foreach (@lines) {

	if (m/($label_pattern):/) {

		if (!defined($label_count{$1}) || $label_count{$1} < 1) {

			my $pos = index($_, $1);

			if ($pos < 0) {
				print "EXCEPTION: $_";
				die("-->A label is expected.");
			}

			print substr($_, 0, $pos) . "        " . substr($_, 8 + $pos);

		} else {

			print $_;

		}
	} else {

		print $_;

	}
}