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
  can_ok($obj2, "show_name");
  is($obj2->show_name(), "Series Name", "Show name is Series Name");
  can_ok($obj2, 'is_by_date');
  is($obj2->is_by_date(),1, "This is sorted by date.");
  can_ok($obj2, 'ext');
  is($obj2->ext(),"avi", "extension is avi");
  can_ok($obj2, 'year');
  is($obj2->year(), "2018", "year is 2018");
  can_ok($obj2, 'month');
  is($obj2->month(), "01", "month is 01");
  can_ok($obj2, "date");
  is($obj2->date(), "03", "date is 03");
  can_ok($obj2, "ymd");
  is($obj2->ymd(), "2018.01.03", "ymd is 2018.01.03");

};

done_testing();
