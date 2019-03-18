#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

unless ( $ENV{DEV_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

BEGIN {
    use_ok( 'File::TVShow::Info' ) || print "Bail out!\n";
}

use vars qw(@filePatterns @test_data);
use Term::ANSIColor qw(:constants);
use Data::Dumper;

$Term::ANSIColor::AUTORESET = 1;

@test_data = (
  {
  test_bool_results => [ 1, 0, 0], # is_tv_show is_tv_subtitle is_multi_episode
  test_keys => [qw(filename show_name season episode epname ext)],
  season => 1,
  name => 'Shows by Season',
  test_files => [
    ['Series Name.S01E01.Episode_name.avi', 'Series Name', "01", "01", 'Episode_name', 'avi'],
    ['Series Name.S01E02.Episode_name.avi', 'Series Name', "01", "02", 'Episode_name', 'avi'],
    ['Series Name S01E03.Episode_name.avi', 'Series Name', "01", "03", 'Episode_name', 'avi'],
    ['Series Name S01E04.Episode_name.avi', 'Series Name', "01", "04", 'Episode_name', 'avi'],
    ['Series Name.S01E05.Episode_name.avi', 'Series Name', "01", "05", 'Episode_name', 'avi'],
    ['Series Name.S01E06.avi', 'Series Name', "01", "06", '', 'avi'],
    ],
  },
  { # TV Show Support -   By Date no Season or Episode

          test_bool_results => [1, 0, 0], # is_tv_show is_tv_subtitle is_multi_episode
          test_keys => [qw(filename show_name year month date epname ext)],
          name => 'Shows by Date',
          test_files => [
                  ['Series Name.2018.01.03.Episode_name.avi', 'Series Name', '2018', '01', '03', 'Episode_name', 'avi'],
                  ['Series Name 2018 02 03 Episode_name.avi', 'Series Name', '2018', '02', '03', 'Episode_name', 'avi'],
                  ['Series.Name.2018.03.03.Episode_name.avi', 'Series.Name', '2018', '03', '03', 'Episode_name', 'avi'],
                  ['Series Name 2018 04 03.avi', 'Series Name', '2018', '04', '03', '', 'avi'],
                  ['Series.Name.2018.05.03.avi', 'Series.Name', '2018', '05', '03', '', 'avi'],
          ],
  },
);

sub testVideoFilename {
        print "Running Tests:\n";
        # Boolean Functions
        my @bool_funcs = qw(is_tv_show is_tv_subtitle is_multi_episode);
        my @get_funcs;
                for my $test_case (@test_data) {
                  if (defined $test_case->{season}) {
                     @get_funcs = qw(show_name season episode);
                  } else {
                     @get_funcs = qw(show_name year month date);
                  }

                  print "Testing $test_case->{name}\n";
                  for my $test (@{$test_case->{test_files}}) {
                        my $file = File::TVShow::Info->new($test->[0]);
                        # Make the correct rule fired
                        if (!defined $file->{regex}) {
                                print RED "FAILED: $file->{file} (No Match found!)\n";
                                print Dumper($file); exit;
                        }
                        # Make sure all the attributes were correctly parsed
                        my $keys = $test_case->{test_keys};
                        # Get the number of attr to be checked in the text_case
                        # Off by one error as array goes from 0 to max - 1
                        for my $i (0 .. (scalar @{$keys} - 1)) {
                                my $attr = $file->{$keys->[$i]};
                                my $value = $test->[$i];
                                # Skip test if the key does not exit in Info obj
                                next if (!defined $attr);
                                if ($attr ne $value) {
                                      print RED "'$attr' ne '$value'\nFAILED: $file->{file}\n";
                                      print Dumper($file); exit;
                                }
                        }
                        # Make sure all the is_XXXX() functions work properly
                        for my $i (0..$#bool_funcs) {
                                unless (eval "\$file->$bool_funcs[$i]()" == $test_case->{test_bool_results}->[$i]) {
                                        print RED "\$file->$bool_funcs[$i]() != $test_case->{test_bool_results}->[$i]\nFAILED: $file->{file}\n";
                                        print Dumper($file); exit;
                                }
                        }
                        for my $j (1..$#get_funcs) {
                          unless ( eval "\$file->$get_funcs[$j]" eq $test->[$j+1]) {
                              print RED "$\file->$get_funcs[$j]() != $test->[$j]\nFailed $file->{file}\n";

                          };

                        }
                        print GREEN "PASSED: $file->{file}\n";
                }
                print "$test_case->{name} Complete\n\n";
        }
        print "Testing Complete.\n";
}

testVideoFilename();

done_testing();
