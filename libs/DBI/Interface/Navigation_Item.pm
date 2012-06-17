package Homyaki::DBI::Interface::Navigation_Item;

use strict;
use base 'Homyaki::DBI::Interface';

__PACKAGE__->table('navigation_items');
__PACKAGE__->columns(Primary => qw/name/);
__PACKAGE__->columns(Essential => qw/parrent_name header uri/);


1;
