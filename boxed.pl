#!/usr/bin/env perl

# Version 1.0
# 01-Dec-2022
# Christian Raschke

use strict;
use warnings;

print "------------------------------\n";
print "------------------------------\n";
print "NYT Letter Boxed Puzzle Solver\n";
print "------------------------------\n";
print "------------------------------\n";
print "Version 1.0\n";
print "01-Dec-2022\n";
print "Christian Raschke\n";
print "------------------------------\n\n";
print "Enter the provided 12 letters in 4 groups of three, separated by spaces\n\n";
print "Example:    A B C              \n";
print "          L|-----|D     Just enter \n";
print "          K|     |E     ABC DEF GHI JKL \n";
print "          J|_____|F       \n";
print "            I H G       The order of letters within the group does not matter.  \n";
print "                        The order of the groups does not matter.\n";
print "                        Uppercase/lowercase also does not matter.\n";
print "Input:\n";


## Collect the input letters to be used
## As user input

my $usrinput = <>;
chomp($usrinput);

my @lettergroups = split (' ', uc($usrinput));
my @letters = sort {$a cmp $b} (split(//, uc($usrinput)));
die "ERROR: The input doesn't look right.\n" if(@lettergroups != 4);
die "ERROR: The input doesn't look right.\n" if(@letters != 15); # Count the spaces. 

## Getting letters of the alphabet that are NOT used;
my %seen;					#lookup tag
my @badletters;				#Letters that must not be in the words
my @ALPHABET = ("A".."Z");
@seen{@letters} = ();

foreach (@ALPHABET) {
	push(@badletters, $_) unless exists $seen{$_};
}
my $badlets = join('', @badletters);

my @forbiddencombos = ();
foreach my $i (@lettergroups){
	foreach my $j (0, 1, 2){
		foreach my $k (0, 1, 2){
			push @forbiddencombos, substr($i, $j, 1).substr($i, $k, 1);
		}
	}
}
my $badcombos = join("|", @forbiddencombos);
## Getting in the dictionary;
open my $in, "<:encoding(utf8)", "dict.txt" or die "file: $!";
my @dict = split(' ', <$in>);
close $in;
chomp @dict;

my @touse = ();
foreach my $dictword (@dict) {
	next if ($dictword =~ /[$badlets]/);
	next if ($dictword =~ /$badcombos/);
	push @touse, $dictword if(length($dictword)>=3);
}

sub uniq {
    my %ss;
    grep !$ss{$_}++, @_;
}

my $numberofwords = @touse;
print "\nThere are $numberofwords different words possible on the cube ($lettergroups[0]) ($lettergroups[1]) ($lettergroups[2]) ($lettergroups[3])\n\n";
# Find combos:
print "\n 2-WORD PUZZLE SOLUTION(S):\n\n";
foreach my $i (@touse){
	foreach my $j (@touse){
		my $endi = substr($i, -1, 1);
		my $begj = substr($j, 0, 1);
		if($endi eq $begj){
			my @usedhere = uniq(split('', $i), split('', $j));
			my $nolets = @usedhere;
			print "||||> $i - $j <||||\n" if($nolets >= 12);
		}
	}
}

END {
    print "\n\n Press enter to exit\n";
    <>;
}

