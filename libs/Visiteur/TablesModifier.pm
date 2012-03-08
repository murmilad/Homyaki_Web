package Homyaki::Visiteur::TablesModifier;

use strict;

use Homyaki::Visiteur;
use base 'Homyaki::Visiteur';

use Homyaki::Tag;

sub execute {
	my $self = shift;
	my %h = @_;

	my $tag = $h{tag};
	my $table;
	my $row;
	my $col;
	if ($tag->{type} eq &TAG_COLUMN) {
		$self->{current_table} = scalar($tag->{parrent}->{parrent});
		$table = $self->{current_table};
		$row   = $self->{$table}->{current_row};

		$self->{$table}->{$row}->{current_col}++;
		$col   = $self->{$table}->{$row}->{current_col};

		my $span_columns = $self->{params}->{tables}->{$table}->{max_columns}
			- $self->{params}->{tables}->{$table}->{$row}->{columns};
		if ($span_columns > 0 && $col == $self->{params}->{tables}->{$table}->{$row}->{columns}){
			$tag->{&PARAM_COLSPAN} = $span_columns + 1;
		}
	} elsif ($tag->{type} eq &TAG_ROW){
		$self->{current_table} = scalar($tag->{parrent});
		$table = $self->{current_table};

		$self->{$table}->{current_row}++;
	}
}

1;
