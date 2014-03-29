package Homyaki::HTML;

use strict;


use Homyaki::Tag;
use base 'Homyaki::Tag';

use Homyaki::HTML::Constants;
use Homyaki::Visiteur::TagFinder;

sub add_page_body {
	my $self = shift;
	my %h    = @_;

	my $header  = $h{header};

#	my $tag_html = $self->SUPER::add(
#		type         => &TAG_HTML,
#	);

	my $tag_head = $self->add(
		type         => &TAG_HEAD,
	);

        $tag_head->add(
                type => &TAG_JS,
                &PARAM_SRC  => 'https://apis.google.com/js/plusone.js',
                &PARAM_TYPE => 'text/javascript',
                body => ' ',
        );


	$tag_head->add(
		type => &TAG_LINK,
		&PARAM_REL  => 'stylesheet',
		&PARAM_HREF => '/css/jquery-ui.css',
		body => ' ',
	);

	$tag_head->add(
		type => &TAG_JS,
		&PARAM_SRC  => '/js/jquery.js',
		&PARAM_TYPE => 'text/javascript',
		body => ' ',
	);
	$tag_head->add(
		type => &TAG_JS,
		&PARAM_SRC  => '/js/jquery-ui.js',
		&PARAM_TYPE => 'text/javascript',
		body => ' ',
	);

	my $tag_meta = $tag_head->add(
		type              => &TAG_META,
		&PARAM_HTTP_EQUIV => 'pragma',
		&PARAM_CONTENT    => 'no-cache',
	);

	my $tag_title = $tag_head->add(
		type => &TAG_TITLE,
		body => $header,
	);

	my $tag_css = $tag_head->add(
		type        => &TAG_LINK,
		&PARAM_REL  => 'stylesheet',
		&PARAM_TYPE => 'text/css',
		&PARAM_HREF => '/main.css',
	);

	my $tag_favicon = $tag_head->add(
		type        => &TAG_LINK,
		&PARAM_REL  => 'icon',
		&PARAM_TYPE => 'image/vnd.microsoft.icon',
		&PARAM_HREF => '/favicon.ico',
	);

	$tag_meta = $tag_head->add(
		type              => &TAG_META,
		&PARAM_HTTP_EQUIV => 'Content-Type',
		&PARAM_CONTENT    => 'text/html; charset=utf-8;',
	);

	my $tag_body = $self->add(
		type         => &TAG_BODY,
		body         => '<g:plusone></g:plusone>'
	);

	
	return $tag_body;
}

sub add_submit_button {
	my $self = shift;
	my %h    = @_;

	my $header  = $h{header};
	my $hidden  = $h{hidden};

	my $row_visible = $hidden ? 'display: none;' : 'display: table-row;';

	my $element_row = $self->SUPER::add(
		type         => &TAG_ROW,
		&PARAM_ID    => 'row_submit_button',
		&PARAM_CLASS => 'buttons',
		&PARAM_STYLE => $row_visible,
	);

	my $element_col = $element_row->add(
		type           => &TAG_COLUMN,
		&PARAM_COLSPAN => 2,
	);

	my $submit_button = $element_col->add(
		type         => &TAG_INPUT,
		&PARAM_ID    => 'submit_button',
		&PARAM_TYPE  => 'submit',
		&PARAM_VALUE => $header,
	);

	return $submit_button;
}

