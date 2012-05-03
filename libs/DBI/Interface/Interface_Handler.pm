package Homyaki::DBI::Interface::Interface_Handler;

use strict;
use base 'Homyaki::DBI::Interface';

__PACKAGE__->table('interface_handlers');
__PACKAGE__->columns(Primary => qw/name/);
__PACKAGE__->columns(Essential => qw/handler description/);


1;
