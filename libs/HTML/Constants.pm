package Homyaki::HTML::Constants;

use strict;

use Exporter;

use constant INPUT_TYPE_LIST        => 'list';
use constant INPUT_TYPE_TEXT        => 'text';
use constant INPUT_TYPE_FILE        => 'file';
use constant INPUT_TYPE_MONEY       => 'money';
use constant INPUT_TYPE_NUMBER      => 'number';
use constant INPUT_TYPE_PASSWD      => 'password';
use constant INPUT_TYPE_IMAGE       => 'image';
use constant INPUT_TYPE_LABEL       => 'label';
use constant INPUT_TYPE_BUTTON      => 'button';
use constant INPUT_TYPE_SUBMIT      => 'submit';
use constant INPUT_TYPE_LABEL_TOTAL => 'label_total';
use constant INPUT_TYPE_HIDDEN      => 'hidden';
use constant INPUT_TYPE_LINK        => 'link';
use constant INPUT_TYPE_FORM        => 'form';
use constant INPUT_TYPE_TEXTAREA    => 'textarea';
use constant INPUT_TYPE_DIV         => 'div';
use constant INPUT_TYPE_CHECK       => 'check';
use constant INPUT_TYPE_COLOR       => 'color';

use constant LOCATION_RIGHT  => 'right';
use constant LOCATION_DOWN   => 'down';

use constant INPUT_TYPES_MAP => {
	&INPUT_TYPE_LIST        => {type => 'list', cols => 2},
	&INPUT_TYPE_TEXT        => {type => 'text', cols => 2},
	&INPUT_TYPE_MONEY       => {type => 'text', cols => 2},
	&INPUT_TYPE_FILE        => {type => 'file', cols => 2},
	&INPUT_TYPE_PASSWD      => {type => 'password', cols => 2},
	&INPUT_TYPE_HIDDEN      => {type => 'hidden', cols => 1},
	&INPUT_TYPE_IMAGE       => {type => 'image', cols => 1},
	&INPUT_TYPE_LABEL       => {type => 'label', cols => 2},
	&INPUT_TYPE_BUTTON      => {type => 'button', cols => 1},
	&INPUT_TYPE_SUBMIT      => {type => 'submit', cols => 1},
	&INPUT_TYPE_LINK        => {type => 'link', cols => 1},
	&INPUT_TYPE_NUMBER      => {type => 'text', cols => 2},
	&INPUT_TYPE_LABEL_TOTAL => {type => 'label_total', cols => 2},
	&INPUT_TYPE_FORM        => {type => 'form', cols => 1},
	&INPUT_TYPE_DIV         => {type => 'div', cols => 1},
	&INPUT_TYPE_TEXTAREA    => {type => 'textarea', cols => 1},
	&INPUT_TYPE_CHECK       => {type => 'check', cols => 1},
	&INPUT_TYPE_COLOR       => {type => 'color', cols => 1},
};

@Homyaki::HTML::Constants::ISA = qw(Exporter);

@Homyaki::HTML::Constants::EXPORT = qw(
	&INPUT_TYPE_LIST
	&INPUT_TYPE_TEXT
	&INPUT_TYPE_FILE
	&INPUT_TYPE_MONEY
	&INPUT_TYPE_NUMBER
	&INPUT_TYPE_PASSWD
	&INPUT_TYPE_IMAGE
	&INPUT_TYPE_LABEL_TOTAL
	&INPUT_TYPE_HIDDEN
	&INPUT_TYPE_LABEL
	&INPUT_TYPE_BUTTON
	&INPUT_TYPE_SUBMIT
	&INPUT_TYPE_LINK
	&INPUT_TYPE_FORM
	&INPUT_TYPE_TEXTAREA
	&INPUT_TYPE_DIV
	&INPUT_TYPE_CHECK
	&INPUT_TYPE_COLOR

	&LOCATION_RIGHT
	&LOCATION_DOWN

	&INPUT_TYPES_MAP
);

1;
