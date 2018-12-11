package Oberth::Block::VCS::Git;
# ABSTRACT: Interface to Git VCS

use strict;
use warnings;

use Moo;
use URI;
use URI::git;
use Git::Wrapper;
use Oberth::Block::VCS::Git::Remote;

has directory => ( is => 'ro', required => 1 );

has _git_wrapper => ( is => 'lazy' ); # _build__git_wrapper

# TODO note that there can be multiple push remotes
# (and only a single fetch remote? check this)
has remotes => ( is => 'lazy', clearer => 1 ); # _build_remotes

sub _build__git_wrapper {
	my ($self) = @_;
	Git::Wrapper->new( { dir => $self->directory } );
}

sub _build_remotes {
	my ($self) = @_;

	my %remote_data;

	my @remotes = $self->_git_wrapper->remote( { verbose => 1 });
	for my $remote (@remotes) {
		if( $remote =~ m,^(\S+) \s+ (\S+) \s+ \((fetch|push)\)$,x ) {
			my $remote_name = $1;
			my $remote_uri = $2;
			my $remote_type = $3;

			my $remote_uri_as_uri = URI->new($remote_uri);
			my $target_ref = \( $remote_data{ $remote_name }{$remote_type} );

			# TODO Test this.
			# This allows for multiple (push) refs
			if( $remote_type eq 'push' ) {
				$$target_ref = [];
			}

			if( defined $$target_ref ) {
				unless( ref $$target_ref ) {
					$$target_ref = [ $$target_ref ];
				}
				push @$$target_ref, $remote_uri_as_uri;
			} else {
				$$target_ref = $remote_uri_as_uri;
			}
		} else {
			die "error parsing remotes for @{[ $self->directory ]}";
		}
	}

	my @remote_obj;
	while(my ($remote_name, $remote_type) = each %remote_data ) {
		push @remote_obj,
			Oberth::Block::VCS::Git::Remote->new(
				name => $remote_name,
				( fetch =>  $remote_type->{fetch} )x!!( exists $remote_type->{fetch} ),
				( push =>  $remote_type->{push} )x!!( exists $remote_type->{push} ),
			);
	};

	\@remote_obj;
}

1;