sub add_form {
	my $self = shift;
	my %h    = @_;

	my $id             = $h{id};
	my $interface      = $h{interface};
	my $form_name      = $h{form_name};
	my $form_id        = $h{form_id};
	my $contact_email  = $h{contact_email};
	my $contact_name   = $h{contact_name};
	my $next_form_name = $h{next_form_name};
	my $form_uri       = $h{form_uri} || {};

	my $form = $self->add(
		type           => &TAG_FORM,
		&PARAM_METHOD  => 'post',
		&PARAM_ID      => $form_id,
		&PARAM_ENCTYPE => 'multipart/form-data',
		&PARAM_ACTION  => "?interface=$interface&form=$form_name" . (scalar(keys %{$form_uri}) > 0 ? ('&' . join('&', map {"$_=$form_uri->{$_}"} keys %{$form_uri})) : ''),
	);

	$form->add(
		type         => &TAG_INPUT,
		&PARAM_ID    => 'current_action',
		&PARAM_NAME  => 'current_action',
		&PARAM_TYPE  => 'hidden',
		&PARAM_VALUE => 'A-u',
	);

	$form->add(
		type         => &TAG_INPUT,
		&PARAM_ID    => 'next_form',
		&PARAM_NAME  => 'next_form',
		&PARAM_TYPE  => 'hidden',
		&PARAM_VALUE => $next_form_name,
	);

	if ($contact_email || $contact_name) {
		my $contact_data = $self->add(
			type           => &TAG_TABLE,
			&PARAM_STYLE   => "font-family:courier new; color:gray; font-size:10px;",
			&PARAM_WIDTH   => "100%",
		);

		$contact_data = $contact_data->add(
			type  => &TAG_COLUMN,
		);

		$contact_data = $contact_data->add(
			type  => &TAG_ROW,
		);

		$contact_data->add(
			type         => &TAG_COLUMN,
			body         => $contact_email,
			&PARAM_STYLE => "text-align:left",
		);

		$contact_data->add(
			type         => &TAG_COLUMN,
			body         => $contact_name,
			&PARAM_STYLE => "text-align:right",
		);
	}

	return $form;
}

sub add_form_element {
	my $self = shift;
	my %h    = @_;

	my $name     = $h{name};
	my $type     = $h{type};
	my $list     = $h{list};
	my $error    = $h{error};
	my $value    = $h{value};
	my $header   = $h{header};
	my $location = $h{location} || &LOCATION_DOWN;
	my $command  = $h{command};
	my $hidden   = $h{hidden};
	my $default_value = $h{default_value};
	my $link     = $h{'link'};
	

	my $tag_params = {};
	foreach my $param (keys %h) {
		if (grep {$_ eq $param} ((keys %{&SUPPORTED_PARAMETERS_MAP}), 'body')){
			$tag_params->{$param} = $h{$param} if defined($h{$param});
		}
	}

	my $css_class   = $error  ? 'param_error'    : 'param_normal';
	my $row_visible = $hidden ? 'display: none;' : 'display: table-row;';
	my $col_visible = $hidden ? 'display: none;' : 'display: table-column;';

	my $element_value_col = $self->{parrent};

	if ($location eq &LOCATION_DOWN){
		my $element_row = $self->SUPER::add(
			type         => &TAG_ROW,
			&PARAM_ID    => "row_$name",
			&PARAM_STYLE => $row_visible,
		);
		if ($header) {
			my $element_header_col = $element_row->add(
				type         => &TAG_COLUMN,
				&PARAM_CLASS => $css_class . '_label_col' ,
			);

			my $element_nobr = $element_header_col->add(
				type         => &TAG_NOBR,
			);

			my $element_label = $element_nobr->add(
				type         => &TAG_LABEL,
				&PARAM_FOR   => $name,
			);

			my $element_span = $element_label->add(
				type         => &TAG_SPAN,
				body         => "$header:",
				&PARAM_CLASS => $tag_params->{&PARAM_CLASS} || $css_class,
			);

			$element_value_col = $element_row->add(
				type         => &TAG_COLUMN,
				&PARAM_WIDTH => '90%',
				&PARAM_CLASS => $css_class . '_value_col',
			);
		} else {
			$element_value_col = $element_row->add(
				type           => &TAG_COLUMN,
				&PARAM_CLASS   => $css_class . '_value_col' ,
			);
		}
	} elsif ($location eq &LOCATION_RIGHT){
		my $element_row = $element_value_col->{parrent};
		$element_value_col = $element_row->add(
			type           => &TAG_COLUMN,
			&PARAM_ID      => "col_$name",
			&PARAM_CLASS   => $css_class . '_value_col' ,
#			&PARAM_STYLE   => $col_visible,
		);
	}

	if ($link){
		$element_value_col = $element_value_col->add(
			type           => &TAG_A,
			&PARAM_LINK    => $link,
			&PARAM_CLASS   => 'param_normal',
		);
	}

	my $element_input = $element_value_col->get_input_by_type(
		name    => $name,
		list    => $list,
		type    => $type,
		value   => $value,
		command => $command,
		tag_params => $tag_params,
		default_value => $default_value,
	);

	return $element_input;
}

