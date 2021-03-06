package Homyaki::Interface::List_Container;

use strict;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;
use Homyaki::Interface::Geo_Maps::Geo_Types;

use Homyaki::Interface::Navigation_Factory;

use Homyaki::Interface;
use base 'Homyaki::Interface';

use constant INTERFACE     => 'list_container';
use constant LIST_HANDLER  => '';

sub get_form {
	my $self = shift;
	my %h = @_;

	my $params   = $h{params};
	my $errors   = $h{errors};
	my $body_tag = $h{body_tag};
	my $form_id  = $h{form_id};


	my $form_body = $body_tag->add(
		type         => &TAG_TABLE,
		&PARAM_NAME  => "table_$form_id",
		&PARAM_ID    => "table_$form_id",
		&PARAM_WIDTH => '950',
	);

	return {
		root => $self,
		body => $form_body
	};
}

sub get_tag {
	my $self = shift;
	my %h = @_;

	my $params = $h{params};
	my $errors = $h{errors};
	my $user   = $h{user};
	my $header = $h{header} || 'Homyaki. Хомяки.';

	my $root = $self->SUPER::get_tag(
		params => $params,
		errors => $errors,
		header => $header,
		user   => $user,
	);

	my $root_tag = $root->{root};
	my $body_tag = $root->{body};

	my $form = $body_tag->add_form(
		interface => $params->{interface},
		form_name => $params->{form},
		form_id   => 'main_form',
	);

	my $helper_tag = $self->get_helper(
		params => $params,
		errors => $errors,
		body   => Homyaki::HTML->new(
			type         => &TAG_TABLE,
			&PARAM_NAME  => "table_helper",
			&PARAM_ID    => "table_helper",
		),
	);

	my $main_form = {};

	my $main_form_table  = $form->add(
		type         => &TAG_TABLE,
		&PARAM_NAME  => "table_main",
		&PARAM_ID    => "table_main",
	);

	my $navigation_factory = Homyaki::Interface::Navigation_Factory->new();
	my $navigation = $navigation_factory->create_navigation(
		name => 'simple'
	);
	
	$main_form_table = $navigation->add_navigation(
		user       => $user,
		params     => $params,
		form_table => $main_form_table
	);

	if (scalar(@{$helper_tag->{child}}) > 0){


		$main_form_table->add_form_element(
			type           => &INPUT_TYPE_HIDDEN,
			value          => 'false',
			name           => 'helper_enubled',
		);

		$main_form_table->add_form_element(
			type           => &INPUT_TYPE_LABEL,
			value          => 'Кликнуть для помощи',
			&PARAM_ONCLICK => qq|
				if (document.getElementById('helper_enubled').value == 'false') {
					document.getElementById('helper').style.display = 'inline';
					document.getElementById('helper_enubled').value = 'true';
				} else {
					document.getElementById('helper').style.display = 'none';
					document.getElementById('helper_enubled').value = 'false';
				}
			|
		);

		my $helper_data = $main_form_table->add_form_element(
			type     => &INPUT_TYPE_DIV,
			name     => 'helper',
			&PARAM_STYLE => 'display:none;'
		);

		$helper_tag->{parrent} => $helper_data;
		push(@{$helper_data->{child}}, $helper_tag);

	}

	$main_form = $main_form_table->add_form_element(
		type   => &INPUT_TYPE_DIV,
		name   => 'main',
	);

	my $table = $self->get_form(
		params   => $params,
		errors   => $errors,
		form_id  => 'main_form',
		body_tag => $main_form,
	);

	my $list_form = $main_form_table->add_form_element(
		type   => &INPUT_TYPE_DIV,
		name   => 'div_tasks',
	);

        $self->LIST_HANDLER->get_form(
                params   => $params,
                errors   => $errors,
                body_tag => $list_form,
                user     => $user,
                contact_email => 'netalexinfo@hotbox.ru',
                contact_name  => 'Alexey Kosarev (Murmilad)',
        );

	my $form_tag      = $table->{root};
	my $form_body_tag = $table->{body};

	return {
		root => $root_tag,
		body => $form_body_tag
	};
}

sub set_params {
        my $this = shift;
        my %h = @_;

        my $params      = $h{params};
        my $user        = $h{user};

        my $result = $this->LIST_HANDLER->set_params(
                params      => $params,
                user        => $user,
        );

	return $result;
}

sub get_params {
        my $self = shift;
        my %h = @_;

        my $params      = $h{params};
        my $user        = $h{user};

        my $result = $self->LIST_HANDLER->get_params(
                params      => $params,
                user        => $user,
        );

	return $result;
}

sub check_params {
        my $self = shift;
        my %h = @_;

        my $params      = $h{params};
        my $user        = $h{user};

        my $errors = $self->LIST_HANDLER->check_params(
                params      => $params,
                user        => $user,
        );
	my $parrent_errors = {};

	if ($params->{submit_button}){
		$parrent_errors = $self->SUPER::check_params(
			params      => $params,
			user        => $user,
		);
	}

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
