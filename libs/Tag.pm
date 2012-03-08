package Homyaki::Tag;

use strict;

use Exporter;

use constant TAG_A             => 'a';
use constant TAG_IMG           => 'img';
use constant TAG_H1            => 'h1';
use constant TAG_JS            => 'script';
use constant TAG_DIV           => 'div';
use constant TAG_ROW           => 'tr';
use constant TAG_LINK          => 'link';
use constant TAG_LIST          => 'ol';
use constant TAG_FORM          => 'form';
use constant TAG_SPAN          => 'span';
use constant TAG_HEAD          => 'head';
use constant TAG_HTML          => 'html';
use constant TAG_META          => 'meta';
use constant TAG_BODY          => 'body';
use constant TAG_TITLE         => 'title';
use constant TAG_NOBR          => 'nobr';
use constant TAG_LABEL         => 'label';
use constant TAG_INPUT         => 'input';
use constant TAG_TABLE         => 'table';
use constant TAG_COLUMN        => 'td';
use constant TAG_SELECT        => 'select';
use constant TAG_TEXTAREA      => 'textarea';
use constant TAG_LIST_ITEM     => 'li';
use constant TAG_SELECT_OPTION => 'option'; 

use constant NOBR_TAGS => {
	&TAG_TEXTAREA => 1,
};

use constant SUPPORTED_TAGS => [
	&TAG_A,
	&TAG_H1,
	&TAG_JS,
	&TAG_IMG,
	&TAG_DIV,
	&TAG_ROW,
	&TAG_LINK, 
	&TAG_LIST, 
	&TAG_FORM,
	&TAG_SPAN,
	&TAG_HEAD,
	&TAG_HTML,
	&TAG_META,
	&TAG_BODY,
	&TAG_TITLE,
	&TAG_NOBR,
	&TAG_LABEL,
	&TAG_TABLE,
	&TAG_INPUT, 
	&TAG_COLUMN,
	&TAG_SELECT,
	&TAG_TEXTAREA,
	&TAG_LIST_ITEM,
	&TAG_SELECT_OPTION, 
];

use constant PARAM_ID               => 'p_id';
use constant PARAM_FOR              => 'p_for';
use constant PARAM_SRC              => 'p_src';
use constant PARAM_NAME             => 'p_name';
use constant PARAM_LINK             => 'p_href';
use constant PARAM_TYPE             => 'p_type';
use constant PARAM_VALUE            => 'p_value';
use constant PARAM_WIDTH            => 'p_width';
use constant PARAM_HEIGHT           => 'p_height';
use constant PARAM_STYLE            => 'p_style';
use constant PARAM_CLASS            => 'p_class';
use constant PARAM_METHOD           => 'p_method';
use constant PARAM_SUBMIT           => 'p_submit';
use constant PARAM_ACTION           => 'p_action';
use constant PARAM_COLSPAN          => 'p_colspan';
use constant PARAM_ENCTYPE          => 'p_enctype';
use constant PARAM_SELECTED         => 'p_selected';
use constant PARAM_ACTION_ON_CHANGE => 'p_onChange';
use constant PARAM_ONCLICK          => 'p_onClick';
use constant PARAM_ONFOCUS          => 'p_onFocus';
use constant PARAM_ONBLUR           => 'p_onBlur';
use constant PARAM_HTTP_EQUIV       => 'p_http-equiv';
use constant PARAM_CONTENT          => 'p_content';
use constant PARAM_REL              => 'p_rel';
use constant PARAM_HREF             => 'p_href';
use constant PARAM_COLS             => 'p_cols';
use constant PARAM_ROWS             => 'p_rows';
use constant PARAM_READONLY         => 'p_readonly';
use constant PARAM_FRAME            => 'p_frame';
use constant PARAM_SIZE             => 'p_size';
use constant PARAM_ONLOAD           => 'p_onload';
use constant PARAM_ONUNLOAD         => 'p_onunload';
use constant PARAM_TITLE            => 'p_title';
use constant PARAM_CHECKED          => 'p_checked';

use constant SUPPORTED_PARAMETERS_MAP => {
	&PARAM_ID               => 'id',
	&PARAM_FOR              => 'for', 
	&PARAM_SRC              => 'src', 
	&PARAM_NAME             => 'name',
	&PARAM_LINK             => 'href',
	&PARAM_TYPE             => 'type',
	&PARAM_VALUE            => 'value', 
	&PARAM_WIDTH            => 'width',
	&PARAM_HEIGHT           => 'height',
	&PARAM_STYLE            => 'style',
	&PARAM_CLASS            => 'class',
	&PARAM_METHOD           => 'method',
	&PARAM_SUBMIT           => 'submit',
	&PARAM_ACTION           => 'action',
	&PARAM_COLSPAN          => 'colspan',
	&PARAM_ENCTYPE          => 'enctype',
	&PARAM_SELECTED         => 'selected',
	&PARAM_ACTION_ON_CHANGE => 'onChange',
	&PARAM_ONCLICK          => 'onClick',
	&PARAM_HTTP_EQUIV       => 'http-equiv',
	&PARAM_CONTENT          => 'content',
	&PARAM_REL              => 'rel',
	&PARAM_HREF             => 'href',
	&PARAM_COLS             => 'cols',
	&PARAM_ROWS             => 'rows',
	&PARAM_READONLY         => 'readonly',
	&PARAM_FRAME            => 'frame',
	&PARAM_ONFOCUS          => 'onFocus',
	&PARAM_ONBLUR           => 'onBlur',
	&PARAM_SIZE             => 'size',
	&PARAM_ONLOAD           => 'onLoad',
	&PARAM_ONUNLOAD         => 'onUnload',
	&PARAM_TITLE            => 'title',
	&PARAM_CHECKED          => 'checked',
};

