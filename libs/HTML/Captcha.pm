package Homyaki::HTML::Captcha;

use strict;

use Data::Dumper;

use Homyaki::Tag;
use Homyaki::HTML;
use base 'Homyaki::HTML';

#use Authen::Captcha;
use Digest::MD5 qw( md5_hex );

#my $cap_data_folder = 'tmp/captcha'; # Здесь будет находиться текстовый файл с кодами CAPTCHA
#my $cap_out_folder = 'tmp/outputcaptcha'; # Тут расположены проверочные изображения CAPTCHA
#my $cap_length = 4; # Из скольки символов будет состоять капча
#my $captcha = Authen::Captcha->new( data_folder => $cap_data_folder, output_folder => $cap_out_folder, );
#my $md5sum = $captcha->generate_code($cap_length);

use Homyaki::Logger;
use Homyaki::HTML::Constants;

use constant CAPTCHA_IMAGE_PATH => '/var/www/captcha/';
use constant CAPTCHA_TEXT_PATH  => '/var/www/captcha/';


# Реализация под библиотеку Image::Magick для perl - dimio (www.dimio.org).
# 27.09.2009

use Image::Magick;


sub add_captcha_request {
        my $self = shift;
        my %h    = @_;

        my $permissions = $h{permissions};
        my $body_tag    = $h{body_tag};
        my $errors      = $h{errors};


	my $captcha_data = create_captcha_image();


	my $form_param;

	if (!$captcha_data->{error}){

	        $form_param = $body_tag->add_form_element(
        	        name   => 'captcha_image',
                	type   => &INPUT_TYPE_IMAGE,
	                value  => '/captcha/' . $captcha_data->{file_name},
			error  => $errors->{captcha_text},
#        	        'link' => '/',
#                	&PARAM_HEIGHT => 512
	        );

	        $form_param = $body_tag->add_form_element(
			name   => "captcha_text",
			type   => &INPUT_TYPE_TEXT,
			error  => $errors->{captcha_text},
			&PARAM_SIZE => 9,
#			value  => $list_field->{header},
		);

                $form_param = $body_tag->add_form_element(
                        name   => "captcha_digest",
                        type   => &INPUT_TYPE_HIDDEN,
			value  => $captcha_data->{cap_digest},
                );
	} else {
		Homyaki::Logger::print_log('Homyaki::HTML::Captcha Error:' . $captcha_data->{error});
	}
	return $form_param;
}

sub create_captcha_image {


	my $num1 = int(rand(11))+int(rand(3));
	my $num2 = int(rand(8))+int(rand(4));
	my $sum = $num1+$num2;
	my $cap_string = $num1.'+'.$num2.'=';
	my $cap_digest = md5_hex($sum+rand(100)+rand(50));

	my $file_name   =  time() . '.png';
	my $file_path   = &CAPTCHA_IMAGE_PATH . $file_name;


	my $error = '';

	my $font = 'times.ttf';
	my $pointsize = 80;

	my $image = new Image::Magick;

	# 1. Создаём поле 300x100 белого цвета.
	$image->Set(size => '300x100');
	$image->ReadImage('xc:white');

	# 2. Печатаем черным с антиалиасингом
	$image->Set(
			type 		=> 'TrueColor',
			antialias	=>	'True',
			fill		=>	'#ff9900',
			# строку STRING шрифтом $font размером $pointsize
			font		=>	$font,
			pointsize	=>	$pointsize,
	);

	$image->Draw(
			primitive	=>	'text',
			points		=>	'40,90', # ориентация строки текста внутри картинки
			text		=>	$cap_string, # что печатаем
	);

	# 3. Подвинуть центр влево на 100 точек +случайная флуктуация
	$image->Extent(
			geometry	=>	'400x120', # меняем размер картинки
	);
	$image->Roll(
			x			=>	101+int(rand(4)),
	);

	# 4. Первый swirl на случайный угол (от 37 до 51)
	$image->Swirl(
			degrees		=>	int(rand(14))+37,
	);

	# 5. Подвинуть центр вправо на 200 точек, тоже со случайной флуктуацией
	$image->Extent(
			geometry	=>	'600x140', # меняем размер картинки
	);

	$image->Roll(
			x			=>	3-int(rand(4)),
	);

	# 6. Второй поворот (от 20 до 35)
	$image->Swirl(
			degrees		=>	int(rand(15))+20,,
	);

	# 7. Окончательная обработка и вывод
	$image->Crop('300x100+100+17');
	$image->Resize('100x30');

	open(IMAGE,'>',$file_path) or $error = $!;
		$image->Write(file=>\*IMAGE, filename=>$file_path);
	close(IMAGE);

        open(TEXT,'>',&CAPTCHA_TEXT_PATH . $cap_digest) or $error = $!;
                print TEXT $sum;
        close(TEXT);

	return {
		file_name  => $file_name,
		cap_string => $cap_string,
		cap_digest => $cap_digest,
		error      => $error
	};
}

sub get_captcha_text {
	my $self = shift;
	my $cap_digest = shift;

	my $error;

        open(TEXT,'<',&CAPTCHA_TEXT_PATH . $cap_digest) or $error = $!;
	my $text = <TEXT>;
        close(TEXT);

	if ($error){
		Homyaki::Logger::print_log('Homyaki::HTML::Captcha Error: ' . $error . '(' .&CAPTCHA_TEXT_PATH . $cap_digest. ')');
	}
	return $text;
}
1;
