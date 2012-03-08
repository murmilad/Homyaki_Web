package Homyaki::Apache_Log;

use strict;

use DateTime::Format::HTTP;
use HTTPD::Log::Filter;
use File::Package;
use Storable qw(freeze thaw);
use DateTime;
use IO::File;
use Geo::IP;

use Data::Dumper;

use constant GEO_DATA_BUFFER_PATH => '/home/alex/.geodata_buffer.bin';

use constant HTTP_LOG_PATH          => '/var/log/apache2/';
use constant HTTP_LOG_PATH_BACKUP   => '/var/log/apache2/backup/';
use constant GEOIP_CITY_PATH => '/usr/share/GeoIP/GeoLiteCity.dat';

use constant INTERFACE_MASK_MAP => [
	'GET\s+/engine(/)?\?interface=gallery&(amp;)?form=data&(amp;)?image=acoll_\d+'
];

use constant ROBOTS_MASK_MAP => [
	'GET\s+/robots\.txt',
	'GET\s+/sitemap\.xml',
];

use constant ATTAK_MASK_MAP => [
	'Made by ZmEu @ WhiteHat Team - www.whitehat.ro',
	'GET //phpmyadmin/',
	'GET //phpMyAdmin/',
	'GET //pma/',
	'GET //dbadmin/',
	'GET //myadmin/',
	'GET //phppgadmin/',
	'GET //PMA/',
	'GET //admin/',
	'GET //MyAdmin/',
	'Morfeus Fucking Scanner',
	'GET /user/soapCalle.bs',
	'/awcuser/cgi-bin/vcs?xsl=;id',
	'GET /webadmin/main.php',
	'GET /phpadmin/main.php',
	'GET /myadmin/main.php',
	'GET /mysql/main.php',
	'GET /admin/main.php',
	'GET /pma/main.php',
	'GET /PMA/main.php',
	'GET /db/main.php',
	'GET /phpMyAdmin/main.php',
	'GET /phpmyadmin/main.php',
	'GET /admin/main.php',
	'GET /w00tw00t.at.ISC.SANS.DFind:',
#	'Python-urllib/2\.5',
	'GET /webdav/',
	'GET //phpMyAdmin-2.6.4-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.3-pl1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.3/scripts/setup.php',
	'GET //phpMyAdmin-2.6.3-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.3/scripts/setup.php',
	'GET //phpMyAdmin-2.6.2-pl1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.2-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.2-beta1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.2-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.1-pl3/scripts/setup.php',
	'GET //phpMyAdmin-2.6.1-pl2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.1-pl1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.1-rc2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.1-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-pl3/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-pl2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-pl1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-rc3/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-rc2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-beta2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-beta1/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-alpha2/scripts/setup.php',
	'GET //phpMyAdmin-2.6.0-alpha/scripts/setup.php',
	'GET //phpMyAdmin-2.5.7-pl1/scripts/setup.php',
	'GET //phpMyAdmin-2.5.7/scripts/setup.php',
	'GET //phpMyAdmin-2.5.6/scripts/setup.php',
	'GET //phpMyAdmin-2.5.6-rc2/scripts/setup.php',
	'GET //phpMyAdmin-2.5.6-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.5.5-pl1/scripts/setup.php',
	'GET //phpMyAdmin-2.5.5/scripts/setup.php',
	'GET //phpMyAdmin-2.5.5-rc2/scripts/setup.php',
	'GET //phpMyAdmin-2.5.5-rc1/scripts/setup.php',
	'GET //phpMyAdmin-2.5.4/scripts/setup.php',
	'GET //phpMyAdmin-2.5.1/scripts/setup.php',
	'GET //phpMyAdmin-2.2.6/scripts/setup.php',
	'GET //phpMyAdmin-2.2.3/scripts/setup.php',
	'GET //php-my-admin/scripts/setup.php',
	'GET //phpMyAdmin-2/scripts/setup.php',
	'GET //phpMyAdmin/scripts/setup.php',
	'GET //phpmyadmin/scripts/setup.php',
	'GET //websql/scripts/setup.php',
	'GET //php-my-admin/scripts/setup.php',
	'GET //web/scripts/setup.php',
	'GET //xampp/phpmyadmin/scripts/setup.php',
	'GET //web/phpMyAdmin/scripts/setup.php',
	'GET //pma/scripts/setup.php',
	'GET //phpmyadmin2/scripts/setup.php',
	'GET //phpmyadmin1/scripts/setup.php',
	'GET //phpmyadmin/scripts/setup.php',
	'GET //phpMyAdmin/scripts/setup.php',
	'GET //phpadmin/scripts/setup.php',
	'GET //typo3/phpmyadmin/scripts/setup.php',
	'GET //mysqladmin/scripts/setup.php',
	'GET //mysql/scripts/setup.php',
	'GET //myadmin/scripts/setup.php',
	'GET //dbadmin/scripts/setup.php',
	'GET //db/scripts/setup.php',
	'GET //admin/phpmyadmin/scripts/setup.php',
	'GET //admin/pma/scripts/setup.php',
	'GET //admin/scripts/setup.php',
	'GET //scripts/setup.php',
	'GET /V20xRmRRPT0K',
	'GET /php5/scripts/setup.php',
	'GET /admin/scripts/setup.php',
	'GET /php/scripts/setup.php',
	'GET /scripts/setup.php',
	'GET /mysql/scripts/setup.php',
	'GET /pma/scripts/setup.php',
	'GET /myadmin/scripts/setup.php',
	'GET /phpMyAdmin/scripts/setup.php',
	'GET /phpmyadmin/scripts/setup.php',

];

