package Homyaki::Handler;
  
use strict;
use warnings;

use Homyaki::Handler::Redirect;
use Homyaki::Interface_Factory;
use Homyaki::Permission_Factory;
use Homyaki::Visiteur::RowsCalculator;
use Homyaki::Visiteur::TablesModifier;

use Homyaki::Logger;

use Encode qw(encode);
use Data::Dumper;
use URI::Escape;

use Crypt::Tea;

use Apache2::Cookie;
use Apache2::RequestRec;
use Apache2::RequestIO;
use Apache2::Request;
use Apache2::Connection;

use Homyaki::Logger;

use Apache2::Const -compile => qw(OK);

use constant COLORS => {
	Branch => '#66CC66',
	Trunk  => '#FF3300',
	Tag    => '#9999FF'
};

use constant CRYPT_KEY => 'homyak';

sub handler {
	my $r    = shift;

	$r->content_type('text/html');

	my $c          = $r->connection;
	my $ip_address = $c->remote_ip;


	my $req = Apache2::Request->new($r);

	my $param_hash ={};

	my @params = $req->param();
	map {
		$param_hash->{$_} = $req->param($_);
	} @params;

	Homyaki::Handler::Redirect->check_redirection(
		params => $param_hash
	);

	foreach my $upload ($req->upload) {
		if ($param_hash->{$upload}) {
			my $file = $req->upload($upload);
			
			$param_hash->{$upload} = {
				file_handler => $file->upload_fh,
				file_size    => $file->upload_size,
				file_type    => $file->upload_type,
				file_name    => $file->upload_filename,
			};
		}
	}

	$param_hash->{current_uri} = $r->uri() . '?' . $r->args();
	$param_hash->{ip_address}  = $ip_address;

	my $interface_factory = Homyaki::Interface_Factory->create_interface_factory(
		handler      => $param_hash->{interface},
		params       => $param_hash,
	);

	my $errors = {};
	my $set_result = {};

	my $jar    = Apache2::Cookie::Jar->new($r);
	my $cookie = $jar->cookies($param_hash->{interface});
	my $user_id;
	if ($cookie){
		my $value = decrypt(pack("H*",$cookie->value()), &CRYPT_KEY);

		my %value = Apache2::Cookie->thaw($value);
		$user_id = $value{user_id};
	}

	my $permissions = Homyaki::Permission_Factory->create_permissions(
		handler => $param_hash->{interface},
	);

	my $user = $permissions->get_user(
		user_id => $user_id
	);

	my $interface = $interface_factory->create_interface(
		form => $param_hash->{form}
	);

	if ($param_hash->{current_action} && $param_hash->{current_action} ne 'view'){
		if ($interface->is_auth()){
			my $result = $interface->set_auth(params => $param_hash);
			if (keys %{$result->{errors}}) {
				$errors = $result->{errors};
			} elsif ($result->{user}){
				my $value = Apache2::Cookie->freeze({user_id => $result->{user}->{id}});
				$cookie = Apache2::Cookie->new(
					$r,
					-name   => $param_hash->{interface},
					-value  => unpack("H*",encrypt($value, &CRYPT_KEY)),
				);
				$cookie->bake($r);
				$user = $result->{user};
			}
		}

		unless (keys %{$errors}) {
			$errors = $interface->check_params(
				params => $param_hash,
				user   => $user,
			);
			unless (scalar(keys %{$errors}) > 0) {
				$set_result = $interface->set_params(
					params  => $param_hash,
					user    => $user,
				);
				$errors = $set_result->{errors};
#				if (scalar(keys %{$set_result->{errors}}) > 0) {
#					@{$errors}{keys %{$set_result->{errors}}} = values %{$set_result->{errors}};
#				}
			}
		}
	}

	my $db_param_hash = $interface->get_params(
		params  => $param_hash,
		user    => $user,
	);


	if (scalar(keys %{$errors}) > 0) {
		@{$db_param_hash}{keys %{$param_hash}} = values %{$param_hash};
	}

	$param_hash = $db_param_hash;

	$interface->make_tags(
		params  => $param_hash,
		errors  => $errors,
		user    => $user,
	);

	my $rows_calculator = Homyaki::Visiteur::RowsCalculator->new();
	$interface->{tags}->visit($rows_calculator);

	my $tables_modifier = Homyaki::Visiteur::TablesModifier->new(
		params => $rows_calculator->{params}
	);
	$interface->{tags}->visit($tables_modifier);

	print $interface->get_html();

	return Apache2::Const::OK;
}
1;

