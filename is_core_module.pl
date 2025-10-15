#!/usr/bin/env perl

use strict;
use warnings;
use warnings FATAL => "all";
use 5.34.0;
# use diagnostics; # When encountering an error, it will try to explain it.
# use Data::Dumper qw(Dumper);

use Module::CoreList;
die 'Argument required!' if ! defined $ARGV[0];
print join "\n", Module::CoreList->find_modules(qr/$ARGV[0]$/i);
