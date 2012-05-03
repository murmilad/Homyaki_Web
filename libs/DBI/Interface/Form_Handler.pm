package Homyaki::DBI::Interface::Form_Handler;

use strict;
use base 'Homyaki::DBI::Interface';

__PACKAGE__->table('form_handlers');
__PACKAGE__->columns(Primary => qw/name/);
__PACKAGE__->columns(Essential => qw/handler description interface_name/);


1;
