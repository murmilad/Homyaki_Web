package Homyaki::Interface::Interface_Factory;

use strict;

use Exporter;

use Homyaki::DBI::Interface::Form_Handler; 
use Homyaki::Logger;

use Data::Dumper;

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

	my $request_params = {
		name           => $form || $this->DEFAULT_FORM,
		interface_name => $this->INTERFACE_NAME,
		this => $this,
	};
	Homyaki::Logger::print_log(' Homyaki::Interface::Interface_Factory rp = ' . Dumper($request_params));

	my $handler_data =  Homyaki::DBI::Interface::Form_Handler->retrieve(
		name           => $form || $this->DEFAULT_FORM,
		interface_name => $this->INTERFACE_NAME,
	);

	Homyaki::Logger::print_log(' Homyaki::Interface::Interface_Factory hd = ' . Dumper($handler_data));
	
	if ($handler_data) {
		$this->require_handler($handler_data->{handler});

		$interface = $handler_data->{handler}->new(
			params => $params,
		);
	}

	return $interface;
}
1;
