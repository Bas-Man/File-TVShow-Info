package File::TVShow::Parse;

use 5.006;
use strict;
use warnings;

use vars qw(@filePatterns);

=head1 NAME

File::TVShow::Parse

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module is intended to parse and identify information in the file name of a TV show. These details can then be accessed
by calling the relavent methods. It makes B<NO> attempt to read the contents of the file.

If the file name is parsed and can not be identified as a TV show then L</is_tv_show> will return 0.

    use File::TVShow::Parse;

    my $show = File::TVShow::Parse->new('file');

=cut

@filePatterns = (
        { # TV Show Support -   By Date no Season or Episode
                # Perl > v5.10
                re => '(?<name>.*?)[.\s](?<year>\d{4})[.\s](?<month>\d{1,2})[.\s](?<date>\d{1,2})(?:[.\s](?<epname>.*)|)$',

                # Perl < v5.10
                re_compat => '(.*?)[.\s](\d{4})[.\s](\d{1,2})[.\s](\d{1,2})(?:[.\s](.*)|)$',
                keys_compat => [qw(filename name year month date epname ext)],

                test_funcs => [1, 0], # TV Episode
                test_keys => [qw(filename name year month date epname ext)],
                test_files => [
                        ['Series Name.2018.01.03.Episode_name.avi', 'Series Name', '2018', '01', '03', 'Episode_name', 'avi'],
                        ['Series Name 2018 02 03 Episode_name.avi', 'Series Name', '2018', '02', '03', 'Episode_name', 'avi'],
                        ['Series.Name.2018.03.03.Episode_name.avi', 'Series.Name', '2018', '03', '03', 'Episode_name', 'avi'],
                        ['Series Name 2018 04 03.avi', 'Series Name', '2018', '04', '03', undef, 'avi'],
                        ['Series.Name.2018.05.03.avi', 'Series.Name', '2018', '05', '03', undef, 'avi'],
                ],
        },
        { # TV Show Support - SssEee or Season_ss_Episode_ss
                # Perl > v5.10
                re => '^(?:(?<name>.*?)[\/\s._-]+)?(?:s|se|season|series)[\s._-]?(?<season>\d{1,2})[x\/\s._-]*(?:e|ep|episode|[\/\s._-]+)[\s._-]?(?<episode>\d{1,2})(?:-?(?:(?:e|ep)[\s._]*)?(?<endep>\d{1,2}))?(?:[\s._]?(?:p|part)[\s._]?(?<part>\d+))?(?<subep>[a-z])?(?:[\/\s._-]*(?<epname>[^\/]+?))?$',

                # Perl < v5.10
                re_compat => '^(?:(.*?)[\/\s._-]+)?(?:s|se|season|series)[\s._-]?(\d{1,2})[x\/\s._-]*(?:e|ep|episode|[\/\s._-]+)[\s._-]?(\d{1,2})(?:-?(?:(?:e|ep)[\s._]*)?(\d{1,2}))?(?:[\s._]?(?:p|part)[\s._]?(\d+))?([a-z])?(?:[\/\s._-]*([^\/]+?))?$',
                keys_compat => [qw(name season episode endep part subep epname)],

                test_funcs => [1, 1], # TV Episode
                test_keys => [qw(filename name guess-name season episode endep part subep epname ext)],
                test_files => [
                        ['Series Name.S01E02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name S01E02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name S01E02/Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series/Name S01E02/Episode_name.avi', 'Name', 'Series Name', 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.S01E02a.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, 'a', 'Episode_name', 'avi'],
                        ['Series Name.S01E02p4.Episode_name.avi', 'Series Name', undef, 1, 2, undef, 4, undef, 'Episode_name', 'avi'],
                        ['Series Name.S01E02-03.Episode_name.avi', 'Series Name', undef, 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.S01E02-E03.Episode_name.avi', 'Series Name', undef, 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.S01E02E.03.Episode_name.avi', 'Series Name', undef, 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name S01E02E03/Episode_name.avi', 'Series Name', undef, 1, 2, 3, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.Season_01.Episode_02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.Se01.Ep02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.Season_01.Episode_02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name.Season_01.Episode_02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                        ['Series Name Season_01.02.Episode_name.avi', 'Series Name', undef, 1, 2, undef, undef, undef, 'Episode_name', 'avi'],
                ],
        },
        { # TV Show Support - sxee
                # Perl > v5.10
                re => '^(?:(?<name>.*?)[\/\s._-]*)?(?<openb>\[)?(?<season>\d{1,2})[x\/](?<episode>\d{1,2})(?:-(?:\k<season>x)?(?<endep>\d{1,2}))?(?(<openb>)\])(?:[\s._-]*(?<epname>[^\/]+?))?$',

                # Perl < v5.10
                re_compat => '^(?:(.*?)[\/\s._-]*)?\[?(\d{1,2})[x\/](\d{1,2})(?:-(?:\d{1,2}x)?(\d{1,2}))?\]?(?:[\s._-]*([^\/]+?))?$',
                keys_compat => [qw(name season episode endep epname)],

                test_funcs => [1, 1], # TV Episode
                test_keys => [qw(filename name season episode endep epname ext)],
                test_files => [
                        ['Series Name.1x02.Episode_name.avi', 'Series Name', 1, 2, undef, 'Episode_name', 'avi'],
                        ['Series Name 1x02.Episode_name.avi', 'Series Name', 1, 2, undef, 'Episode_name', 'avi'],
                        ['Series Name.[1x02].Episode_name.avi', 'Series Name', 1, 2, undef, 'Episode_name', 'avi'],
                        ['Series Name.1x02-03.Episode_name.avi', 'Series Name', 1, 2, 3, 'Episode_name', 'avi'],
                        ['Series Name.1x02-1x03.Episode_name.avi', 'Series Name', 1, 2, 3, 'Episode_name', 'avi'],
                ],
        },
);

=head1 Methods

=head2 new

Create a Parse object to extract meta information from the file name.

    my $show = File::TVShow::Parse->new('file');

=cut

=head3 Data held in the object.

=over 4

=item * show_name:
Name of the show.

=item * season:
Show season

=item * episode:
Show episode

=item * date: (Where eposides are identified by dates)
Show date e.g 2019.03.03

=item * resolution:
Show resolution 480p/720p and so on. This will be undefined if not found.

=item * ext:
File extension

=back
=cut

sub new {
}

=head2 show_name

Return the show name found in the file name.

=cut

sub show_name {
}

=head2 season

Return the season found in the file name. Return undef if no season is found.

=cut

=head2 episode

Return the episode found in the file name. Return undef if no episode found.

=cut

=head2 date

Return the date found in the file name. Return undef if no date found.

=cut

=head2 resolution

Return resolution found in the file name. Return undef if no resolution found.

=cut

=head2 ext

Return file extension.

=cut

=head2 is_tv_show

Return 1 if identified as a TV Show. Default is 0

=cut

=head2 is_by_date

Return 1 if by date. Default is 0

=cut

=head2 is_by_season

Return 1 if by season. Default is 0

=cut

=head1 AUTHOR

Adam Spann, C<< <baspann at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-file-tvshow-parse at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-TVShow-Parse>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc File::TVShow::Parse


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=File-TVShow-Parse>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/File-TVShow-Parse>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/File-TVShow-Parse>

=item * Search CPAN

L<https://metacpan.org/release/File-TVShow-Parse>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2019 Adam Spann.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of File::TVShow::Parse
