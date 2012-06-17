package Homyaki::Interface::Navigation_Factory;

use strict;

use Exporter;

use Homyaki::DBI::Interface::Navigation_Handler; 
use Homyaki::Logger;

use Data::Dumper;

use base 'Homyaki::Factory';

use constant DEFAULT_NAVIGATION  => 'simple';

sub new {
	my $this = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = {};
	my $class = ref($this) || $this;

	bless $self, $class;

	return $self;
}

sub create_navigation{
    my $this = shift;

	my %h = @_;
	my $name   = $h{name};
	my $params = $h{params};
	my $navigation;

	my $request_params = {
		name => $form || $this->DEFAULT_NAVIGATION,
		this => $this,
	};
	Homyaki::Logger::print_log(' Homyaki::Interface::Navigation_Factory rp = ' . Dumper($request_params));

	my $handler_data =  Homyaki::DBI::Interface::Navigation_Handler->retrieve(
		name           => $form || $this->DEFAULT_NAVIGATION,
	);

	Homyaki::Logger::print_log(' Homyaki::Interface::Navigation_Factory hd = ' . Dumper($handler_data));
	
	if ($handler_data) {
		$this->require_handler($handler_data->{handler});

		$navigation = $handler_data->{handler}->new(
			params => $params,
		);
	}

	return $navigation;
}
1;
