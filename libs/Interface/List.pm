package Homyaki::Interface::List;

use strict;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;

use Homyaki::Logger;
use Data::Dumper;

use Homyaki::Interface::Form;
use Homyaki::HTML::List_Item;

use base 'Homyaki::Interface::Form';

use constant PARAMS_MAP   => {};
use constant LIST_FIELDS  => [];
use constant DBI_CLASS    => '';

sub get_form {
	my $this = shift;
	my %h = @_;

	my $params   = $h{params};
	my $errors   = $h{errors};
	my $user     = $h{user};
	my $body_tag = $h{body_tag};

	my $root = $this->SUPER::get_form(
		params   => $params,
		errors   => $errors,
		form_id  => 'list_form',
		body_tag => $body_tag,
		user     => $user,
	);

	my $root_tag = $root->{root};
	my $body_tag = $root->{body};

	$body_tag->{&PARAM_WIDTH} = '800';
	$body_tag->{&PARAM_FRAME} = 'hsides';

	my $permissions = $user->{permissions};


	my $header_param;
	my $form_param;
	foreach my $field (@{$this->LIST_FIELDS}) {
		if (!$header_param){
			$header_param = $body_tag->add_form_element(
				name     => "label_$field->{name}",
				type     => &INPUT_TYPE_LABEL,
				value    => "Find $field->{header}",
			);
		} else {
			$header_param->add_form_element(
				name     => "label_$field->{name}",
				type     => &INPUT_TYPE_LABEL,
				value    => "Find $field->{header}",
				location => &LOCATION_RIGHT,
			);
		}

		if (!$form_param){
			$form_param = $body_tag->add_form_element(
				name   => "$field->{name}_find",
				type   => &INPUT_TYPE_TEXT,
				value  => $params->{"$field->{name}_find"},
				error  => $errors->{"$field->{name}_find"},
			);
		} else {
			$form_param->add_form_element(
				name   => "$field->{name}_find",
				type   => &INPUT_TYPE_TEXT,
				value  => $params->{"$field->{name}_find"},
				error  => $errors->{"$field->{name}_find"},
				location => &LOCATION_RIGHT,
			);
		}
	}

	$form_param->add_form_element(
		type     => &INPUT_TYPE_SUBMIT,
		value    => 'Find',
		name     => 'find_submit_button',
		location => &LOCATION_RIGHT,
	);

	$form_param = Homyaki::HTML::List_Item->add_list_header(
		errors      => $errors,
		body_tag    => $body_tag,
		permissions => $permissions,
		list_fields => $this->LIST_FIELDS,
	);

	my $first_field_name = $this->LIST_FIELDS->[0]->{name};
	my $index = 0;
	foreach my $task_id_param (sort {
		if ($a =~ /${first_field_name}_(\d+)/){
			my $a_id = $1;
			if ($b =~ /${first_field_name}_(\d+)/) {
				my $b_id = $1;
				return $b_id <=> $a_id;
			}
		}
	} grep {$_ =~ /^${first_field_name}_(\d+)/} keys %{$params}){
		$index++;
		$task_id_param =~ /_(\d+)$/;
		my $item_id = $1;
		$form_param = Homyaki::HTML::List_Item->add_list_data(
			params      => $params,
			errors      => $errors,
			item_id     => $item_id,
			body_tag    => $body_tag,
			permissions => $permissions,
			'index'     => $index,
			list_fields => $this->LIST_FIELDS,
		);
	}

	return {
		root => $root_tag,
		body => $body_tag,
	};
}

sub get_params {
	my $this = shift;
	my %h = @_;

	my $params      = $h{params};
	my $user        = $h{user};

	Homyaki::Logger::print_log("List.pm - params = " . Dumper($params));

	my $result = $params;

	my $search_params = {};

	foreach my $param (grep {$_ =~ /(\w+)_find/} keys %{$params}){
		$param =~ /(\w+)_find$/;
		my $param_name = $1;
		$search_params->{$param_name} = $params->{$param} if $params->{$param};
	}
	Homyaki::Logger::print_log("List.pm - search_params = " . Dumper($search_params));

	my @list;
	if (scalar(keys %{$search_params})){
		@list = $this->DBI_CLASS->search(
			$search_params,
		);
	} else {
		@list = $this->DBI_CLASS->retrieve_all();
	}

	foreach my $list_item (@list) {
		foreach my $param (@{$this->LIST_FIELDS}){
			$result->{$param->{name} . '_' . $list_item->id()} = $list_item->{$param->{name}} || '&nbsp';
		}

	}

	Homyaki::Logger::print_log("List.pm - " . Dumper($result));

	return $result;
}

sub set_params {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};
	my $user   = $h{user};

	if (ref($user->{permissions}) eq 'ARRAY' && grep {$_ eq 'writer'} @{$user->{permissions}}) {

		foreach my $param (grep {$_ =~ /^list_delete_\d+$/} keys %{$params}) {
			if ($params->{$param} && $param =~ /^list_delete_(\d+)$/) {
				my $list_item = $this->DBI_CLASS->retrieve($1);
				$list_item->delete();
			}
		}

		foreach my $param (grep {$_ =~ /^list_update_\d+$/} keys %{$params}) {
			if ($params->{$param} && $param =~ /^list_update_(\d+)$/) {
				my $list_item = $this->DBI_CLASS->retrieve($1);
#				$task->set('status', &TASK_STATUS_STOPPED);
#				$task->update();
			}
		}

	}

}
sub check_params {
        my $self = shift;
        my %h = @_;

        my $params      = $h{params};
        my $user        = $h{user};

        my $errors = {};

        return $errors;
}

1;