sub get_input_by_type {
	my $self = shift;
	my %h    = @_;

	my $type    = $h{type};
	my $list    = $h{list};
	my $name    = $h{name};
	my $value   = $h{value};
	my $command = $h{command};
	my $tag_params = $h{tag_params};
	my $default_value = $h{default_value};

	my $element_input;

	if (&INPUT_TYPES_MAP->{$type}->{type} eq 'image'){
		$element_input = $self->add(
			type         => &TAG_IMG,
			&PARAM_ID    => $name,
			&PARAM_NAME  => $name,
			&PARAM_SRC  => $value,
			%{$tag_params}
		);
	} elsif (&INPUT_TYPES_MAP->{$type}->{type} eq 'list'){

		$element_input = $self->add(
			type         => &TAG_SELECT,
			&PARAM_ID    => $name,
			&PARAM_NAME  => $name,
			&PARAM_VALUE => $value,
			%{$tag_params}
		);

		$element_input->add(
			type            => &TAG_SELECT_OPTION,
			body            => '---',
			&PARAM_VALUE    => 0,
		);

		$element_input->add_list_elements(
			value => $value,
			list  => $list,
		)
	} elsif(&INPUT_TYPES_MAP->{$type}->{type} eq 'label') {
		$element_input = $self->add(
			type         => &TAG_SPAN,
			body         => $value,
			&PARAM_CLASS => $tag_params->{&PARAM_CLASS} || 'param_normal',
			%{$tag_params}
		);
	} elsif(&INPUT_TYPES_MAP->{$type}->{type} eq 'form') {
		$element_input = $self->add(
			type         => &TAG_TABLE,
			%{$tag_params}
		);
	} elsif(&INPUT_TYPES_MAP->{$type}->{type} eq 'div') {
		$element_input = $self->add(
			type         => &TAG_DIV,
			&PARAM_ID    => $name,
			body         => $value,
			%{$tag_params}
		);
	} elsif(&INPUT_TYPES_MAP->{$type}->{type} eq 'check') {
		$element_input = $self->add(
			type           => &TAG_INPUT,
			&PARAM_ID      => $name,
			&PARAM_NAME    => $name,
			&PARAM_TYPE    => 'checkbox',
			&PARAM_CHECKED => $value,
			&PARAM_VALUE   => $value,
			%{$tag_params}
		);
	} elsif (&INPUT_TYPES_MAP->{$type}->{type} eq 'button'){
		$element_input = $self->add(
			type           => &TAG_INPUT,
			&PARAM_ID      => $name,
			&PARAM_NAME    => $name,
			&PARAM_TYPE    => 'button',
			&PARAM_VALUE   => $value,
			&PARAM_ONCLICK => $command ? "${name}_onclick(this);" : $tag_params->{&PARAM_ONCLICK},
			%{$tag_params}
		);
		$self->add(
			type => &TAG_JS,
			body => qq|
				function ${name}_onclick(current)
				{
					$command
				}
			|
		) if $command;
	} elsif (&INPUT_TYPES_MAP->{$type}->{type} eq 'submit'){
		$element_input = $self->add(
			type         => &TAG_INPUT,
			&PARAM_ID    => $name,
			&PARAM_NAME  => $name,
			&PARAM_TYPE  => 'submit',
			&PARAM_VALUE => $value,
			%{$tag_params}
		);
		$self->{&PARAM_CLASS} = 'buttons';
	} elsif (&INPUT_TYPES_MAP->{$type}->{type} eq 'textarea'){
		$element_input = $self->add(
			type         => &TAG_TEXTAREA,
			&PARAM_ID    => $name,
			&PARAM_NAME  => $name,
			body         => $value || $default_value,
			%{$tag_params}
		);
		if($default_value){
			my $on_focus_js = qq|
				function ${name}_onfocus(current)
				{
					if (current.value == "$default_value")
					{
						current.value = '';
					}
				}
			|;
			my $on_blur_js = qq|
				function ${name}_onblur(current)
				{
					if (current.value == '')
					{
						current.value = "$default_value";
					}
				}
			|;
			$element_input->{&PARAM_ONFOCUS} .= "${name}_onfocus(this);";
			$element_input->{&PARAM_ONBLUR}  .= "${name}_onblur(this);";
			$self->add(
				type => &TAG_JS,
				body => $on_blur_js . "\n" . $on_focus_js
			);
		}
	} elsif (&INPUT_TYPES_MAP->{$type}->{type} eq 'link') {
		$element_input = $self->add(
			type           => &TAG_A,
			body           => $name,
			&PARAM_LINK    => $value,
			&PARAM_CLASS   => 'param_normal',
			%{$tag_params}
		);
		if ($command){
			$element_input->{&PARAM_ONCLICK} = "${name}_onclick();";
			$self->add(
				type => &TAG_JS,
				body => qq|
					function ${name}_onclick()
					{
						$command
					}
				|
			);
		}
	} elsif (&INPUT_TYPES_MAP->{$type}->{type} eq 'color') {

		$self->add_head_src(
			src => '/jscolor/jscolor.js'
		);

		$element_input = $self->add(
			type         => &TAG_INPUT,
			&PARAM_ID    => $name,
			&PARAM_NAME  => $name,
			&PARAM_TYPE  => $type,
			&PARAM_VALUE => $value,
			&PARAM_CLASS => q|color {pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}|,
			%{$tag_params}
		);
	} else {
		$element_input = $self->add(
			type         => &TAG_INPUT,
			&PARAM_ID    => $name,
			&PARAM_NAME  => $name,
			&PARAM_TYPE  => $type,
			&PARAM_VALUE => $value,
			%{$tag_params}
		);
	}

	return $element_input;
}

