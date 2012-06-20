package Homyaki::Interface::Navigation::Simple;
#
#===============================================================================
#
#         FILE: Simple.pm
#
#  DESCRIPTION: Simple navigation plug-in
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: ALexey Kosarev (murmilad), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 17.06.2012 15:42:49
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Data::Dumper;
 
use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;

use Homyaki::Logger;
use base 'Homyaki::Interface::Navigation';

sub add_navigation {
	my $self = shift;
	my %h = @_;

	my $params     = $h{params};
	my $user       = $h{user};
	my $form_table = $h{form_table};

	my $navigation_list = $self->get_navigation_list(
		user    => $user,
		parrent => $params->{navigation_parrent},
	);

	Homyaki::Logger::print_log('Homyaki::Interface::Navigation::Simple navigation_list = ' . Dumper($navigation_list));
	Homyaki::Logger::print_log('Homyaki::Interface::Navigation::Simple user = ' . Dumper($user));
	Homyaki::Logger::print_log('Homyaki::Interface::Navigation::Simple navigation_menues count = ' . scalar(@{$navigation_list}));

	return $form_table
		if (scalar(@{$navigation_list}) == 0);

	$form_table = $self->SUPER::add_navigation(
		form_table => $form_table,
	);

	my $navigation_container_row = $form_table->add(
		type        => &TAG_ROW,
		&PARAM_NAME => 'navigation_container',
		&PARAM_ID   => 'navigation_container',
	);

	my $navigation_col = $form_table->add(
		type         => &TAG_COLUMN,
		&PARAM_NAME  => 'container_menue',
		&PARAM_ID    => 'container_menue',
		&PARAM_SIZE	 => '200',
		&PARAM_STYLE => 'vertical-align:top',
	);

	my $navigation_list_tag = $navigation_col->add(
		type => &TAG_LIST,
	);

	foreach my $menue (map {$_->{menue}} @{$navigation_list}) {
		$self->add_navigation_items(
			menue    => $menue,
			list_tag => $navigation_list_tag,
		);
	}


	my $body_col = $form_table->add(
		type        => &TAG_COLUMN,
		&PARAM_NAME => 'container_body',
		&PARAM_ID   => 'container_body',
	);

	my $main_form_table  = $body_col->add(
		type         => &TAG_TABLE,
		&PARAM_NAME  => "table_main",
		&PARAM_ID    => "table_main",
	);

	return $main_form_table;
}

sub add_navigation_items {
	my $this = shift;
	my %h = @_;
	my $menue    = $h{menue};
	my $list_tag = $h{list_tag};

	if (ref($menue) eq 'HASH') {
		foreach my $menue_item (keys %{$menue}){
			if ($menue->{$menue_item}->{menue}) {
				my $sub_menue_item = $list_tag->add(
					type => &TAG_LIST_ITEM,
					body_before => $menue_item	
				);
				my $sub_menue_list = $sub_menue_item->add(
					type => &TAG_LIST,
				);
				$this->add_navigation_items(
					menue    => $menue->{$menue_item}->{menue},
					list_tag => $sub_menue_list
				);
			} else {
				my $navigation_item_tag = $list_tag->add(
					type => &TAG_LIST_ITEM,
				);
				$navigation_item_tag->add(
					type         => &TAG_A,
					&PARAM_CLASS => 'param_normal',
					&PARAM_LINK  => $menue->{$menue_item}->{uri} 
						|| ('/engine/?interface=' . $menue->{$menue_item}->{interface} . '&form=' . $menue->{$menue_item}->{form}),
					body         => $menue_item,
				);
			}
		}
	}
}

1;
