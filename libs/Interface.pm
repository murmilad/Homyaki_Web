package Homyaki::Interface;

use strict;

use Homyaki::HTML;
use Homyaki::Tag;

use constant WWW_PATH               => $ENV{DOCUMENT_ROOT};
use constant INPUT_TYPE_LIST        => 'list';
use constant INPUT_TYPE_TEXT        => 'text';
use constant INPUT_TYPE_MONEY       => 'money';
use constant INPUT_TYPE_NUMBER      => 'number';
use constant INPUT_TYPE_CHECK       => 'check';
use constant INPUT_TYPE_LABEL_TOTAL => 'label_total';

use constant PARAMS_REGEX_MAP       => {
	&INPUT_TYPE_TEXT        => '^[^"\']*$',
	&INPUT_TYPE_MONEY       => '^\d*(\.\d+)?$',
	&INPUT_TYPE_NUMBER      => '^\d*(\.\d+)?$',
	&INPUT_TYPE_LIST        => '^.+$',
};

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
	&WWW_PATH
);


use constant PARAMS_MAP => {};

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};

	my $class = ref($this) || $this;
	bless $self, $class;

	return $self;
}

sub make_tags {
	my $self = shift;
	my %h = @_;

	my $params = $h{params};
	my $errors = $h{errors};
	my $user   = $h{user};

	my $tags = $self->get_tag(
		params => $params,
		errors => $errors,
		user   => $user,
	);

	$self->{tags}    = $tags->{root};

	return $self->{tags};
}

sub get_tag {
	my $this = shift;
	my %h = @_;

	my $header = $h{header};
	my $params = $h{params};
	my $errors = $h{errors};

	my $html = Homyaki::HTML->new(
		type => &TAG_HTML,
	);

	my $body = $html->add_page_body(
		header        => $header,
	);

	my $block_refresh_js = "\$(document).on(\"keydown\", safeF5);";

	my $refresh_js = $this->get_refresh_js();
	$block_refresh_js .= "function safeF5(e) { if ((e.which || e.keyCode) == 116){ e.preventDefault(); $refresh_js}};";

	$body->add(
		type => &TAG_JS,
		&PARAM_TYPE => 'text/javascript',
		body => $block_refresh_js,
	);

	if (ref($errors) eq 'HASH' && scalar(keys %{$errors}) > 0) {
		$body->add_error_list(errors => $errors);
	}

	return {
		root => $html,
		body => $body,
	};
}

sub check_params {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $errors = {};
	foreach my $param_name (keys %{$this->PARAMS_MAP}){
		my $param_type  = $this->PARAMS_MAP->{$param_name}->{type};
		my $param_regex = $this->PARAMS_MAP->{$param_name}->{regex} || &PARAMS_REGEX_MAP->{$param_type};
		if ($this->PARAMS_MAP->{$param_name}->{required} && !$params->{$param_name}){
			$errors->{$param_name}->{param_name} = $this->PARAMS_MAP->{$param_name}->{name};
			$errors->{$param_name}->{errors}     = ['Please enter value'];
		} elsif ($param_regex && $params->{$param_name} !~ /$param_regex/){
			$errors->{$param_name}->{param_name} = $this->PARAMS_MAP->{$param_name}->{name};
			$errors->{$param_name}->{errors}     = ['Incorrect value'];
		}
	}

	return $errors;
}

sub set_params {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $result = {};

	return $result;
}

sub get_params {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $result = $params;

	return $result;
}

sub get_html {
	my $this = shift;
	my %h = @_;

	my $result = '';

	if ($this->{tags}){
		$result = $this->{tags}->to_str();
	};

	return $result;
};

sub is_auth {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	return 0;
}

sub set_auth {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	return {
		errors => {
			base => [
				'You have no permissions.'
			],
		},
	};
}

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

sub get_navigation {
	my $self = shift;
	my %h = @_;

	my $params   = $h{params};
	my $user     = $h{user};

	my $navigation = {};

	return $navigation;
}

sub get_refresh_js {
	return '';
};

1;
