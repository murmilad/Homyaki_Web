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

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;
use Homyaki::XML::Interface::Navigation;

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
	my $params     = $h{params};
	my $user     = $h{user};



	$form_table->{&PARAM_NAME} = "table_navigation_container";
	$form_table->{&PARAM_ID}   = "table_navigation_container";

	return $form_table;
}

sub get_navigation_list {
	my $this = shift;
	my %h = @_;
	my $user    = $h{user};
	my $parrent = $h{parrent} || '';

	unless ($this->{navigation_list}) {
		my $navigation_list = Homyaki::XML::Interface::Navigation->get_navigation();
		grep {$_ eq 'writer'} @{$user->{permissions}};
		foreach my $menue (map {$_->{menue}} @{$navigation_list}) {
			$this->remove_unpermitted_items(
				menue => $menue,
				user  => $user
			);
		}
		$this->{navigation_list} = $navigation_list;
	}

	return $this->{navigation_list};
}

sub remove_unpermitted_items{
	my $this = shift;
	my %h = @_;
	my $user  = $h{user};
	my $menue = $h{menue};

	if (ref($menue) eq 'HASH') {
		foreach my $menue_item (keys %{$menue}){
			if ($menue->{$menue_item}->{menue}) {
				$this->remove_unpermitted_items(
					menue => $menue->{$menue_item}->{menue},
					user  => $user
				);
			} else {
				my $user_has_permission = 0;
				foreach my $menue_item_permission (@{$menue->{$menue_item}->{permission}}) {
					if (grep {$_ eq $menue_item_permission} @{$user->{permissions}}) {
						$user_has_permission = 1;
					}
				}
				delete($menue->{$menue_item})
					unless ($user_has_permission);
			}
		}
	}
}

1;
