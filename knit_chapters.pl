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
use Cwd qw(getcwd); 

=head1 NAME

<name> - <description>

=head1 SYNOPSIS

./knit_chapters.pl

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


GetOptions(
    "help" => sub { pod2usage(1) }
) or pod2usage(2);


# Find the .Rmd files
my @rmd_files;
find( sub { push @rmd_files, [$File::Find::dir, $_] if m{\.Rmd$} }, '.' );

use constant {
    DIR => 0,
    FILE => 1,
};

my $base_dir = getcwd();

for my $file_r (@rmd_files) {
    # Change to the directory
    chdir $file_r->[DIR];

    my $R = Statistics::R->new;

    my @R_commands = (
        qq{ library(knitr) },
        qq{ getwd() },
        qq{ knit('$file_r->[FILE]') }
    );

    say "Executing the following commands:";
    say $_ foreach @R_commands;

    $R->run( @R_commands );
    say $R->read;

    # Switch back to the base directory
    chdir $base_dir;
}






