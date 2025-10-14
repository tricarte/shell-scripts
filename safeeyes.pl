#!/usr/bin/env -S perl -l

use strict;
use warnings FATAL => "all";

# use 5.34.0;
use POSIX qw(strftime);

# use diagnostics; # When encountering an error, it will try to explain it.
# use Data::Dumper qw(Dumper);

if ( defined $ARGV[0] && $ARGV[0] eq 'br' ) {
    `bash --norc -c 'safeeyes --take-break'`;
    exit;
}

my $se = `bash --norc -c 'safeeyes --status'`;
!$? or die 'SafeEyes is not reachable.';
die 'SafeEyes is disabled or not running.' if $se !~ /^Next/;
chomp $se;
$se = substr $se, -2;    # Next break at HH:MM (Just the MM part)

my $interactive = -t *STDOUT;
my ( $notify_bin, $ON, $OFF );
if ($interactive) {
    $ON  = `bash --norc -c 'tput smso'`;
    $OFF = `bash --norc -c 'tput rmso'`;
}
else {
    $notify_bin = `bash --norc -c 'which notify-send'`;
    !$? or die 'notify-send does not exist!';
    chomp $notify_bin;
}

my @time = localtime time;
my ( undef, $min ) = @time;
my $currdate = strftime( "%Y-%m-%d %H:%M", @time );
my $left     = ( $se < $min ) ? $se + ( 60 - $min ) : $se - $min;
my $message =
  $left >= 2
  ? "$left minutes left!"
  : "About to break!";

my $uptime = `bash --norc -c 'uptime -p'`;
chomp $uptime;

if ($interactive) {
    { local $, = "\n"; print "${ON}$message${OFF}", $uptime, $currdate; }
}
else {
    system 'notify-send', '-a', 'SafeEyes', "$message\n\n$uptime\t$currdate";
}
