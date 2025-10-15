#!/usr/bin/env perl

use strict;
use warnings;
use File::MimeInfo::Magic;
use File::MimeInfo::Applications;

my $file = $ARGV[0];

die "This script requires a file argument.\n" unless $file;

my $mimetype = mimetype($file)
|| die "Could not find mimetype for $file.\n";

# @other is an array of File::DesktopEntry objects
my ($default, @other) = mime_applications_all($mimetype);

# A trick to remove duplicate entries from @other
my %seen;
my @entries = grep { !$seen{ $_->Name }++ } @other;

# Create the input to fzf in the form:
# Number:DesktopEnteryName such as
# 0:LibreOffice Writer
my $output = "";
for (0..$#entries) {
    $output .= sprintf "%d:%s\n", $_, $entries[$_]->Name;
}

# Ask the user
my ( $chosen ) = split /:/, `printf "${output}" | fzf --with-nth=2.. --delimiter ':'`, 2;
# Finally run the selected desktop entry.
# We can already use ->run and ->exec, but interestingly, especially with flatpaks,
# sometimes the chosen entry does not get executed.
# $entries[$chosen]->system($file) if $chosen;
# $entries[$chosen]->run($file) if $chosen;
if (defined $chosen) {
    # $entries[$chosen]->exec($file); # Replaces the current process but no background support.
    # $entries[$chosen]->run($file);  # Fork and run as a background process but output is not good.
    # $entries[$chosen]->system($file); # No background support, but better output.

    my $exec = $entries[$chosen]->parse_Exec($file);
    # exec $exec;
    # system $exec;
    # fork $exec; # NOOOO
    `kitty @ --to unix:/tmp/mykitty launch --type window bash --noprofile --norc -c "${exec}"`
    

    # Because 'exec' will never return!
    # exit;
}

