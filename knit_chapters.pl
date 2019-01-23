#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Getopt::Long;
use Pod::Usage;
use Carp;
use File::Find;
use File::Spec::Functions;
use File::stat;
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
my @rmd_files = files_to_knit();


my $base_dir = getcwd();

for my $file_r (@rmd_files) {
    use constant {
        DIR => 0,
        FILE => 1,
    };


    # Change to the directory the file is in.
    #chdir $file_r->[DIR];

    my $R = Statistics::R->new;

    my @R_commands = (
        qq{ library(knitr) },
        qq{ getwd() },
        qq{ knit2html('$file_r->[FILE]') }
    );

    say "Executing the following commands:";
    say $_ foreach @R_commands;

    $R->run( @R_commands );
    say $R->read;

    # Switch back to the base directory
    chdir $base_dir;
}


# This sub searches for .Rmd files from the current working directory down.
# If there is a corresponding .md file that was modifed after the .Rmd, the .Rmd
# is not added. Otherwise it is added to the list of files to be knitted.
sub files_to_knit {
    my %mtime_of_md_files;
    my @files_to_knit;

    find( sub { 
            my $f = $File::Find::name; 
            my @matches = $f =~ m{(.*)\.(R?md)$};
            return unless @matches == 2;
            my ($path_and_filename, $suffix) = @matches;

            $mtime_of_md_files{ $path_and_filename }{ $suffix }{mtime} = stat($_)->mtime();
            $mtime_of_md_files{ $path_and_filename }{ $suffix }{dir} = $File::Find::dir; 
        },
        '.'
    );


    for my $file_without_suffix (keys %mtime_of_md_files) {
        # Continute on if there isn't a .Rmd file
        next unless exists $mtime_of_md_files{$file_without_suffix}{Rmd};

        # If the '.md' mtime is after the '.Rmd' mtime, we skip;
        next if $mtime_of_md_files{$file_without_suffix}{md}{mtime} >= $mtime_of_md_files{$file_without_suffix}{Rmd}{mtime};

        # Push the directory and the filename into an ARRAYREF
        push @files_to_knit, [$mtime_of_md_files{$file_without_suffix}{Rmd}{dir}, "$file_without_suffix.Rmd"];
    }

    return @files_to_knit;

}



