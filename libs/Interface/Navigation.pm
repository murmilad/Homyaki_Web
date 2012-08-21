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

use Data::Dumper;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;
use Homyaki::XML::Interface::Navigation;

use Homyaki::Interface_Factory;
use Homyaki::Interface::Interface_Factory;

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};
	my $class = ref($this) || $this;

	bless $self, $class;

	$self->{navigation_menue} = {};
	$self->{current_path} = [];

	return $self;
}

sub add_navigation {
	my $this = shift;
	my %h = @_;

	my $form_table = $h{form_table};
	my $params     = $h{params};
	my $user       = $h{user};


	$form_table->{&PARAM_NAME} = "table_navigation_container";
	$form_table->{&PARAM_ID}   = "table_navigation_container";

	return $form_table;
}

sub get_navigation_list {
	my $this = shift;
	my %h = @_;
	my $user    = $h{user};
	my $params  = $h{params};
	my $parrent = $h{parrent} || '';

	unless (scalar(keys %{$this->{navigation_menue}})) {
		my $navigation_list = Homyaki::XML::Interface::Navigation->get_navigation();
		grep {$_ eq 'writer'} @{$user->{permissions}};
		foreach my $menue (map {$_->{menue}} @{$navigation_list}) {
			$this->set_menue_items(
				menue => $menue,
				user  => $user
			);
		}
	}

	return $this->{navigation_menue};
}

sub set_menue_items{
	my $this = shift;
	my %h = @_;
	my $menue = $h{menue};
	my $user  = $h{user};
	if (ref($menue) eq 'HASH') {
		foreach my $menue_item (keys %{$menue}){

			# Call get_navigation on form handler
			if ($menue->{$menue_item}->{interface} && $menue->{$menue_item}->{form} && $menue->{$menue_item}->{dynamic_navigation}) {
				my $interface_factory = Homyaki::Interface_Factory->create_interface_factory(
					handler => $menue->{$menue_item}->{interface}
				);
				if ($interface_factory){
					my $form = $interface_factory->create_interface(
						form => $menue->{$menue_item}->{form}
					);
					if ($form) {
						my $form_menue = $form->get_navigation(
							user             => $user,
							menue_permission => $menue->{$menue_item}->{permission},
						);
						if (scalar(keys %{$form_menue}) > 0){
							Homyaki::Logger::print_log('Html_Photo_Albums: res:' . Dumper($form_menue));
							$menue->{$menue_item}->{menue} = $form_menue;
						}
					}
				}
			}

			push(@{$this->{current_path}}, $menue_item);
			if ($menue->{$menue_item}->{menue}) {
				push(@{$this->{current_path}}, 'menue');
				$this->set_menue_items(
					menue => $menue->{$menue_item}->{menue},
					user  => $user
				);
				pop(@{$this->{current_path}});
			} else {
				my $user_has_permission = 0;
				foreach my $menue_item_permission (@{$menue->{$menue_item}->{permission}}) {
					if (grep {$_ eq $menue_item_permission} @{$user->{permissions}}) {
						$user_has_permission = 1;
					}
				}
				if ($user_has_permission){
					eval ('$this->{navigation_menue}->{"' . join ('"}->{"', @{$this->{current_path}}) . '"} = $menue->{$menue_item};');
				}
			}
			pop(@{$this->{current_path}});
		}
	}
}


1;
