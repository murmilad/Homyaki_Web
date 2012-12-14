package Homyaki::Interface::Navigation::Simple;
#
#===============================================================================
#
#         FILE: Simple.pm
#
#  DESCRIPTION: Simple navigation plug-in
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: ALexey Kosarev (murmilad), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 17.06.2012 15:42:49
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Data::Dumper;
 
use Homyaki::Tag;
use Homyaki::HTML;
use Homyaki::HTML::Constants;

use Homyaki::Logger;
use base 'Homyaki::Interface::Navigation';

sub add_navigation {
	my $self = shift;
	my %h = @_;

	my $params     = $h{params};
	my $user       = $h{user};
	my $form_table = $h{form_table};

	my $navigation_list = $self->get_navigation_list(
		user    => $user,
		params  => $params,
		parrent => $params->{navigation_parrent},
	);

	return $form_table
		if (scalar(keys %{$navigation_list}) == 0);

	$form_table = $self->SUPER::add_navigation(
		form_table => $form_table,
	);

	my $navigation_container_row = $form_table->add(
		type        => &TAG_ROW,
		&PARAM_NAME => 'navigation_container',
		&PARAM_ID   => 'navigation_container',
	);

	my $navigation_col = $form_table->add(
		type         => &TAG_COLUMN,
		&PARAM_NAME  => 'container_menue',
		&PARAM_ID    => 'container_menue',
		&PARAM_STYLE => 'vertical-align:top',
	);

	my $show_hide_js = $navigation_col->add(
		type => &TAG_JS,
	);

	my $navigation_list_tag = $navigation_col->add(
		type => &TAG_LIST,
		&PARAM_STYLE => 'padding:0px;margin:0px;'
	);

	my $group_state = [];

	$self->add_navigation_items(
		menue               => $navigation_list,
		params              => $params,
		list_tag            => $navigation_list_tag,
		group_state         => $group_state,
	);

	
	my $i = 1;
	my $menue_flags_js = join(",\n", map {$i++ . ($_->{expanded} ? ':true' : ':false')} @$group_state); 

	$show_hide_js->{body} = qq{
		menue_flag={
			$menue_flags_js
		};

		function show_hide(name){
			if (menue_flag[name]) {
				document.getElementById('group_' + name).style.display='none';
				document.getElementById('button_' + name).innerHTML='+';
				menue_flag[name] = false;
			} else {
				document.getElementById('group_' + name).style.display='block';
				document.getElementById('button_' + name).innerHTML='-';
				menue_flag[name] = true;
			}	
		}
	};

	my $body_col = $form_table->add(
		type        => &TAG_COLUMN,
		&PARAM_NAME => 'container_body',
		&PARAM_ID   => 'container_body',
		&PARAM_STYLE => 'vertical-align:top;width:1024px',
	);

	my $main_form_table  = $body_col->add(
		type         => &TAG_TABLE,
		&PARAM_NAME  => "table_main",
		&PARAM_ID    => "table_main",
	);

	return $main_form_table;
}

sub set_parrent_group_opened{
	my %h = @_;
	my $parrent_group = $h{parrent_group};
	my $group_state   = $h{group_state};

	if ($parrent_group->{type} eq &TAG_LIST) {
		$parrent_group->{&PARAM_STYLE} =  'display:block;padding:5px;margin:0px;';
		if ($parrent_group->{&PARAM_ID} =~ /^\w+_(\d+)$/) {
			$group_state->[$1-1]->{expanded} = 1;
		}
	} elsif ($parrent_group->{type} eq &TAG_LIST_ITEM) {
		$parrent_group->{body_before} =~ s/>\+</>-</;
	}

	if ($parrent_group->{type} eq &TAG_LIST || $parrent_group->{type} eq &TAG_LIST_ITEM) {
		set_parrent_group_opened(
			parrent_group => $parrent_group->{parrent},
			group_state   => $group_state
		);
	}
}

sub add_navigation_items {
	my $this = shift;
	my %h = @_;
	my $menue        = $h{menue};
	my $params       = $h{params};
	my $list_tag     = $h{list_tag};
	my $group_state  = $h{group_state};

	if (ref($menue) eq 'HASH') {
		foreach my $menue_item (sort {$menue->{$a}->{order} <=> $menue->{$b}->{order}} keys %{$menue}){
			if ($menue->{$menue_item}->{menue}) {
				push(@{$group_state}, {expanded => 0});

				my $menue_onclick_event_html = 'onClick="show_hide(\'' . scalar(@{$group_state}) . '\');"';

				my $sub_menue_item = $list_tag->add(
					type           => &TAG_LIST_ITEM,
					body_before    => qq{<span $menue_onclick_event_html>$menue_item <b style="font-size:16px" id="button_} . scalar(@{$group_state}) . '">+</b></span>',
					&PARAM_STYLE   => 'list-style-type: none; color:#666666;font-size:10px;margin-top: 8px;',
				);
				my $sub_menue_list = $sub_menue_item->add(
					type         => &TAG_LIST,
					&PARAM_STYLE => 'display:none;padding:5px;margin:0px;',
					&PARAM_ID    => 'group_' . scalar(@{$group_state}), 
				);
				$this->add_navigation_items(
					menue       => $menue->{$menue_item}->{menue},
					params      => $params,
					list_tag    => $sub_menue_list,
					group_state => $group_state
				);
			} else {
				my $current_item = (
					$params->{interface} eq $menue->{$menue_item}->{interface}
					&& $params->{form} eq $menue->{$menue_item}->{form}
					&& $params->{navi_parameters} eq $menue->{$menue_item}->{navi_parameters}
				);

				if ($current_item) {
					set_parrent_group_opened(
						parrent_group => $list_tag,
						group_state   => $group_state
					);
				}
				my $navigation_item_tag = $list_tag->add(
					type         => &TAG_LIST_ITEM,
					&PARAM_STYLE => $current_item ? 'color:#DDDDDD; list-style-type: circle;font-size:10px;margin-top: 8px;' : 'list-style-type: none;font-size:10px;margin-top: 8px;',	
				);
				$navigation_item_tag->add(
					type         => &TAG_A,
					&PARAM_CLASS => 'param_normal',
					&PARAM_LINK  => $menue->{$menue_item}->{uri} 
						|| ('/engine/?interface=' . $menue->{$menue_item}->{interface} . '&form=' . $menue->{$menue_item}->{form} . ($menue->{$menue_item}->{navi_parameters} ? '&navi_parameters=' . $menue->{$menue_item}->{navi_parameters} : '')),
					body         => $menue_item,
					&PARAM_STYLE => $current_item ? '' : 'color:#666666;',	
				);
			}
		}
	}
}

1;
