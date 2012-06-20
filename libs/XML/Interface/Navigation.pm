#
#===============================================================================
#
#         FILE: Navigation.pm
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
package Homyaki::XML::Interface::Navigation;

use strict;
use warnings;

use base 'Homyaki::XML::Loader';
 

use constant NAVIGATION_PATH => '/var/homyaki/web/navigation';

sub get_navigation {
	my $class = shift;

	my $navigation_list = [];
	if (opendir(my $dh, &NAVIGATION_PATH)) {
		foreach my $xml_file_name (grep {/\.xml$/i && -f (&NAVIGATION_PATH . '/' . $_) } readdir($dh)){
			if (my $navigation_xml = $class->get_xml(&NAVIGATION_PATH . '/' . $xml_file_name)) {
				push(@{$navigation_list}, $navigation_xml);
			}
		}
	}

	return $navigation_list;
}

1;
