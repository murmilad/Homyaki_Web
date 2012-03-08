package Homyaki::Interface::Log_Analize;

use strict;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::Apache_Log;

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
		body => "Here is log for ip $params->{ip}",
	);

	my $list_tag = $root_tag->add(
		type       => &TAG_LIST,
	);

	foreach my $ip_log_param (sort {
                if ($a =~ /ip_log_(\d+)/){
                        my $a_id = $1;
                        if ($b =~ /ip_log_(\d+)/) {
                                my $b_id = $1;
                                return $b_id <=> $a_id;
                        }
                }
        } grep {$_ =~ /^ip_log_/} keys %{$params}){

		my $item_tag = $list_tag->add(
			type       => &TAG_LIST_ITEM,
			body       => $params->{$ip_log_param},
		);
	}

	return {
		root => $root_tag,
		body => $root_tag,
	};
}

sub get_params {
        my $self = shift;
        my %h = @_;

        my $params      = $h{params};
        my $permissions = $h{permissions};

        my $result = $params;

        if ($params->{ip} =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/ ) {
		my $log_list = Homyaki::Apache_Log::load_hosts(&HTTP_LOG_PATH);

#		unless ($log_list){
#			$log_list = Homyaki::Apache_Log::get_log_data(&HTTP_LOG_PATH);
#		}

		my $index = 0;
		foreach my $reqiest (@{$log_list->{$params->{ip}}->{requests}}){
			$index++;
			$result->{"ip_log_$index"} = $reqiest;
		}

        }

        return $result;
}

1;
