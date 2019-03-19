
use strict;
use warnings;

use Test::More tests => 2;

use Oberth::Block::VCS::Git;
use Path::Tiny;
use List::AllUtils qw(first);

my $gitdir = path('~/sw_projects/zmughal/bioperl-live/bioperl-live');

my $gr = Oberth::Block::VCS::Git->new( directory => $gitdir );
my $remotes = $gr->remotes;
my $origin = first { $_->name eq 'origin' } @$remotes;
my $upstream = first { $_->name eq 'upstream' } @$remotes;

is( $origin->fetch, 'git@github.com:zmughal/bioperl-live.git', "Got origin for bioperl" );
is( $upstream->fetch, 'https://github.com/bioperl/bioperl-live.git', "Got upstream for bioperl" );
