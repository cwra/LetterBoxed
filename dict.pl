#!/usr/bin/perl
use strict;
use warnings;



open my $infh, "<:encoding(utf8)", "dictionary.txt" or die "file: $!";
my @lines = <$infh>;
close $infh;


my @words = ();
my @touse = ();

chomp @lines;
for my $line (@lines) {
    @words = split(' ', $line);
	if (defined $words[0]){
		my $text = uc($words[0]);
		my $anymatch = 0;
		$anymatch++ if ($text =~ /\W|\d|-|[^[:ascii:]]/);		
		push @touse, $text if($anymatch == 0 && length($text)>=3);
	}
}

sub uniq {
    my %ss;
    grep !$ss{$_}++, @_;
}

my @dict = uniq(@touse);

my $filename = 'dict.txt';
open(my $outfh, '>', $filename) or die "Could not open file '$filename' $!";
print $outfh "@dict";
close $outfh;

