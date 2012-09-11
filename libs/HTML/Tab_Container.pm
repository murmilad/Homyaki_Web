package Homyaki::HTML::Tab_Container;

use strict;

use Data::Dumper;

use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::Converter qw{get_html};

use base 'Homyaki::HTML';

use Homyaki::HTML::Constants;
use Homyaki::Task_Manager::DB::Constants;

sub add_tab_container {
	my $self = shift;
	my %h    = @_;

	my $permissions = $h{permissions};
	my $body_tag    = $h{body_tag};
	my $params      = $h{params};
	my $errors      = $h{errors};
	my $name        = $h{name};

	my $tab_panels  = $h{tab_panels};

	my $tab_panel_table = $body_tag->add(
		name   => "tab_panel_$name",
		type   => &TAG_TABLE,
	);

	if (scalar(@{$tab_panels}) > 0) {


		my $tab_panel_navi = $tab_panel_table->add(
			name   => "tab_panel_${name}_navi",
			type   => &TAG_ROW,
		);

		my $tab_element_names = [];

		foreach my $tab_panel_name (keys %{$tab_panels}) {
			my $tab_panel = $tab_panels->{$tab_panel_name};

			push(@{$tab_element_names}, "tab_panel_${name}_body_row_$tab_panel->{name}");

			my $tab_panel_button = $tab_panel_navi->add(
				name => "tab_panel_${name}_cell_$tab_panel->{name}",
				type => &TAG_COLUMN,
			);

			$tab_panel_button->add(
				type           => &TAG_INPUT,
				&PARAM_TYPE    => 'button',
				&PARAM_ONCLICK => "tab_panel_${name}_on_click('tab_panel_${name}_body_row_$tab_panel->{name}');",
				&PARAM_STYLE   => $params->{"tab_panel_${name}"} eq $tab_panel->{name} ? 'display:inline;' : 'display:none;',
				body           => $tab_panel->{caption},
			);

			my $tab_panel_body_row = $tab_panel_table->add(
				name   => "tab_panel_${name}_body_row_$tab_panel->{name}",
				type   => &TAG_ROW,
			);
			my $tab_panel_body_form = $tab_panel_body_row->add(
				name           => "tab_panel_${name}_body_col_$tab_panel->{name}",
				type           => &TAG_COLUMN,
				&PARAM_COLSPAN => scalar(@{$tab_panels}),
			);

			$tab_panel->{form_body} = $tab_panel_body_form;			
		}

		my $tab_elements_js = "'" . join("',\n'", @{$tab_element_names}) . "'";
		$body_tag->add(
			type   => &TAG_JS,
			body   => qq|
				var tab_${name}_elements = new Array(
					$tab_elements_js
				);

				procedure tab_panel_${name}_on_click(tab_name){
					for (var i = 0; i < tab_${name}_elements.length; i++) { 
						tabElement = document.getElementById(tab_name);
						if (tab_name eq tab_${name}_elements[i]){
							tabElement.style = 'display:inline';
						} else {
							tabElement.style = 'display:none';
						}
					}
				}
			|
		);
		
	}
		
	return $tab_panels;
}

1;
