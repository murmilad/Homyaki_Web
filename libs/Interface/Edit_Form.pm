package Homyaki::Interface::Edit_Form;

use strict;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;

use Homyaki::Interface;
use base 'Homyaki::Interface::List_Container';

use Homyaki::Logger;
use Data::Dumper;

use constant PARAMS_MAP    => {};
use constant LIST_FIELDS   => [];
use constant LIST_HANDLER  => '';
use constant DBI_CLASS     => '';
use constant INTERFACE     => '';

sub get_tag {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};
	my $errors = $h{errors};
	my $user   = $h{user};

	Homyaki::Logger::print_log("Edit_Form.pm - user = " . Dumper($user));

	my $body_tag = $this->SUPER::get_tag(
		params => $params,
		errors => $errors,
		user   => $user,
		header => 'Homyaki',
		user   => $user,
	);

        my $form_tag = $body_tag->{body};

        my $form = $form_tag->add(
                type         => &TAG_TABLE,
                &PARAM_NAME  => "table_main_form",
                &PARAM_ID    => "table_main_form",
                &PARAM_WIDTH => '800',
        );

        Homyaki::HTML->add_login_link(
                user      => $user,
                body      => $form_tag,
                interface => $this->INTERFACE,
                auth      => 'auth',
                params    => $params,
        );


	foreach my $param (@{$this->LIST_FIELDS}) {
		$form_tag->add_form_element(
			type   => $param->{type} || &INPUT_TYPE_TEXT,
			name   => $param->{name},
			header => $param->{header},
		);
	}

	$form_tag->add_form_element(
		type   => &INPUT_TYPE_SUBMIT,
		name   => 'submit_button',
	);

	return {
		root => $body_tag->{root},
		body => $form,
	};
}

sub set_params {
        my $this = shift;
        my %h = @_;

        my $params = $h{params};
        my $user   = $h{user};

	if ($params->{submit_button}){

		my $search_params = {};
		foreach my $param (@{$this->LIST_FIELDS}) {
			$search_params->{$param->{name}} = $params->{$param->{name}};
		}
		my @items = $this->DBI_CLASS->search(
			$search_params
		);

		if (scalar(@items) > 0) {

#			my $task = Homyaki::Task_Manager->create_task(
#				task_type_id => $task_types[0]->id(),
#				params => {
#					maps_path => $params->{maps_path}
#				}
#			);
#			$params->{task_id_find} = $task->id();
		} else {
			my $item = $this->DBI_CLASS->insert(
				$search_params
			);

#			$item->update();
		}


	}

        my $parrent_result = $this->SUPER::set_params(
                params      => $params,
                user        => $user,
        );

        my $result = {};

        return $result;
}


sub get_params {
        my $self = shift;
        my %h = @_;

        my $user        = $h{user};
        my $params      = $h{params};
        my $permissions = $h{permissions};

        my $result = $params;


        my $parrent_result = $self->SUPER::get_params(
                params      => $params,
                user        => $user,
        );

        @{$result}{keys %{$parrent_result}} = values %{$parrent_result};

	return $result;

}

sub check_params {
        my $self = shift;
        my %h = @_;

        my $params      = $h{params};
        my $user        = $h{user};

        my $errors = {};
        my $parrent_errors = {};
        my $parrent_errors = $self->SUPER::check_params(
                params      => $params,
                user        => $user,
        );

       @{$errors}{keys %{$parrent_errors}} = values %{$parrent_errors};

        return $errors;
}

sub get_helper {
        my $self = shift;
        my %h = @_;

        my $body   = $h{body};
        my $params = $h{params};
        my $errors = $h{errors};

        return $body;
}
1;
