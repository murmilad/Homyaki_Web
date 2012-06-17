package Homyaki::DBI::Interface::Navigation_Handler;

use strict;
use base 'Homyaki::DBI::Interface';

__PACKAGE__->table('navigation_handlers');
__PACKAGE__->columns(Primary => qw/name/);
__PACKAGE__->columns(Essential => qw/handler description/);


1;
