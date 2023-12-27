#!/usr/bin/perl

use strict;
use utf8;
use Encode qw( encode decode );


binmode(STDOUT, "utf8");

my %pinyin;
my %dict;

open(PINYIN, "pinyin.txt");
while(<PINYIN>) {
    chomp;
    my ($ccode, $ctext) = split(/\t/,$_);
    $ctext =~ s/v/u:/g;
    $ctext =~ s/u:e/ue/g;
    $ccode = uc($ccode);
    if(!exists $pinyin{$ccode}) {
		$pinyin{$ccode} = lc($ctext);
    }
}
close(PINYIN);

open (INFILE, "<:utf8", $ARGV[0]);
while(<INFILE>) {
    chomp;
    /(.*)\t(.*)/;
    my ($chars, $pinyin) = ($1, $2);
    
    if($pinyin eq "xx") {
		next;
    }

    if(exists $dict{$chars}) {
		next;
    }

    my @chars = split(//,$chars);
    my $pinyin2 = "";

    for (my $i = 0; $i < @chars; $i++) {
		if(ord($chars[$i]) > 255) {
	    	my $hexcode = sprintf("%X", ord($chars[$i]));
	    	if($i == 0 && !exists $dict{$chars[$i]}) {
				my $firstpy = $pinyin;
				$firstpy =~ s/\s.*//;
				$firstpy =~ s/u:e/ue/g;
				if($firstpy eq $pinyin{$hexcode} || !exists $pinyin{$hexcode}) {
		    		$pinyin{$hexcode} = $firstpy;
		    		$firstpy =~ s/u:/u\x{0308}/g;
		    		$firstpy =~ s/([ln])ue/$1u\x{0308}e/g;
		    		$dict{$chars[$i]} = $firstpy;
				} else {
		    		my $realpy = $pinyin{$hexcode};
		    		$realpy =~ s/u:/u\x{0308}/g;
		    		$realpy =~ s/u:e/ue/g;
		    		$realpy =~ s/([ln])ue/$1u\x{0308}e/g;
		    		$dict{$chars[$i]} = $realpy;
				}
	    	}
	    	my $py = $pinyin{$hexcode};
	    	if($py eq "") {
				$py = "\{$hexcode\} ";
	    	}
	    	$pinyin2 .= "$py ";
		} else {
	   	$pinyin2 .= "$chars[$i] ";
		}
    }
    $pinyin2 =~ s/\s+$//;
    my $pinyin1 = $pinyin;
    $pinyin1 =~ s/u:e/ue/g;
    if($pinyin1 ne $pinyin2 && length($chars) < 3) {
		$pinyin =~ s/u:/u\x{0308}/g;
		$pinyin =~ s/([ln])ue/$1u\x{0308}e/g;
		if(!exists $dict{$chars}) {
	   	 $dict{$chars} = $pinyin;
		}
    }
}
close(INFILE);

foreach my $key (sort keys %dict) {
    print "$key\t$dict{$key}\n";
}
foreach my $code (sort keys %pinyin) {
	my $c = chr(hex($code));
	if(!exists $dict{$c}) {
		my $p = $pinyin{$code};
		$p =~ s/u:/u\x{0308}/g;
		$p =~ s/u:e/ue/g;
		$p =~ s/([ln])ue/$1u\x{0308}e/g;

		print "$c\t$p\n";
	}
}