sub add_head_src {
	my $self = shift;
	my %h    = @_;

	my $src  = $h{src};

	my $root = $self->get_root();

	my $tag_head_finder = Homyaki::Visiteur::TagFinder->new(
		params => {
			type => &TAG_HEAD
		}
	);

	$root->visit($tag_head_finder);

	my $tag_head = $tag_head_finder->{tag};

	my $tag_src_finder = Homyaki::Visiteur::TagFinder->new(
		params => {
			&PARAM_SRC => $src
		}
	);

	$tag_head->visit($tag_src_finder);

	unless ($tag_src_finder->{tag}) {

		$tag_head->add(
			type => &TAG_JS,
			&PARAM_SRC  => $src,
			&PARAM_TYPE => 'text/javascript',
			body => ' ',
		);
	}
}

sub add_list_elements {
	my $self = shift;
	my %h    = @_;

	my $list  = $h{list};
	my $value = $h{value};

	if (ref($list) eq 'ARRAY' && scalar(@{$list}) > 0) {

		foreach my $item (@{$list}){
			my $tag_item = $self->add(
				type            => &TAG_SELECT_OPTION,
				body            => $item->{name},
				&PARAM_VALUE    => $item->{id},
				&PARAM_SELECTED => $item->{id} eq $value ? 'selected' : undef,
			);
			$tag_item->{&PARAM_STYLE} = "background-color:#$item->{color}"
				if $item->{color};
		}
	}
	
}


