package Homyaki::Interface::Interface_Factory;

use strict;

use Exporter;

use Homyaki::DBI::Interface::Form_Handler; 

use base 'Homyaki::Factory';

use constant DEFAULT_FORM   => 'main';
use constant INTERFACE_NAME => 'main';

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};
	my $class = ref($this) || $this;

	bless $self, $class;

	return $self;
}

sub create_interface{
    my $this = shift;

	my %h = @_;
	my $form   = $h{form};
	my $params = $h{params};
	my $interface;

	my $handler_data =  Homyaki::DBI::Interface::Form_Handler->retrieve(
		name           => $form || $this->DEFAULT_FORM,
		interface_name => $this->INTERFACE_NAME
	);

	if ($handler_data) {
		$this->require_handler($handler_data->{handler});

		$handler_data->{handler}->new(
			params => $params,
		);
	}
}
1;
