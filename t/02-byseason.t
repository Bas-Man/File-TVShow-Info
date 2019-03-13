#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;

unless ( $ENV{DEV_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

BEGIN {
    use_ok( 'File::TVShow::Parse' ) || print "Bail out!\n";
}


subtest "Sorted by SXXEXX" => sub {
  my $obj = File::TVShow::Parse->new("test.S01E01.avi");
  print Data::Dumper::Dumper($obj);
  is($obj->is_tv_show(), 1, "This is a valid TV show");
  is($obj->is_by_date(), 0, "This is not sorted by date");
  is($obj->is_tv_show(), 1, "This is a TV show.");
  can_ok($obj, 'season');
  is($obj->season(),'01', "Season: 01");
  can_ok($obj, 'episode');
  is($obj->episode(), "01", "Episode 01");
  can_ok($obj, 'season_episode');
  is($obj->season_episode(), "S01E01", "season_episode returns SO1EO1");

};

done_testing();
