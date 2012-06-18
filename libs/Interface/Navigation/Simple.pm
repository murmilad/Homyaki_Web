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
	my $form_table = $h{form_table};

	my $navigation_list = $self->get_navigation_list(
		parrent => $params->{navigation_parrent},
	);

	Homyaki::Logger::print_log('Homyaki::Interface::Navigation::Simple params = ' . Dumper(\%h));
	Homyaki::Logger::print_log('Homyaki::Interface::Navigation::Simple navigation_list->count = ' . $navigation_list->count());

	return $form_table
		if ($navigation_list->count() == 0);

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

#	$navigation_list->first();
	while (my $menue_item = $navigation_list->next()){
		my $navigation_item_tag = $navigation_list_tag->add(
			type => &TAG_LIST_ITEM,
		);
		$navigation_item_tag->add(
			type        => &TAG_A,
			&PARAM_LINK => $menue_item->{uri},
			body        => $menue_item->{header},
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

1;
