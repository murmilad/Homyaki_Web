package Homyaki::Interface_Factory;

use strict;

use Exporter;

use Homyaki::DBI::Interface::Interface_Handler;

use base 'Homyaki::Factory';

sub create_interface_factory{
	my $class = shift;

	my %h = @_;
	my $handler      = $h{handler};
	my $params       = $h{params};

	my $interface;

	
	my $handler_data = Homyaki::DBI::Interface::Interface_Handler->retrieve($handler || 'main');

	if ($handler_data) {
		eval {
			$class->require_handler($handler_data->{handler});
		};

		$interface = $handler_data->{handler}->new(
			params => $params,
		) unless $@;
	}

	return $interface;
}

1;