use Exporter;
use vars qw(@ISA @EXPORT $VERSION);

@ISA = qw(Exporter);

@EXPORT = qw(
	&HTTP_LOG_PATH
	&HTTP_LOG_PATH_BACKUP
	&GEOIP_CITY_PATH
);

sub current_date {

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
		= localtime(time);

	$year +=1900; $mon +=1;
	my $time = "$year-$mon-$mday $hour:$min:$sec";

	return $time;
}

sub get_hosts_from_file {
	my %h = @_;

	my $hosts = $h{hosts};
	my $path  = $h{path};
	my $feed  = $h{feed};
	my $hlf   = $h{hlf};
                             
	open $feed, "<$path" || print "error $@";

	while( <$feed> ) {
		next if $_ =~ /\] ".{0,3}\\x[0-9A-Fa-f]{2}/;
		next if $_ =~ /\] "(-"|--|\w{1,2}")/;

		eval {
			next unless $hlf->filter( $_ );
		};

		print "Error log format: ($_)  $@\n" if $@;

		my $date = DateTime::Format::HTTP->parse_datetime($hlf->date);

		unless ($hosts->{$hlf->host}->{requests}) {
			$hosts->{$hlf->host}->{requests} = [];
		}

		push (@{$hosts->{$hlf->host}->{requests}}, $hlf->request);

		$hosts->{$hlf->host}->{count}++;
		$hosts->{$hlf->host}->{$date->dmy()}->{count}++;

		if ($hlf->request =~ /GET\s+\/images\/big\/(\/)?\w+\.jpg/i){
			$hosts->{$hlf->host}->{images_count}++;
			$hosts->{$hlf->host}->{$date->dmy()}->{images_count}++;
		}

		if (grep {$hlf->request =~ /$_/i} @{&INTERFACE_MASK_MAP}){
			$hosts->{$hlf->host}->{engine_count}++;
			$hosts->{$hlf->host}->{$date->dmy()}->{engine_count}++;
		}

		if (grep {$hlf->request =~ /$_/i} @{&ROBOTS_MASK_MAP}){
			$hosts->{$hlf->host}->{sitemap_count}++;
			$hosts->{$hlf->host}->{$date->dmy()}->{sitemap_count}++;
		}

		if (grep {my $mask = escape_request($_); $hlf->request =~ /$mask/i;} @{&ATTAK_MASK_MAP}){
			$hosts->{$hlf->host}->{attak_count}++;
			$hosts->{$hlf->host}->{$date->dmy()}->{attak_count}++;
		}

		unless ($hosts->{$hlf->host}->{date}) {
			$hosts->{$hlf->host}->{date} = DateTime->from_epoch(epoch => 0);
		}
		if ($hosts->{$hlf->host}->{date}->epoch() < $date->epoch()) {
			$hosts->{$hlf->host}->{date} = $date;
		}

		unless ($hosts->{earlest_date}) {
			$hosts->{earlest_date} = $date;
		}
		if ($hosts->{earlest_date}->epoch() > $date->epoch()) {
			$hosts->{earlest_date} = $date;
		}

	}

	close $feed;

	return $hosts;

}
sub get_log_data {
	my $apache_path = shift;
	my $old_hosts   = shift;

	my $hlf = HTTPD::Log::Filter->new(

	capture => [ qw(
			host
			ident
			authexclude
			date
			request
			status
			bytes
		) ]
	);

	my $hosts = {};


	opendir(my $dh, $apache_path) || die "can't opend " . $apache_path . ": $!";
	my @logs_gz = grep { /^access\.log(\.n\d+)?\.\d+\.gz/i && -f $apache_path . "/$_" } readdir($dh);
	closedir $dh;

	File::Package->load_package('Tie::Gzip');
	tie *GZIP, 'Tie::Gzip';
	my $gzip = \*GZIP;

	my $zipped_hosts = $old_hosts->{zipped_hosts} || {};
	my $zipped_host_files = {};
	foreach my $log_file (@logs_gz) {
#		print Dumper($old_hosts->{zipped_host_files});
		if (!$old_hosts->{zipped_host_files}->{$log_file}){
			get_hosts_from_file(
				hosts => $zipped_hosts,
				path  => $apache_path . '/' . $log_file,
				feed  => $gzip,
				hlf   => $hlf
			);
#		print " get_hosts_from_file zip $log_file\n";
		} else {
#		print " get_hosts_from_file buffer $log_file\n";
		}
	

		$zipped_host_files->{$log_file} = 1;
	}
	$hosts = $zipped_hosts;

	$hosts->{zipped_hosts}      = thaw(freeze($zipped_hosts));
	$hosts->{zipped_host_files} = $zipped_host_files;
	

	my $txt = new IO::File;

	opendir(my $dh, $apache_path) || die "can't opend " . $apache_path . ": $!";
	my @logs = grep { /^access\.log(\.n\d+)?(\.\d+)?$/i && -f $apache_path . "/$_" } readdir($dh);
	closedir $dh;

	foreach my $log_file (@logs) {
		get_hosts_from_file(
			hosts => $hosts,
			path  => $apache_path . "/$log_file",
			hlf   => $hlf,
			feed  => $txt
		);
#		print " get_hosts_from_file log $log_file\n";
	}
	return $hosts;
}

