#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Getopt::Long;
use Pod::Usage;
use Carp;
use File::Find;
use File::Spec::Functions;
use Statistics::R;

=head1 NAME

<name> - <description>

=head1 SYNOPSIS

./<name> [options] [file ...]

 Options:
  -o|--option

=head1 OPTIONS

=over 4

=item B<-o|--option>

An option.

=back

=head1 DESCRIPTION

B<This program> will do something

=cut

my %args;

my $R = Statistics::R->new;

GetOptions(
    "help" => sub { pod2usage(1) }
) or pod2usage(2);

my %paths = (
    "c2" => '../Chapter_2/',
    "c3" => '../Chapter_3/',
);

# Convert to canonical paths
map { $paths{$_} = canonpath($paths{$_}) } keys %paths;


my @rmd_files;
find( sub { push @rmd_files, $_ if m{\.Rmd$} }, '.' );

for my $file (@rmd_files) {
    my ($chapter, $md_file) = split('_', $file);

    # Replace the .Rmd with md
    $md_file =~ s{\.rmd$}{.md}i;

    croak "No chapter mapping for '$chapter' (file: $file)" unless $paths{$chapter};

    my @R_commands = (
        qq{ library(knitr) },
        qq{ knit(input = '$file', output = '$paths{$chapter}/$md_file') }
    );


    say "Executing the following commands:";
    say $_ foreach @R_commands;

    $R->run( @R_commands );
}






