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


subtest "Not a valid TV Show file." => sub {
  my $obj = File::TVShow::Parse->new("test.avi");
  can_ok($obj, 'is_tv_show');
  is($obj->is_tv_show(),0, "This is not a TV Show file.");
};

subtest "ByDate" => sub {
  my $obj2 = File::TVShow::Parse->new("Series Name.2018.01.03.Episode_name.avi");
  is($obj2->is_tv_show(),1, "This is a TV Show.");
  can_ok($obj2, 'is_by_date');
  is($obj2->is_by_date(),1, "This is sorted by date.");
  can_ok($obj2, 'ext');
  is($obj2->ext(),"avi", "extension is avi");
};

subtest "This file is not sorted by date. Sorted by SXXEXX" => sub {
  my $obj3 = File::TVShow::Parse->new("test.S01E01.avi");
  is($obj3->is_by_date(), 0, "This is not sorted by date");
  is($obj3->is_tv_show(), 1, "This is a TV show.");
  can_ok($obj3, 'season');
  is($obj3->season(),'01', "Season: 01");
};

done_testing();
