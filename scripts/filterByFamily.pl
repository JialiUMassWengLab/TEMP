#! /usr/bin/perl                                                                                                                                                         

use strict;

my %family=();
open (input, "<$ARGV[0]") or die "Can't open $ARGV[0] since $!\n";
while (my $line=<input>) {
    chomp($line);
    my @a=split(/\t/, $line);
    $family{$a[0]}=$a[1];
}
close input;

open (input, "<tmp1") or die "Can't open tmp1 since $!\n";
open (output, ">>tmp2") or die "Can't open tmp2 since $!\n";
while (my $line=<input>) {
    chomp($line);
    my @a=split(/\t/, $line);
    if (($family{$a[3]} eq $family{$a[9]}) && ($a[5] eq $a[11])) {
        print output "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\n";
    }
}
close input;
close output;
