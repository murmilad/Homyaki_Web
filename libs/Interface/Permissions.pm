package Homyaki::Interface::Permissions;

use strict;
use Homyaki::User;

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};
	my $class = ref($this) || $this;

	bless $self, $class;

	return $self;
}

sub get_user{
	my $self = shift;
	my %h = @_;

	my $user_id = $h{user_id};

	my $user = Homyaki::User->retrieve($user_id);

	unless ($user) {
		$user->{permissions} = [];
		push(@{$user->{permissions}}, 'guest');
	}

	return $user;
}
1;
