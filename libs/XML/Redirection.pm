#
#===============================================================================
#
#         FILE: Redirection.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 20.06.2012 11:26:19
#     REVISION: ---
#===============================================================================
package Homyaki::XML::Redirection;

use strict;
use warnings;

use base 'Homyaki::XML::Loader';
 

use constant REDIRECTION_PATH => '/var/homyaki/web/redirection';

sub get_redirections {
	my $class = shift;

	my $redirection_list = [];
	if (opendir(my $dh, &REDIRECTION_PATH)) {
		foreach my $xml_file_name (grep {/\.xml$/i && -f (&REDIRECTION_PATH . '/' . $_) } readdir($dh)){
			if (my $redirection_xml = $class->get_xml(&REDIRECTION_PATH . '/' . $xml_file_name)) {
				push(@{$redirection_list}, $redirection_xml);
			}
		}
	}

	return $redirection_list;
}

1;
