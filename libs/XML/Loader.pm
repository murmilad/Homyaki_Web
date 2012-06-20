#
#===============================================================================
#
#         FILE: Loader.pm
#
#  DESCRIPTION: XML Simple file loader
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Alexey Kosarev (murmilad), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 20.06.2012 11:41:16
#     REVISION: ---
#===============================================================================
package Homyaki::XML::Loader;

use strict;
use warnings;
 
use XML::Simple;

sub get_xml {
	my $class         = shift;
	my $xml_file_name = shift;

	return XMLin($xml_file_name, ForceArray => 1)
		if (-f $xml_file_name);

}


1;
