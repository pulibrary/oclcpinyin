#!/usr/bin/perl -w

use strict;

binmode(STDOUT, ":utf8");
open(INFILE, "<:encoding(UTF-8)", "Unihan_Readings.txt");

my %chars;

while(<INFILE>) {
    chomp;
    if(/U\+([0-9A-F]{4,6})\t(k\S*)\t(\S+)/) {
	 	my ($charHex, $type, $py) = ($1, $2, $3);
	 	if(!exists $chars{$charHex}) {
	   	$chars{$charHex} = {};
	 	}
	 	$chars{$charHex}{$type} = $py;
    }
}

foreach my $char (sort keys %chars) {
    my $py = ""; 
    if(exists $chars{$char}{"kHanyuPinlu"}) {
	$py = $chars{$char}{"kHanyuPinlu"};
	$py = stripAccents($py);
	$py =~ s/\x{FC}/u:/g;
	$py =~ s/^([a-z:]+).*/$1/g;
    } elsif(exists $chars{$char}{"kXHC1983"}) {
	$py = $chars{$char}{"kXHC1983"};
	$py =~ s/.*:([^:]+)/$1/;
	$py = stripAccents($py);
	$py =~ s/\x{FC}/u:/g;
    } elsif(exists $chars{$char}{"kHanyuPinyin"}) {
	$py = $chars{$char}{"kHanyuPinyin"};
	$py =~ s/.*:([^:,]+).*/$1/;
	$py = stripAccents($py);
	$py =~ s/\x{FC}/u:/g;
    } elsif(exists $chars{$char}{"kMandarin"}) {
	$py = $chars{$char}{"kMandarin"};
	$py = lc($py);
	$py = stripAccents($py);
	$py =~ s/\x{FC}/u:/g;
	$py =~ s/([a-z:]+).*/$1/;
    }
    #special cases
    if($char eq "4E86") { #le
	$py = "liao";
    } elsif($char eq "90FD") {  #dou
	$py = "du";
    } elsif($char eq "5730") { #de
	$py = "di";
    } elsif($char eq "7740" || $char eq "8457") { #zhe
	$py = "zhu";
    }
    if($py eq "r") {
	$py = "er";
    }
    if($py ne "" && $py =~ /^[a-z:]+$/ && $py =~ /[aeiou]/) {
	print "$char\t$py\n";
    }
}

sub stripAccents {
    my $py = shift;
    $py =~ s/\x{101}/a/g;
    $py =~ s/\x{E1}/a/g;
    $py =~ s/\x{1CE}/a/g;
    $py =~ s/\x{E0}/a/g;
    $py =~ s/\x{113}/e/g;
    $py =~ s/\x{E9}/e/g;
    $py =~ s/\x{11B}/e/g;
    $py =~ s/\x{E8}/e/g;
    $py =~ s/\x{12B}/i/g;
    $py =~ s/\x{ED}/i/g;
    $py =~ s/\x{1D0}/i/g;
    $py =~ s/\x{EC}/i/g;
    $py =~ s/\x{14D}/o/g;
    $py =~ s/\x{F3}/o/g;
    $py =~ s/\x{1D2}/o/g;
    $py =~ s/\x{F2}/o/g;
    $py =~ s/\x{16B}/u/g;
    $py =~ s/\x{FA}/u/g;
    $py =~ s/\x{1D4}/u/g;
    $py =~ s/\x{F9}/u/g;
    $py =~ s/\x{1D6}/\x{FC}/g;
    $py =~ s/\x{1D8}/\x{FC}/g;
    $py =~ s/\x{1DA}/\x{FC}/g;
    $py =~ s/\x{1DC}/\x{FC}/g;
    $py =~ s/\x{1E3F}/m/g;
    return $py;
}
