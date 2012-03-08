package Homyaki::Interface_Factory;

use strict;

use Exporter;

use base 'Homyaki::Factory';

use constant INTERFACE_MAP => {
	main         => 'Homyaki::Interface::Interface_Factory',
	default      => 'Homyaki::Interface::Interface_Factory',
	gallery      => 'Homyaki::Interface::Gallery::Interface_Factory',
	task         => 'Homyaki::Interface::Task_Manager::Interface_Factory',
	geo_maps     => 'Homyaki::Interface::Geo_Maps::Interface_Factory',
};

sub create_interface_factory{
	my $class = shift;

	my %h = @_;
	my $handler      = $h{handler};
	my $params       = $h{params};

	my $interface;

	
	if (&INTERFACE_MAP->{$handler}) {
		$class->require_handler(&INTERFACE_MAP->{$handler});
		&INTERFACE_MAP->{$handler}->new(
			params => $params,
		);
	} else {
		$class->require_handler(&INTERFACE_MAP->{default});
		&INTERFACE_MAP->{default}->new(
			params => $params,
		);
	}
}

1;
