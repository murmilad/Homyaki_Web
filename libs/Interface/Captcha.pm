package Homyaki::Interface::Captcha;

use strict;

use Data::Dumper;
use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Captcha;
use Homyaki::HTML::Constants;

use Homyaki::Gallery::Image;
use Homyaki::Gallery::Blog;

use Homyaki::Logger;

use Homyaki::Interface;
use base 'Homyaki::Interface';

use constant PARAMS_MAP  => {
	captcha_text    => {name => 'Security question'},
};

sub get_form {
	my $self = shift;
	my %h = @_;

	my $params   = $h{params};
	my $errors   = $h{errors};
	my $user     = $h{user};
	my $body_tag = $h{body_tag};

	my $root = $self->SUPER::get_form(
		params   => $params,
		errors   => $errors,
		form_id  => 'captcha_form',
		body_tag => $body_tag,
	);

	my $root_tag = $root->{root};
	my $body_tag = $root->{body};

	$body_tag->{&PARAM_WIDTH} = '30';
#	$body_tag->{&PARAM_FRAME} = 'hsides';

	my $permissions = $user->{permissions};

	my $form_param = Homyaki::HTML::Captcha->add_captcha_request(
			params      => $params,
			errors      => $errors,
			body_tag    => $body_tag,
			permissions => $permissions,
	);

	return {
		root => $root_tag,
		body => $body_tag,
	};
}

sub check_params {
	my $self = shift;
	my %h = @_;

	my $params      = $h{params};
	my $permissions = $h{permissions};

	my $errors = {};

        if ($params->{captcha_text} ne Homyaki::HTML::Captcha->get_captcha_text($params->{captcha_digest})){
                $errors->{captcha_text}->{param_name}  =  &PARAMS_MAP->{captcha_text}->{name};
		$errors->{captcha_text}->{errors}      = ['Please, answer question from image'];
        }

	return $errors;
}
1;
