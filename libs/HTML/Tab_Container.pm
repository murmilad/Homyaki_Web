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

	my $tab_panel_table = $body_tag->add_form_element(
		name   => "tab_panel_${name}_body",
		type   => &INPUT_TYPE_DIV,
	);
	
	my $current_tab_element = $body_tag->add_form_element(
		name   => "tab_panel_${name}",
		type   => &INPUT_TYPE_HIDDEN,
		value  => $params->{"tab_panel_${name}"},
	);

	$tab_panel_table = $tab_panel_table->add(
		type         => &TAG_TABLE,
		&PARAM_CLASS => 'tab',
	);

	
	if (scalar(keys %{$tab_panels}) > 0) {

		if (scalar(keys %{$tab_panels}) > 1) {


			my $tab_panel_navi = $tab_panel_table->add(
				name   => "tab_panel_${name}_navi",
				type   => &TAG_ROW,
			);

			my $tab_panel_buffer = $tab_panel_table->add(
				type   => &TAG_ROW,
			);

			my $tab_element_names = [];

			foreach my $tab_panel_name (sort keys %{$tab_panels}) {
				unless ($params->{"tab_panel_${name}"}){
					$params->{"tab_panel_${name}"} = $tab_panel_name;
					$current_tab_element->{&PARAM_VALUE} = $tab_panel_name;
				}

				my $tab_panel = $tab_panels->{$tab_panel_name};

				my $is_current_tab = $params->{"tab_panel_${name}"} eq $tab_panel->{name};

				push(@{$tab_element_names}, $tab_panel->{name});

				my $tab_panel_button = $tab_panel_navi->add(
					type         => &TAG_COLUMN,
					&PARAM_WIDTH => 100,
					&PARAM_CLASS => $is_current_tab ? 'tab_navi_selected' : 'tab_navi',
					&PARAM_ID    => "tab_panel_${name}_navi_column_$tab_panel->{name}"
				);

				$tab_panel_button->add(
					type           => &TAG_INPUT,
					&PARAM_TYPE    => 'button',
					&PARAM_ONCLICK => "tab_panel_${name}_on_click('$tab_panel->{name}');",
					&PARAM_ID      => "tab_panel_${name}_navi_button_$tab_panel->{name}",
					&PARAM_VALUE   => $tab_panel->{header},
					&PARAM_CLASS   => $is_current_tab ? 'tab_navi_selected' : 'tab_navi',
				);

				$tab_panel_buffer->add(
					type         => &TAG_COLUMN,
					&PARAM_CLASS => scalar(@{$tab_panel_buffer->{child}}) ? 'tab_buffer' : 'tab_buffer_l',
				);

				my $tab_panel_body_row = $tab_panel_table->add(
					&PARAM_ID      => "tab_panel_${name}_body_row_$tab_panel->{name}",
					&PARAM_STYLE   => $is_current_tab ? '' : 'display:none;',
					type           => &TAG_ROW,
				);
				my $tab_panel_body_form = $tab_panel_body_row->add(
					type           => &TAG_COLUMN,
					&PARAM_COLSPAN => scalar(keys %{$tab_panels}) + 1,
					&PARAM_CLASS   => 'tab_body',
				);

				$tab_panel_body_form = $tab_panel_body_form->add(
					type   => &TAG_TABLE,
				);

				$tab_panel->{form_body} = $tab_panel_body_form;			
			}

			$tab_panel_navi->add(
				type         => &TAG_COLUMN,
				body         => '&nbsp;',
				&PARAM_CLASS => 'tab_navi',
			);

			$tab_panel_buffer->add(
				type         => &TAG_COLUMN,
				&PARAM_CLASS => 'tab_buffer_r',
			);

			my $tab_elements_js = "'" . join("',\n'", @{$tab_element_names}) . "'";
			$body_tag->add(
				type   => &TAG_JS,
				body   => qq|
					var tab_${name}_elements = new Array(
						$tab_elements_js
					);

					function tab_panel_${name}_on_click(tab_name){
						for (var i = 0; i < tab_${name}_elements.length; i++) { 
							tabElement    = document.getElementById('tab_panel_${name}_body_row_' + tab_${name}_elements[i]);
							naviElement   = document.getElementById('tab_panel_${name}_navi_column_' + tab_${name}_elements[i]);
							buttonElement = document.getElementById('tab_panel_${name}_navi_button_' + tab_${name}_elements[i]);

							tabNameElement = document.getElementById('tab_panel_${name}');

							if (tab_name == tab_${name}_elements[i]){
								if (document.all) {
									tabElement.style.display = 'inline';
								} else { 
									tabElement.style.display = 'table-row';
								}
								naviElement.className   = 'tab_navi_selected';
								buttonElement.className = 'tab_navi_selected';
								tabNameElement.value    = tab_name;
							} else {
								tabElement.style.display = 'none';
								naviElement.className = 'tab_navi';
								buttonElement.className = 'tab_navi';
							}
						}
					}
				|
			);
		} else {
			my $tab_panel = $tab_panels->{[keys %{$tab_panels}]->[0]};

			my $tab_panel_body_row = $tab_panel_table->add(
				type   => &TAG_ROW,
			);

			my $tab_panel_body_form = $tab_panel_body_row->add(
				type   => &TAG_COLUMN,
			);

			$tab_panel_body_form = $tab_panel_body_form->add(
				type   => &TAG_TABLE,
			);

			$tab_panel->{form_body} = $tab_panel_body_form;			
		}
	}
		
	return $tab_panels;
}

1;
