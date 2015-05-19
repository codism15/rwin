#!/usr/bin/perl -w

# password generator

use strict;
use warnings;

my $charset="012345678923456abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";

my $numArgs = $#ARGV + 1;

if ($numArgs == 1)
{
	# using command line specified char. set
	$charset = $ARGV[0];
}

my @arr = split //,$charset;

my $arrlen = @arr;

for (my $row = 0 ; $row < 8 ; $row++) {

	for (my $col = 0 ; $col < 8 ; $col++) {

		for (my $i = 0 ; $i < 10 ; $i++) {
			print $arr[int(rand($arrlen))];
		}

		print ' ';

	}

	print "\n";

}

