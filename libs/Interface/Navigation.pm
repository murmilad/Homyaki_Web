package Homyaki::Interface::Navigation;
#
#===============================================================================
#
#         FILE: Navigation.pm
#
#  DESCRIPTION: Homyaki navigation menue abstract module
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Alexey Kosarev (murmilad), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 17.06.2012 15:36:30
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Homyaki::DBI::Interface::Navigation_Item;

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};
	my $class = ref($this) || $this;

	bless $self, $class;
	$self->{navigation_list} = {};

	return $self;
}

sub add_navigation {
	my $this = shift;
	my %h = @_;

	my $form_table = $h{form_table};

	return $form_table;
}

sub get_navigation_list {
	my $this = shift;
	my %h = @_;

	my $parrent = $h{parrent};

	unless ($this->{navigation_list}->{$parrent}) {
		$this->{navigation_list}->{$parrent} =	Homyaki::DBI::Interface::Navigation_Item->search(
			parrent_name => $parrent
		);
	}
}

1;
