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
    use_ok( 'File::TVShow::Info' ) || print "Bail out!\n";
}


subtest "SXXEXX" => sub {
  my $obj = File::TVShow::Info->new("test.S01E01.avi");
  is($obj->is_tv_show(), 1, "This is a valid TV show");
  is($obj->show_name(), "test", "show name is test");
  is($obj->is_by_date(), 0, "This is not sorted by date");
  is($obj->is_tv_show(), 1, "This is a TV show.");
  can_ok($obj, 'is_multi_episode');
  is($obj->is_multi_episode(),0,"This is not a multi-episode file.");
  can_ok($obj, 'season');
  is($obj->season(),'01', "Season: 01");
  can_ok($obj, 'episode');
  is($obj->episode(), "01", "Episode 01");
  can_ok($obj, 'season_episode');
  is($obj->season_episode(), "S01E01", "season_episode returns SO1EO1");
  can_ok($obj, 'is_by_season');
  is($obj->is_by_season(), 1, "SXXEXX or SXXEXXEXX format");
  is($obj->ext(),"avi", "extension is avi");

};

subtest "SXXEXXEXX" => sub {
  my $obj = File::TVShow::Info->new("test.S01E01E02.avi");
  is($obj->is_tv_show(), 1, "This is a valid TV show");
  is($obj->show_name(), "test", "show name is test");
  is($obj->is_by_date(), 0, "This is not sorted by date");
  is($obj->is_tv_show(), 1, "This is a TV show.");
  can_ok($obj, 'season');
  is($obj->season(),'01', "Season: 01");
  can_ok($obj, 'is_multi_episode');
  is($obj->is_multi_episode(), 1, "This is a multi-episode file.");
  can_ok($obj, 'episode');
  is($obj->episode(), "01", "Episode 01");
  can_ok($obj, 'season_episode');
  is($obj->season_episode(), "S01E01E02", "season_episode returns SO1EO1E02");
  is($obj->ext(),"avi", "extension is avi");

};

subtest "SXXEXX with Episode Name" => sub {
  my $obj = File::TVShow::Info->new("test.S01E02.EpiName.avi");
  is($obj->is_tv_show(), 1, "This is a valid TV show");
  is($obj->show_name(), "test", "show name is test");
  is($obj->is_multi_episode(), 0,"This is not a multi-episode file.");
  is($obj->season_episode(), "S01E02", "season_episode returns SO1EO2");
  can_ok($obj, 'episode_name');
  is($obj->episode_name(), "EpiName", "Episode Name: EpiName");
};

subtest "SXXEXXEXX with Episode Name" => sub {
  my $obj = File::TVShow::Info->new("test.S01E02E03.EpiName.avi");
  is($obj->is_tv_show(), 1, "This is a valid TV show");
  is($obj->show_name(), "test", "show name is test");
  is($obj->is_multi_episode(), 1, "This is a multi-episode file.");
  is($obj->season_episode(), "S01E02E03", "season_episode returns SO1EO2E03");
  can_ok($obj, 'episode_name');
  is($obj->episode_name(), "EpiName", "Episode Name: EpiName");
};

done_testing();
