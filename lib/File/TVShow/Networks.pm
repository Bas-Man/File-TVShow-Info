package File::TVShow::Networks;

use 5.10.0;
use strict;
use warnings;

require Exporter;
our @ISA = qw ( Exporter );
our @EXPORT = qw ( @networks );

=head1 NAME

File::TVShow::Networks - Array of Networks.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

our @networks = qw ( ABC AMZN BBC CBS CC CW DCU DSNY FBWatch FREE FOX HULU iP LIFE MTV NBC NICK FC RED TF1 STZ );

1;
