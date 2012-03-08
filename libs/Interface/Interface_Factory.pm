package Homyaki::Interface::Interface_Factory;

use strict;

use Exporter;

use base 'Homyaki::Factory';

use constant INTERFACE_MAP => {
	main                => 'Homyaki::Interface::Default',
	ip_log              => 'Homyaki::Interface::Log_Analize',
	default             => 'Homyaki::Interface::Default',
	geo_maps            => 'Homyaki::Interface::Geo_Maps',
	geo_types           => 'Homyaki::Interface::Geo_Maps::Geo_Types',
	test_task           => 'Homyaki::Interface::Task_Manager::Test_Task',
	parter_tickets_task => 'Homyaki::Interface::Task_Manager::Parter_Tickets_Task',
	gallery_update_task => 'Homyaki::Interface::Task_Manager::Gallery_Update_Task',
};

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

	$form = $this->INTERFACE_MAP->{$form} ? $form : 'default';

	$this->require_handler($this->INTERFACE_MAP->{$form});

	$this->INTERFACE_MAP->{$form}->new(
		params => $params,
	);
}
1;
