#
#===============================================================================
#
#         FILE: Redirect.pm
#
#  DESCRIPTION: Redirect forms by xml
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Alexey Kosarev (Murmilad), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 09.10.2012 22:49:50
#     REVISION: ---
#===============================================================================
package Homyaki::Handler::Redirect; 

use strict;
use warnings;

use Data::Dumper;

use Homyaki::XML::Redirection;
use Homyaki::Logger;

sub check_redirection {
	my $class = shift;

	my %h = @_;
	my $params = $h{params};

	my $redirection_list = Homyaki::XML::Redirection->get_redirections();

	Homyaki::Logger::print_log('Homyaki::Handler::Redirect' . Dumper($redirection_list));

	foreach my $redirection_block (@{$redirection_list}){
		if (
			$redirection_block->{redirection}
			&& scalar @{$redirection_block->{redirection}} > 0
		) {
			foreach my $redirection (@{$redirection_block->{redirection}}){
				my $equal = 1;
				foreach my $param_name( keys %{$redirection->{from}->[0]}){
					if ($redirection->{from}->[0]->{$param_name} ne $params->{$param_name}) {
						$equal = 0;
					}
				}
				if ($equal){
					foreach my $param_name( keys %{$redirection->{to}->[0]}){
						$params->{$param_name} = $redirection->{to}->[0]->{$param_name};
					}
				}
			}
		}
	}	
}

1;

