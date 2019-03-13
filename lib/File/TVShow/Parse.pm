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
                re => '(?<show_name>.*?)[.\s_-](?<year>\d{4})[.\s_-](?<month>\d{1,2})[.\s_-](?<date>\d{1,2})(?:[.\s_-](?<epname>.*)|)[.](?<ext>[a-z]{3})$',

                # Perl < v5.10
                re_compat => '(.*?)[.\s_-](\d{4})[.\s_-](\d{1,2})[.\s_-](\d{1,2})(?:[.\s_-](.*)|)[.](?<ext>[a-z]{3})$',
                keys_compat => [qw(filename show_name year month date epname ext)],

                test_funcs => [1, 0], # TV Episode
                test_keys => [qw(filename show_name year month date epname ext)],
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
                keys_compat => [qw(show_name season episode endep part subep epname)],

                test_funcs => [1, 1], # TV Episode
                test_keys => [qw(filename show_name guess-name season episode endep part subep epname ext)],
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
    my $class = shift;
    my $self =  {};
    bless $self, $class;
    # Read default values
    for my $key (qw(file name season episode part options)) {
        last unless defined $_[0];
        if (ref $_[0]) {
                # Use a hashref for values
                while (my ($key, $value) = each %{$_[0]}) {
                        $self->{$key} = $value;
                }
        } else {
                $self->{$key} = shift;
        }
    }

    $self->{filename} = $self->{file};

    # Run filename through list of patterns
    for my $pat (@filePatterns) {
            if ($] >= 5.010000) {
                  if ($self->{file} =~ /$pat->{re}/i) {
                  # We have a match we will exit after this loop
                      $self->{regex} = $pat->{re};
                        while (my ($key, $data) = each %-) {
                            $self->{$key} = $data->[0] if defined $data->[0] && !defined $self->{$key};
                          }
                          # We have a match so we are skipping all other @filePatterns
                          last;
                  }
            } else { # No named groups in regexes
                    my @matches;
                    if (@matches = ($self->{file} =~ /$pat->{re_compat}/i)) {
                            #print "MACTHES: ".join(',', @matches)."\n";
                            $self->{regex} = $pat->{re_compat};
                            my $count = 0;
                            foreach my $key (@{$pat->{keys_compat}}) {
                                    $self->{$key} = $matches[$count] unless defined $self->{$key};
                                    $count++;
                            }
                            last;
                    }
            }
    }

    if (defined $self->{season}) {
           $self->{seasonepisode} = sprintf("S%02dE%02d", $self->{season}, $self->{episode});
    } elsif (defined $self->{dvd}) {
           $self->{seasonepisode} = sprintf("D%02dE%02.1f", $self->{dvd}, $self->{episode});
    }

    return $self;
}

=head2 show_name

Return the show name found in the file name.

=cut

sub show_name {

    my $self = shift;

    return $self->{show_name} if defined $self->{show_name};
    return '';

}

=head2 season

Return the season found in the file name. Return '' if no season is found.

=cut

sub season {

    my $self = shift;
    return $self->{season} if defined $self->{season};
    return '';
}
=head2 episode

Return the episode found in the file name. Return '' if no episode found.

=cut

sub episode {

    my $self = shift;

    return $self->{episode} if defined $self->{episode};
    return '';

}

=head2 season_episode

Return SXXEXX or SXXEXXEXX for single or multi episode files. Return '' if not created

=cut

sub season_episode {

    my $self = shift;

    return "S" . $self->{season} . "E" .
      $self->{episode} if defined $self->{season};
    return '';

}

=head2 year

Return the year found in the file name. Return '' is no year found.

=cut

sub year {

    my $self = shift;

    return $self->{year} if defined $self->{year};
    return '';

}

=head2 month

Return the month found in the file name. Return '' if no month found.

=cut

sub month {

    my $self = shift;

    return $self->{month} if defined $self->{month};
    return '';

}

=head2 date

Return the date found in the file name. Return '' if no date found.

=cut

sub date {

    my $self = shift;

    return $self->{date} if defined $self->{date};
    return '';

}

=head2 ymd

Return the complete date string as 'YYYY.MM.DD' Rutun '' if no ymd

=cut

sub ymd {

    my $self = shift;

    return $self->{year} . "." . $self->{month} . "." . $self->{date}
      if defined $self->{year} && defined $self->{month};
    return '';
}

=head2 resolution

Return resolution found in the file name. Return undef if no resolution found.

=cut

=head2 ext

Return file extension.

=cut

sub ext {

    my $self = shift;

    return $self->{ext} if defined $self->{ext};
    return undef;

}

=head2 is_tv_show

Return 1 if identified as a TV Show. Default is 0

=cut

sub is_tv_show {

    my ($self) = @_;

    if (defined $self->{season} && defined $self->{episode}) {
        return 1;
    } elsif (defined $self->{year} && $self->{month} && $self->{date}) {
        return 1;
    }
    # This is not a TVshow
    return 0;
}

=head2 is_by_date

Return 1 if by date. Default is 0

=cut

sub is_by_date {

    my $self = shift;

    if (defined $self->{year} && $self->{month} && $self->{date}) {
        return 1;
    }
    return 0;
}
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