sub add_error_list {
	my $self = shift;
	my %h    = @_;

	my $errors = $h{errors};

	$self->add(
		type         => &TAG_H1,
		body         => 'Error:<br>',
		&PARAM_CLASS => 'param_error',
	);

	my $list = $self->add(type => &TAG_LIST);
	
	foreach my $error_type (keys %{$errors}){
		foreach my $error (@{$errors->{$error_type}->{errors}}){
			$self->add(
				type         => &TAG_LIST_ITEM,
				body         => ($error_type ne 'base' ? ($errors->{$error_type}->{param_name} . ': ') : '') . $error,
				&PARAM_CLASS => 'param_error',
			);
		}
	}

	$self->{body} = '<hr>';
	return $list;
}

sub add_login_link {
	my $self = shift;
	my %h    = @_;

	my $user      = $h{user};
	my $body      = $h{body};
	my $interface = $h{interface};
	my $auth      = $h{auth};
	my $params    = $h{params};

        my $permissions = $user->{permissions};
        my $login_uri = "/engine/?interface=$interface&form=$auth";


        if (ref($permissions) eq 'ARRAY' && grep {$_ eq 'writer'} @{$permissions}){
                my $form_param = $body->add_form_element(
                        name   => 'current_user',
                        type   => &INPUT_TYPE_LABEL,
                        value  => $user->{login},
                );
        } else {
                my $form_param = $body->add_form_element(
                        name    => 'login',
                        type    => &INPUT_TYPE_LINK,
                        value   => '#',
                        command => qq{
                                document.getElementById('current_action').value = 'view';
                                document.getElementById('main_form').action = '$login_uri';
                                document.getElementById('main_form').submit();
                        },
                );
        }

        $body->add_form_element(
                name         => 'current_data_uri',
                type         => &INPUT_TYPE_HIDDEN,
                value        => $params->{current_uri},
        );
}
######################################################################
## OLD FUNCTIONS
######################################################################

sub add_menu_column {
	my $self = shift;

	return $self->SUPER::add(
		type         => &TAG_COLUMN,
		&PARAM_WIDTH => '30%',
		&PARAM_STYLE => 'padding-right: 10px; border-right: 1px solid gray; vertical-align: top;',
	);
}

sub add_menu_body {
	my $self = shift;

	return $self->SUPER::add(
		type         => &TAG_LIST,
		&PARAM_STYLE => 'list-style-type:none; padding:0px; margin:0px;',
	);
}

sub add_menu_item {
	my $self = shift;
	my %h    = @_;

	my $current = $h{current};
	my $header  = $h{header};
	my $link    = $h{'link'};

	my $item_tag;

	if ($current){
		$item_tag = $self->add(
			type         => &TAG_LIST_ITEM,
			body         => $header,
			&PARAM_CLASS => 'current',
			&PARAM_STYLE => 'background-repeat:no-repeat; background-position:0px 5px; padding-left:14px;',
		);
	} else {
		my $list_item_tag = $self->add(
			type         => &TAG_LIST_ITEM,
		);
		$item_tag = $list_item_tag->add(
			type         => &TAG_LINK,
			body         => $header,
			&PARAM_LINK  => $link,
			&PARAM_STYLE => 'background-repeat:no-repeat; background-position:0px 5px; padding-left:14px; cursor: pointer;',
		);
	}

	return $item_tag;
}

sub add_form_column {
	my $self = shift;

	return $self->SUPER::add(
		type         => &TAG_COLUMN,
		&PARAM_STYLE => 'padding: 0 10px; vertical-align: top;',
	);
}


