
use strict;
use warnings;

use Test::More tests => 2;

use Orbital::Payload::VCS::Git;
use Path::Tiny;
use List::Util::MaybeXS qw(first);

my $gitdir = path('~/sw_projects/zmughal/bioperl-live/bioperl-live');

my $gr = Orbital::Payload::VCS::Git->new( directory => $gitdir );
my $remotes = $gr->remotes;
my $origin = first { $_->name eq 'origin' } @$remotes;
my $upstream = first { $_->name eq 'upstream' } @$remotes;

is( $origin->fetch, 'git@github.com:zmughal/bioperl-live.git', "Got origin for bioperl" );
is( $upstream->fetch, 'https://github.com/bioperl/bioperl-live.git', "Got upstream for bioperl" );

