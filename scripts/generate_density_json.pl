#! /usr/bin/perl                                                                                                                                                                                  

use strict;

my @colors=("blue","green","red","yellow","grey","orange","purple","black");

my $op_title=$ARGV[0];
$op_title =~ s/summary/json/;

my %chrs=();
system("cut -f1 $ARGV[0] | uniq > chr");
open (input, "<chr") or die "Can't open chr since $!\n";
while (my $line=<input>) {
    chomp($line);
    $chrs{$line}=1;
}
close input;
system("rm chr");

open (output, ">>$op_title") or die "Can't open $op_title since $!\n";
print output "{\"ideograms\":[\n";

my $i=0;
open (input, "<$ARGV[1]") or die "Can't open $ARGV[1] since $!\n";
while (my $line=<input>) {
    chomp($line);
    my @a=split(/\t/, $line);
    if ($chrs{$a[0]}==1) {
        my $len=int($a[1]/$ARGV[2])+1;
        if ($len < 5) {
            $chrs{$a[0]}=0;
            next;
        }
        if ($i > 0) {print output ",\n";}
        print output "{\"id\":\"$a[0]\",\"length\":$len,\"color\":\"$colors[$i % 7]\"}";
        $i++;
    }
}
close input;

print output "\n],\n\"plottracks\":[\n{\n";
print output "\"name\": \"Density\",\n";
print output "\"values\":\n[\n";

my @hist=();
my $last_chr="";
my $i=0;
my $k=0;
open (input, "<$ARGV[0]") or die "Can't open $ARGV[0] since $!\n";
#my $header=<input>;                                                                                                                                                                              
while (my $line=<input>) {
    chomp($line);
    my @a=split(/\t/, $line);
    if ($a[0] eq $last_chr) {
        my $mid=int(($a[1]+$a[2])/2);
        if (int($mid/$ARGV[2]) > $i) {
            $i++;
            $hist[$i]=1;
        }
        else {$hist[$i]++;}
    }
    else {
        if (($last_chr ne "") && ($chrs{$last_chr} == 1)) {
            if ($k > 0) {print output ",\n";}
            print output "{\"color\":\"$colors[$k % 7]\",\"chr\":\"$last_chr\",\"values\":[";
            for my $j (0..$i-1) {print output "$hist[$j],";}
            print output "$hist[$i]]}";
            $k++;
        }
        $i=0;
        $hist[0]=1;
        $last_chr=$a[0];
    }
}
close input;

print output "\n]}\n]\n}\n";
close output;
