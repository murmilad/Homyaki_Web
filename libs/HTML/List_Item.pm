package Homyaki::HTML::List_Item;

use strict;

use Data::Dumper;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::Converter qw{get_html};

use base 'Homyaki::HTML';

use Homyaki::HTML::Constants;
use Homyaki::Task_Manager::DB::Constants;

sub add_list_data {
	my $self = shift;
	my %h    = @_;

	my $permissions = $h{permissions};
	my $body_tag    = $h{body_tag};
	my $params      = $h{params};
	my $errors      = $h{errors};
	my $index       = $h{'index'};
	my $item_id     = $h{item_id};
	my $list_fields = $h{list_fields};

	my $form_param;

	foreach my $list_field (@{$list_fields}){
		if (!$form_param){
			$form_param = $body_tag->add_form_element(
				name   => "$list_field->{name}_$item_id",
				type   => &INPUT_TYPE_LABEL,
				value  => $params->{"$list_field->{name}_$item_id"},
			);
		} else {
			$form_param->add_form_element(
				location => &LOCATION_RIGHT,
				name     => "$list_field->{name}_$item_id",
				value    => get_html($params->{"$list_field->{name}_$item_id"}),
				type     => &INPUT_TYPE_LABEL,
			);
		}
	}


	if ($index % 2 > 0) {
		$form_param->{parrent}->{parrent}->{&PARAM_CLASS} = 'list_1';
	} else {
		$form_param->{parrent}->{parrent}->{&PARAM_CLASS} = 'list_2';
	}

	if (ref($permissions) eq 'ARRAY' && grep {$_ eq 'writer'} @{$permissions}) {

	        my $button_column = $form_param->add_form_element(
	                location => &LOCATION_RIGHT,
	                type     => &INPUT_TYPE_DIV,
	        );

	        my $buttons = $button_column->add(
	                type         => &TAG_TABLE,
	                &PARAM_NAME  => "table_buttons_$item_id",
	                &PARAM_ID    => "table_buttons_$item_id",
	        );

		$buttons->add_form_element(
			name         => "list_edit_$item_id",
			value        => "Edit",
			type         => &INPUT_TYPE_SUBMIT,
			&PARAM_STYLE => 'width: 5em;',
		);

		$buttons->add_form_element(
			name     => "list_delete_$item_id",
			value    => "Delete",
			type     => &INPUT_TYPE_SUBMIT,
			&PARAM_STYLE => 'width: 5em;',
		);

	}


	return $form_param;
}

sub add_list_header {
	my $self = shift;
	my %h    = @_;

	my $permissions = $h{permissions};
	my $body_tag    = $h{body_tag};
	my $errors      = $h{errors};
	my $list_fields = $h{list_fields};

	my $form_param;

	foreach my $list_field (@{$list_fields}){
		if (!$form_param){
			$form_param = $body_tag->add_form_element(
				name   => "$list_field->{name}_header",
				type   => &INPUT_TYPE_LABEL,
				value  => $list_field->{header},
			);
		} else {
			$form_param->add_form_element(
				location => &LOCATION_RIGHT,
				name     => "$list_field->{name}_header",
				value    => $list_field->{header},
				type     => &INPUT_TYPE_LABEL,
			);
		}
	}

	return $form_param;
}

1;