@Homyaki::Tag::ISA = qw(Exporter);

@Homyaki::Tag::EXPORT = qw(
	&TAG_A
	&TAG_H1
	&TAG_JS
	&TAG_IMG
	&TAG_DIV
	&TAG_ROW
	&TAG_LINK
	&TAG_LIST
	&TAG_FORM
	&TAG_SPAN
	&TAG_HEAD
	&TAG_HTML
	&TAG_META
	&TAG_BODY
	&TAG_TITLE
	&TAG_NOBR
	&TAG_LABEL
	&TAG_TABLE
	&TAG_INPUT
	&TAG_COLUMN
	&TAG_SELECT
	&TAG_TEXTAREA
	&TAG_LIST_ITEM
	&TAG_SELECT_OPTION

	&SUPPORTED_TAGS

	&PARAM_ID
	&PARAM_FOR
	&PARAM_SRC
	&PARAM_NAME
	&PARAM_TYPE
	&PARAM_LINK
	&PARAM_VALUE
	&PARAM_WIDTH
	&PARAM_HEIGHT
	&PARAM_STYLE
	&PARAM_CLASS
	&PARAM_METHOD
	&PARAM_SUBMIT
	&PARAM_ACTION
	&PARAM_COLSPAN
	&PARAM_ENCTYPE
	&PARAM_SELECTED
	&PARAM_ACTION_ON_CHANGE
	&PARAM_HTTP_EQUIV
	&PARAM_CONTENT
	&PARAM_REL
	&PARAM_HREF
	&PARAM_ONCLICK
	&PARAM_ONFOCUS
	&PARAM_ONBLUR
	&PARAM_COLS
	&PARAM_ROWS
	&PARAM_READONLY
	&PARAM_FRAME
	&PARAM_SIZE
	&PARAM_ONLOAD
	&PARAM_ONUNLOAD
	&PARAM_TITLE
	&PARAM_CHECKED

	&SUPPORTED_PARAMETERS_MAP
);

sub new {
	my $this = shift;

	my %h = @_;

	my $type = $h{type};
	my $body = $h{body};
	my $parrent = $h{parrent};

	my $self = {};

	if (grep {$_ eq $type} @{&SUPPORTED_TAGS}) {
		$self->{type}  = $type;
		$self->{body}  = $body;
		$self->{child} = [];
		$self->{parrent} = $parrent;

		my $params = {};
		map {$params->{$_} = $h{$_}} keys %{&SUPPORTED_PARAMETERS_MAP};

		my $class = ref($this) || $this;
		bless $self, $class;
		map {$self->{$_} = $params->{$_}} keys %{$params};
	}

	return $self;
}

sub add {
	my $self = shift;
	my %h = @_;

	my $type = $h{type};
	my $body = $h{body};
	my $tags = $h{tags};
	my $tag  = $h{tag};

	my $new_tag;
	if (grep {$_ eq $type} @{&SUPPORTED_TAGS}) {

		my $params = {};
		$params->{type} = $type;
		$params->{body} = $body;
		$params->{parrent} = $self;
		map {$params->{$_} = $h{$_}} keys %{&SUPPORTED_PARAMETERS_MAP};

		my $class = ref($self);
		$new_tag = $class->new(%{$params});

		push (@{$self->{child}}, $new_tag);
	}

	if (ref($tag) eq 'Scoring::Tag') {
		push (@{$self->{child}}, $tag);
	}

	if (ref($tags) eq 'ARRAY') {
		foreach my $current_tag (@{$tags}){
			if (ref($current_tag) eq 'Scoring::Tag') {
				push (@{$self->{child}}, $current_tag);
			}
		}
	}

	return $new_tag;
}


sub visit {
	my $self    = shift;
	my $vizitor = shift;

	if (ref($self->{child}) eq 'ARRAY'){
		foreach my $child_tag (@{$self->{child}}){
			$child_tag->visit($vizitor);
		}
	} elsif (ref($self->{child}) eq 'Scoring::Tag'){
		$self->{child}->visit($vizitor);
	}

	my $result = $vizitor->execute(
		tag    => $self,
	);
}

sub to_str {
	my $self = shift;

	my $tag_str = "\n<$self->{type}";

	foreach my $param_name (keys %{&SUPPORTED_PARAMETERS_MAP}) {
		$tag_str .= ' ' . &SUPPORTED_PARAMETERS_MAP->{$param_name} . '="' . $self->{$param_name} . '"' if defined($self->{$param_name});
	}

	if (
		(
			ref($self->{child}) eq 'ARRAY'
			&& scalar(@{$self->{child}}) > 0
		)
		|| ref($self->{child}) eq 'Scoring::Tag'
		|| $self->{body}
	) {
		$tag_str .= ">\n";
		if ($self->{child}) {
			if (ref($self->{child}) eq 'ARRAY'){
				foreach my $child_tag (@{$self->{child}}){
					$tag_str .= $child_tag->to_str();
				}
			} elsif (ref($self->{child}) eq 'Scoring::Tag'){
				$tag_str .= $self->{child}->to_str();
			}
		} 
		if ($self->{body}) {
			$tag_str .= $self->{body};
		}

		$tag_str .= (&NOBR_TAGS->{$self->{type}} ? '' : "\n") . "</$self->{type}>";
	} else {
		$tag_str .= '/>';
	}

	return $tag_str;
}

sub get_root {
	my $self = shift;

	my $root = $self;
	while ($root->{parrent}){
		$root = $root->{parrent};
	}

	return $root;
}

1;