sub get_list_data_js {
	my $self = shift;
	my %h    = @_;

	my $child_type = $h{child_type};
	my $child_name = $h{child_name};
	my $child_list = $h{child_list};

	my $parrent_name  = $h{parrent_name};
	my $parrent_list  = $h{parrent_list};

	my $body_js = qq{var ${child_name}List = new Array();\n};

	if ( &INPUT_TYPES_MAP->{$child_type}->{type} eq 'list') {
		foreach my $parrent (@{$parrent_list}) {
			my $parrent_id    = $parrent->{id};
			my $child_list_js = join(",\n", map {'new Array(' . $_->{id} . ',"' . $_->{name} . '")'} grep {$_->{parrent_id} eq $parrent_id} @{$child_list});
	
			$body_js .= qq{${child_name}List[$parrent_id] = new Array($child_list_js);\n};
		}		

		$body_js .= qq{
			function onChange${parrent_name}_$child_name(${parrent_name}List){
		        var ${child_name} = document.getElementById('${child_name}');
				while (${child_name}.options.length > 1) {
					${child_name}.remove(1);
				}
	
				for (currentElement in ${child_name}List[${parrent_name}List.value]) {
					var ${child_name}Element = document.createElement('option');
					${child_name}Element.value = ${child_name}List[${parrent_name}List.value][currentElement][0];
					${child_name}Element.text  = ${child_name}List[${parrent_name}List.value][currentElement][1];
					try {
						${child_name}.add(${child_name}Element, null);
					} catch(ex) {
						${child_name}.add(${child_name}Element);
					}
				}
			}
		};
	} elsif (&INPUT_TYPES_MAP->{$child_type}->{type} eq 'label_total') {
		$body_js .= qq{${child_name}List[0] = new Array(0,0);\n};

		foreach my $parrent (@{$parrent_list}) {
			my $parrent_id  = $parrent->{id};
			my ($child_value) = grep {$_->{parrent_id} eq $parrent_id} @{$child_list};
	
			$body_js .= qq{${child_name}List[$parrent_id] = new Array($child_value->{value}->{rub},$child_value->{value}->{cur});\n};
		}		

		$body_js .= qq{
			function onChange${parrent_name}_$child_name(${parrent_name}List){
		        var ${child_name}_rub_label = document.getElementById('${child_name}_rub_label');
		        var ${child_name}_cur_label = document.getElementById('${child_name}_cur_label');
		        var ${child_name}_rub = document.getElementById('${child_name}_rub');
		        var ${child_name}_cur = document.getElementById('${child_name}_cur');
	
	
				${child_name}_rub_label.innerHTML = ${child_name}List[${parrent_name}List.value][0];
				${child_name}_cur_label.innerHTML = ${child_name}List[${parrent_name}List.value][1];
				${child_name}_rub.value = ${child_name}List[${parrent_name}List.value][0];
				${child_name}_cur.value = ${child_name}List[${parrent_name}List.value][1];
	
			}
		};
	} elsif (
		&INPUT_TYPES_MAP->{$child_type}->{type} eq 'text'
		|| &INPUT_TYPES_MAP->{$child_type}->{type} eq 'number'
		|| &INPUT_TYPES_MAP->{$child_type}->{type} eq 'money'
	) {
		$body_js .= qq{${child_name}List[0] = '';\n};

		foreach my $parrent (@{$parrent_list}) {
			my $parrent_id  = $parrent->{id};
			my ($child_value) = grep {$_->{parrent_id} eq $parrent_id} @{$child_list};
	
			$body_js .= qq{${child_name}List[$parrent_id] = '$child_value->{value}';\n};
		}		

		$body_js .= qq{
			function onChange${parrent_name}_$child_name(${parrent_name}List){
		        var ${child_name} = document.getElementById('${child_name}');
	
				${child_name}.value = ${child_name}List[${parrent_name}List.value];
			}
		};
	}

	return $body_js;
}

sub add_list_data_js {
	my $self = shift;
	my %h    = @_;

	my $child_type = $h{child_type};
	my $child_name = $h{child_name};
	my $child_list = $h{child_list};

	my $parrent_name  = $h{parrent_name};
	my $parrent_list  = $h{parrent_list};

	my $element_script = $self->add(
		type => &TAG_JS,
		body => $self->get_list_data_js(
			child_name   => $child_name,
			child_list   => $child_list,
			child_type   => $child_type,
			parrent_name => $parrent_name,
			parrent_list => $parrent_list
		)
	);

	return $element_script;
}

1;
