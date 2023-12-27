#!/usr/bin/perl -w

use strict;
use utf8;

binmode(STDOUT, "utf8");

#dictionary from http://www.mdbg.net/chindict/chindict.php?page=cedict

open(INFILE, "<:encoding(UTF-8)", "cedict_ts.u8.txt");
while(<INFILE>) {
    my $line =$_;
    if(/^\#/) {
	next;
    }
    $_ = lc $_;
    s/ \/.*//g;
    s/, //g;
    s/\x{FF0C}//g;
    s/\x{30FB}//g;
    s/\x{B7}//g;
    my ($trad, $simp, $pinyin) = ("", "", "");
    my $len = 0;
    if(/^(.*) \[([^\]]+)\]/) {
	$trad = $1;
	$pinyin = $2;
	$simp = $trad;
	$len = (length($trad) - 1) / 2;
	$trad =~ s/ .{$len}$//;
	$simp =~ s/^.{$len} //;
	$pinyin =~ s/[0-9]//g;
	$pinyin =~ s/ r$/ er/g;
    }
    print "$trad\t$pinyin\n";
    if($simp ne $trad) {	
	print "$simp\t$pinyin\n";
    }
}
close(INFILE);

