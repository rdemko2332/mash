#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my ($input,$bestRepFasta);

&GetOptions("input=s"=> \$input,
	    "bestRepFasta=s"=> \$bestRepFasta);

open(my $bestReps, '<', $bestRepFasta) || die "Could not open file $bestRepFasta: $!";

# Make hash to store bestReps
my %seqToSeqId;
my $currentSeqId;
while (my $line = <$bestReps>) {
    chomp $line;
    if ($line =~ /^>(\S+).*/) {
        $currentSeqId = $1;
    }
    else {
        if ($seqToSeqId{$currentSeqId}) {
            $seqToSeqId{$currentSeqId} = "$seqToSeqId{$currentSeqId}" . "$line";
        }
        else {
            $seqToSeqId{$currentSeqId} = $line;
        }
    }
}
close $bestReps;

my $currentGroup;
# Convert current group file into group formatting. Ex: ./OG7_0000000.sim to OG7_0000000.
$currentGroup = $input;
$currentGroup =~ s/\.fasta//g;
print "$currentGroup\n";
my $bestRepSequence = $seqToSeqId{$currentGroup};
open(my $temp, '>', 'temp.fasta') || die "Could not open file temp.fasta: $!";
print $temp ">$currentGroup\n$bestRepSequence";
close $temp;
system("mash dist -a -i -s 10000 -w 1 -k 3 ${currentGroup}.fasta temp.fasta > ${currentGroup}.mash");

