package Oberth::Block::VCS::Git::Remote;
# ABSTRACT: A Git remote

use Moo;

has name => ( is => 'ro', required => 1 );

has fetch => ( is => 'ro' );

has push => ( is => 'ro', default => sub { [] } );

1;
