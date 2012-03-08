package Homyaki::Visiteur::RowsCalculator;

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
	if ($tag->{type} eq &TAG_COLUMN) {
		$self->{current_table} = scalar($tag->{parrent}->{parrent});
		$table = $self->{current_table};
		$row   = $self->{$table}->{current_row};

		$self->{params}->{tables}->{$table}->{$row}->{columns}++;
	} elsif ($tag->{type} eq &TAG_ROW){
		$self->{current_table} = scalar($tag->{parrent});
		$table = $self->{current_table};
		$row   = $self->{$table}->{current_row};

		if ($self->{params}->{tables}->{$table}->{$row}->{columns} > $self->{params}->{tables}->{$table}->{max_columns}){
			$self->{params}->{tables}->{$table}->{max_columns} = $self->{params}->{tables}->{$table}->{$row}->{columns};
		}
		$self->{$table}->{current_row}++;
	}
}

1;
