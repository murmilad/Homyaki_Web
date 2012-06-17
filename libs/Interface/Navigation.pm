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

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};
	my $class = ref($this) || $this;

	bless $self, $class;

	return $self;
}

sub add_navigation {
	my $this = shift;
	my %h = @_;

	my $form_table = $h{form_table};

	return $form_table;
}
