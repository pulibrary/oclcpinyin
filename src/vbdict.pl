#!/usr/bin/perl

use strict;
use feature 'switch';

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
open(INFILE, "<:encoding(UTF-8)", $ARGV[0]);

my %charsHASH;

while(<INFILE>) {
    s/\s+$//;
    if(/^\s*$/) {
	next;
    }

    if($_ !~ /[\x{3000}-\x{9FFF}\x{20000}-\x{2FFFF}]/) {
	next;
    }

    #convert SMP characters to surrogate pairs
    if(/[\x{20000}-\x{2FFFF}]/) {
	my $newstr = "";
    	for(my $i = 0; $i < length($_); $i++) {
       	    my $c = substr($_,$i,1);
            if($c =~ /[\x{20000}-\x{2FFFF}]/) {
                my $cval = ord($c) - 0x10000;
                my $clow = ($cval % 0x400) + 0xDC00;
                my $chigh = ($cval / 0x400) + 0xD800; 
                $c = chr($chigh) . chr($clow);
	    } 
            $newstr .= $c;
        }
        $_ = $newstr;
    }


    #remove BOM
    s/\x{FEFF}//g;
    my ($charStr, $py) = split(/\t/, $_);
    my $len = length($charStr);

    #some characters will have their pinyin versions followed by a "#"
    #and a number because they have numerical meanings that will be interpreted by
    #the VB script

    if($len == 1) {
	 for($charStr) {
	    when("\x{3007}") {$py .= "#0"}
	    when("\x{96F6}") {$py .= "#0"}
	    when("\x{4E00}") {$py .= "#1"}
	    when("\x{4E8C}") {$py .= "#2"}
	    when("\x{4E24}") {$py .= "#2"}
	    when("\x{5169}") {$py .= "#2"}
	    when("\x{4E09}") {$py .= "#3"}
	    when("\x{56DB}") {$py .= "#4"}
	    when("\x{4E94}") {$py .= "#5"}
	    when("\x{516D}") {$py .= "#6"}
	    when("\x{4E03}") {$py .= "#7"}
	    when("\x{516B}") {$py .= "#8"}
	    when("\x{4E5D}") {$py .= "#9"}
	    when("\x{5341}") {$py .= "#10"}
	    when("\x{5EFF}") {$py .= "#20"}
	    when("\x{5EFE}") {$py .= "#20"}
	    when("\x{5345}") {$py .= "#30"}
	    when("\x{534C}") {$py .= "#40"}
	    when("\x{767E}") {$py .= "#100"}
	    when("\x{5343}") {$py .= "#1000"}
	    when("\x{842C}") {$py .= "#10000"}
	    when("\x{4E07}") {$py .= "#10000"}
	    when("\x{5104}") {$py .= "#100000000"}
	    when("\x{4EBF}") {$py .= "#100000000"}
	    #nian (year)
	    when("\x{5E74}") {$py .= "#"}
	    #yue (month)
	    when("\x{6708}") {$py .= "#"}
	    #ri (day)
	    when("\x{65E5}") {$py .= "#"}
	    #di (ordinal marker)
	    when("\x{7B2C}") {$py .= "#"}
	    #zhi/ji (for date ranges)
	    when("\x{81F3}") {$py .= "#"}
	    when("\x{53CA}") {$py .= "#"}
	}
    }

    #skip phrases containing numbers
    if($charStr =~ /\x{5341}/ && $len > 1) {
	next;
    }

    my @charsARR = split(//, $charStr);
    my $hexcode = sprintf("%.4X", ord($charsARR[0]));
    my ($hexA, $hexB) = ($hexcode, "");
    if($hexcode !~ /^D[89A-F]/) {
        $hexcode =~ /(...)(.)/;
        ($hexA, $hexB) = ($1, $2);
    }
    #exclude fullwidth roman chars
    if($hexA =~ /^FF/) {
	next;
    }
    if(!exists $charsHASH{$hexA}) {
	$charsHASH{$hexA} = {};
    }
    if(!exists $charsHASH{$hexA}{$hexB}) {
	$charsHASH{$hexA}{$hexB} = {}; 
    }
    if($len == 1) {
	$charsHASH{$hexA}{$hexB}->{"Pinyin"} = $py;
    } 
    my $hex2 = $charsHASH{$hexA}{$hexB};
    for(my $i = 1; $i < $len; $i++) {
	$hexcode = sprintf("%.4X", ord($charsARR[$i]));
	if(!exists $hex2->{$hexcode}) {
	    $hex2->{$hexcode} = {};
	}
	if($i + 1 == $len) {
	    $hex2->{$hexcode}->{"Pinyin"} = $py;
	} else {
	    $hex2 = $hex2->{$hexcode};
	}
    }
}

my $declarations = "";
my $selection = "";
my $definitions = "";

sub tab {
    my $n = shift;
    my $s = "";
    for(my $i = 0; $i < $n; $i++) {
	$s .= "\t";
    }
    return $s;
}

sub clearChars {
    my $n = shift;
    my $t = shift;
    $n = $n - 1;
    my $s = "";
    for(my $i = 1; $i <= $n; $i++) {
	$s .= "${t}arrChars(i+$i) = \"\"\r\n";
    }
    return $s;
}

sub printCharChart {
    my $str = shift;
    my $pystr = shift;
    my $pylevel = shift;
    my $hCharHash = shift;

    my $level = length($str);
    my $tabStr = tab($level);


    if(!exists $hCharHash->{"Pinyin"}) {
	$hCharHash->{"Pinyin"} = $pystr;
    } else {
	$pylevel = $level;
    }

    my $resultStr = "";
    my @hashKeys = sort keys %{$hCharHash};

    if($pylevel == $level) {
	$resultStr = "${tabStr}arrChars(i) = \"$pylevel" . $hCharHash->{"Pinyin"} . "\"\r\n";
    }
    
    if(@hashKeys == 1) {
	return $resultStr;
    }


    $resultStr .= "${tabStr}If UBound(arrChars) >= i+$level Then\r\n";
    $resultStr .= "${tabStr}Select Case GetHexCode(arrChars(i+$level))\r\n";
    foreach my $hexcode (@hashKeys) {
	if($hexcode ne "Pinyin") {
	    $str .= chr(hex($hexcode));
	    my $hCharHash2 = $hCharHash->{$hexcode};
	    $resultStr .= "${tabStr}Case &H$hexcode&\r\n";
	    $resultStr .= printCharChart($str, $hCharHash->{"Pinyin"}, $pylevel, $hCharHash2);
	    $str = substr($str,0,-1);
	}
    }
    $resultStr .= "${tabStr}End Select\r\n";
    $resultStr .= "${tabStr}End If\r\n";
    return $resultStr;
}

my $prevHexAA = "";
foreach my $hexA (sort keys %charsHASH) {
    my $hexAA = substr($hexA,0,2);
    my $hexAB = substr($hexA,2);
    if($hexAA ne $prevHexAA) {
       if($prevHexAA ne "") {
	   $definitions .= "End Select\r\nEnd Function\r\n";
       }
       $declarations .= sprintf("Declare Function TransliterateChinese%s(i As Integer) As String\r\n", $hexAA);
       $selection .= sprintf("Case &H%s\r\n\t TransliterateChinese%s(i)\r\n",$hexAA,$hexAA);
       $definitions .= sprintf("Function TransliterateChinese%s(i As Integer) As String\r\n",$hexAA);
       $definitions .= "Select Case GetHexCode(arrChars(i))\r\n";
    }
    if(length($hexA) == 4) {
	$definitions .= sprintf("Case &H%s&\r\n\tTransliterateChinese%s(i)\r\n",$hexA,$hexA);
    } else {
        $definitions .= sprintf("Case &H%s0& To &H%sF&\r\n\tTransliterateChinese%s(i)\r\n",$hexA,$hexA,$hexA);
    }
    $prevHexAA = $hexAA;
}
$definitions .= "End Select\r\nEnd Function\r\n";

foreach my $hexA (sort keys %charsHASH) {
    my %hexBhash = %{$charsHASH{$hexA}};
    $declarations .= sprintf("Declare Function TransliterateChinese%s(i As Integer) As String\r\n", $hexA);
    $definitions .= sprintf("Function TransliterateChinese%s(i As Integer) As String\r\n", $hexA);    
    $definitions .= "Select Case GetHexCode(arrChars(i))\r\n";
    foreach my $hexB (sort keys %hexBhash) {
	my $str = chr(hex("$hexA$hexB")); 
	my $hex2hash = $hexBhash{$hexB};
	$definitions .= sprintf("Case &H%s%s&\r\n", $hexA, $hexB);
	my $clear = 0;
	$definitions .= printCharChart($str, "", 1, $hex2hash);
    }
    $definitions .= "End Select\r\n";
    $definitions .= "End Function\r\n";
}
close(INFILE);

#umlaut
$definitions =~ s/u\x{0308}e/ue/g;
$definitions =~ s/\x{0308}/&#x0308;/g;

open(TEMPFILE, "<:encoding(UTF-8)", "vbdictTemp.txt");

while(<TEMPFILE>) {
    s/\[Function Declarations\]/$declarations/;
    s/\[Function Selection\]/$selection/;
    s/\[Function Definitions\]/$definitions/;
    print;
}

#debugging code for counting size of each sub-routine (above 1100 lines tends to choke Connexion)
my @defs = split(/\n/, $definitions);
my ($c,$f)= (0,"");
for(my $i = 0 ; $i < @defs; $i++) {
	if($defs[$i] =~ /Function TransliterateChinese([0-9A-F]*)/) {
		$f = $1;
	}
	if($defs[$i] =~ /End Function/) {
		print STDERR "$f\t$c\n";
		$c = 0;
	}
	$c++;
}