sub add_geo_data {
	my $hosts     = shift;
	my $old_hosts = shift;

	my $geo_data = Geo::IP->open(&GEOIP_CITY_PATH, GEOIP_STANDARD);

	if ($geo_data) {

		foreach my $host (grep {$_ =~ /\d+\.\d+\.\d+\.\d+/} keys %$hosts){
			$hosts->{$host}->{maxmind_link} = qq{http://www.maxmind.com/app/locate_demo_ip?ips=$host\%09};
			if (!$old_hosts->{$host}->{geo_record_exist}) {
				my $geo_record = $geo_data->record_by_name($host);
#				my $hosts->{$host}->{organization} = $geo_data->org_by_addr($host);

#				print " get geo data $host\n";
				if ($geo_record) {
					$hosts->{$host}->{country_code} = $geo_record->country_code();
					$hosts->{$host}->{country_name} = $geo_record->country_name() || '&nbsp;';
					$hosts->{$host}->{region}       = $geo_record->region();
					$hosts->{$host}->{region_name}  = $geo_record->region_name()  || '&nbsp;';
					$hosts->{$host}->{city}         = $geo_record->city()         || '&nbsp;';
					$hosts->{$host}->{postal_code}  = $geo_record->postal_code();
					$hosts->{$host}->{latitude}     = $geo_record->latitude();
					$hosts->{$host}->{longitude}    = $geo_record->longitude();
					$hosts->{$host}->{geo_record_exist} = 1;
				} else {
					$hosts->{$host}->{country_name} = '[unknown]';
					$hosts->{$host}->{city}         = '&nbsp;';
					$hosts->{$host}->{region_name}  = '&nbsp;';
				}
			} else {
#				print " get buffer data $host\n";
				$hosts->{$host}->{maxmind_link} = $old_hosts->{$host}->{maxmind_link};
				$hosts->{$host}->{country_code} = $old_hosts->{$host}->{country_code};
				$hosts->{$host}->{country_name} = $old_hosts->{$host}->{country_name};
                                $hosts->{$host}->{region}       = $old_hosts->{$host}->{region};
                                $hosts->{$host}->{region_name}  = $old_hosts->{$host}->{region_name};
                                $hosts->{$host}->{city}         = $old_hosts->{$host}->{city};
                                $hosts->{$host}->{postal_code}  = $old_hosts->{$host}->{postal_code};
                                $hosts->{$host}->{latitude}     = $old_hosts->{$host}->{latitude};
                                $hosts->{$host}->{longitude}    = $old_hosts->{$host}->{longitude};
                                $hosts->{$host}->{geo_record_exist} = 1;
			}
		}
	}

	return $hosts;
}

sub get_ip_data {
	my $apache_path = shift;
	my $old_hosts   = shift;

	my $hosts = get_log_data($apache_path, $old_hosts);

	if ($hosts) {
		add_geo_data($hosts, $old_hosts);
	}

#        print Dumper($hosts);

	return $hosts;
}

sub get_geo_maps_count {
	my $apache_path = shift;
	return `/home/alex/Scripts/bash/geo_stat.sh $apache_path/`; 
}

sub get_http_table {
	my $hosts = shift;

	my $result = qq{<table BORDER=2 CELLSPACING=1 CELLPADDING=1>\n};
	$result .= qq{<tr><th>IP</th><th>Country</th><th>Region</th><th>City</th><th>Last visit</th><th>Images<br>(all/cur)</th><th>Gallery<br>(all/cur)</th><th>Sitemap<br>(all/cur)</th><th>Attak<br>(all/cur)</th><th>Count<br>(all/cur)</th></tr>\n};

	foreach my $host (
		sort {$hosts->{$b}->{$hosts->{$b}->{date}->dmy()}->{images_count} > 0 <=> $hosts->{$a}->{$hosts->{$a}->{date}->dmy()}->{images_count} > 0} 
			sort {$hosts->{$b}->{$hosts->{$b}->{date}->dmy()}->{count} > 0  <=> $hosts->{$a}->{$hosts->{$a}->{date}->dmy()}->{count} > 0} 
				sort {$hosts->{$b}->{date}->epoch() <=> $hosts->{$a}->{date}->epoch()} 
					grep {/^\d+\.\d+\.\d+\.\d+$/} keys %{$hosts}
	) {

		my $last_visit   = $hosts->{$host}->{date}->dmy() . ' ' . $hosts->{$host}->{date}->hms();

		my $count = '&nbsp;';
		if ($hosts->{$host}->{count}){
			$count = $hosts->{$host}->{count};
		}
		if ($hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{count}){
			$count .= '/' . $hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{count};
		}

		my $images_count = '&nbsp;';
		if ($hosts->{$host}->{images_count}){
			$images_count = $hosts->{$host}->{images_count};
		}
		if ($hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{images_count}){
			$images_count .= '/' . $hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{images_count};
		}
		my $engine_count = '&nbsp;';
		if ($hosts->{$host}->{engine_count}){
			$engine_count = $hosts->{$host}->{engine_count};
		}
		if ($hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{engine_count}){
			$engine_count .= '/' . $hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{engine_count};
		}

		my $sitemap_count = '&nbsp;';
		if ($hosts->{$host}->{sitemap_count}){
			$sitemap_count = $hosts->{$host}->{sitemap_count};
		}
		if ($hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{sitemap_count}){
			$sitemap_count .= '/' . $hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{sitemap_count};
		}

		my $attak_count = '&nbsp;';
		if ($hosts->{$host}->{attak_count}){
			$attak_count = $hosts->{$host}->{attak_count};
		}
		if ($hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{attak_count}){
			$attak_count .= '/' . $hosts->{$host}->{$hosts->{$host}->{date}->dmy()}->{attak_count};
		}

		my $ip_log_link = "http://homyaki.info/engine/?form=ip_log&ip=$host";
		$result .= qq{<tr><td><a href="$hosts->{$host}->{maxmind_link}">$host</a></td><td>$hosts->{$host}->{country_name}</td><td>$hosts->{$host}->{region_name}</td><td><label title = "$hosts->{$host}->{organization}" >$hosts->{$host}->{city}</label></td><td>$last_visit</td><td>$images_count</td><td>$engine_count</td><td>$sitemap_count</td><td>$attak_count</td><td><a href="$ip_log_link">$count</a></td></tr>\n};
	}

	$result .= qq{</table>\n};

	return $result;
}

sub get_html {
	my $apache_path = shift;

#	print "load hosts\n";
	my $old_hosts = load_hosts($apache_path);
#	print "load hosts end\n";
	my $hosts = get_ip_data($apache_path, $old_hosts);

	save_hosts($hosts, $apache_path);

	my $current_data_table = get_http_table($hosts);
	my $current_date       = current_date();

	my $duration = DateTime->now() - $hosts->{earlest_date};

	my $period_tmpl = q{<label title = "%s">%s</label>};
	my $period = [];

	push(@{$period}, $duration->years()  . ' years')   if $duration->years();
	push(@{$period}, $duration->months()  . ' months') if $duration->months();
	push(@{$period}, $duration->weeks()   . ' weeks')  if $duration->weeks();
	push(@{$period}, $duration->days()    . ' days')   if $duration->days();
	push(@{$period}, $duration->hours()   . ' hours')  if $duration->hours();
	push(@{$period}, $duration->minutes() . ' min.')   if $duration->minutes();

	my $days_duration = $hosts->{earlest_date}->delta_days(DateTime->now());

	my $period_head = shift(@{$period});
	my $period_str = sprintf(q{<label title = "%s">%s</label>}, join(' ', @{$period}), $period_head);
	my $maps = get_geo_maps_count($apache_path);
	my $maps_per_day = sprintf("%d", $maps / ($days_duration->in_units('days') + $duration->hours() / 24));

	my $map_visiteurs = `/home/alex/Scripts/bash/ip_stat.sh '(form|interface)=geo_maps' $apache_path/`;
	my $map_visiteurs_per_day  = sprintf("%d", $map_visiteurs / ($days_duration->in_units('days') + $duration->hours() / 24));

	my $result = qq{
		<HTML>
			<HEAD>
				<TITLE>Статистика посещения сервера</TITLE>
				<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=utf-8" />
				<link rel="icon" type="image/vnd.microsoft.icon" href="/favicon.ico" />
			</HEAD>
			<BODY BGCOLOR="#E8E8E8" TEXT="#000000" LINK="#0000FF" VLINK="#ff0000">
				<H2>Статистика посещения сервера</H2>
				<SMALL><STRONG>
					Период статистики: последние $period_str<BR>
					Дата создания $current_date MSD<BR>
					Посетителей $map_visiteurs ($map_visiteurs_per_day в день) <BR>
					Отдано $maps ($maps_per_day в день) <BR>
				</STRONG></SMALL>
				<CENTER>
				<HR>
				<P>
				$current_data_table
			</BODY>
		</HTML>
	};

	return $result;
}

sub save_hosts {
	my $hosts       = shift;
	my $apache_path = shift;

	my $hosts_str = freeze($hosts);

	if (open HOSTS, ">$apache_path/hosts.obj"){

		print HOSTS $hosts_str;
		close HOSTS;
	}
}

sub load_hosts {
	my $apache_path = shift;

	my $hosts;
	my $hosts_str = '';

	if (open HOSTS, "<$apache_path/hosts.obj"){
		while (my $hosts_line = <HOSTS>) {
			$hosts_str .= $hosts_line;
		}
		close HOSTS;

		$hosts = thaw($hosts_str);
	};

	return $hosts;
}

sub escape_request {
	my $mask = shift;

	$mask =~ s/GET\s+\//(GET|POST)\\s+\/*/gi;
	$mask =~ s/\./\\\./gi;
	$mask =~ s/\?/\\?/gi;

	return $mask;
}
1;
