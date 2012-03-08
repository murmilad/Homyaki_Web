package Homyaki::Interface::Default;

use strict;

use Homyaki::Tag;
use Homyaki::HTML;

use Homyaki::Interface;
use base 'Homyaki::Interface';

sub get_tag {
	my $self = shift;
	my %h = @_;

	my $params = $h{params};

	my $root_tag = $self->SUPER::get_tag(
		params => $params,
		header => 'Homyaki',
	)->{root};


	$root_tag->add(
		type => &TAG_H1,
		body => 'It\'s not anything. Sorry man, solution finding...',
	);

	$root_tag->add(
		type       => &TAG_IMG,
		&PARAM_SRC => '/data/images/construction.jpg'
	);

	return {
		root => $root_tag,
		body => $root_tag,
	};
}

1;