#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'File::TVShow::Parse' ) || print "Bail out!\n";
}

diag( "Testing File::TVShow::Parse $File::TVShow::Parse::VERSION, Perl $], $^X" );
