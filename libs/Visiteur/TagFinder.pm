package Homyaki::Visiteur::TagFinder;

use strict;

use Homyaki::Visiteur;
use base 'Homyaki::Visiteur';

sub execute {
	my $self = shift;
	my %h = @_;

	my $tag    = $h{tag};

	my $equal = 1;

	foreach my $param (keys %{$self->{params}}){
		if ($tag->{$param} ne $self->{params}->{$param}){
			$equal = 0;
		}
	}

	if ($equal){
		$self->{tag} = $tag;
	}

}

1;
