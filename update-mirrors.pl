#!/usr/bin/perl -w
use warnings;
use strict;
use LWP::Simple;
use LWP;
use Date::Parse;
use Date::Format;

#
# A quick hack by Jacob Appelbaum <jacob@appelbaum.net>
# LWP suggestions by Leigh Honeywell
# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt
#
# CHANGELOG
# 20091003 Code changes to elimiate the need for a trailing slash in addresses for script runtime
# 20091004 Code changes to increase out of date tolerance to 48 hours
# 20091028 Code changes to increase timout to 30 seconds (attempting to # resolve "unknown" status')
# 20091028 Code changes to change user agent of script
# 20100807 Remove dead mirrors.

print "Creating LWP agent ($LWP::VERSION)...\n";
my $lua = LWP::UserAgent->new(
    keep_alive => 1,
    timeout => 30,
    agent => "Tor MirrorCheck Agent"
);

sub sanitize {
    my $taintedData = shift;
    my $cleanedData;
    my $whitelist = '-a-zA-Z0-9: +';

    # clean the data, return cleaned data
    $taintedData =~ s/[^$whitelist]//go;
    $cleanedData = $taintedData;

    return $cleanedData;
}

sub FetchDate {
    my $url = shift; # Base url for mirror
    my $trace = "/project/trace/www.torproject.org"; # Location of recent update info
    $url = "$url$trace";

    print "Fetching possible date from: $url\n";

    my $request = new HTTP::Request GET => "$url";
    my $result = $lua->request($request);
    my $code = $result->code();
    print "Result code $code\n";

    if ($result->is_success && $code eq "200"){
       my $taint = $result->content;
       my $content = sanitize($taint);
       if ($content) {

            my $date = str2time($content);

            if ($date) {
                print "We've fetched a date $date.\n";
                return $date;
            } else {
                print "We've haven't fetched a date.\n";
                return "Unknown";
            }

        } else {
            print "Unable to fetch date, empty content returned.\n";
            return "Unknown";
        }

    } else {
       print "Our request failed, we had no result.\n";
       return "Unknown";
    }

    return "Unknown";
}

# This is the list of all known Tor mirrors
# Add new mirrors to the bottom!
my %m = (

        
        mirror000 => {
            adminContact => "coralcdn.org",
            orgName => "CoralCDN",
            isoCC => "INT",
            subRegion => "",
            region => "INT",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Yes",
            httpWebsiteMirror => "http://www.torproject.org.nyud.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.org.nyud.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",

        },

        mirror001 => {
            adminContact => "BarkerJr AT barkerjr DOT net",
            orgName => "BarkerJr",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.oignon.net/",
            httpsWebsiteMirror => "https://www.oignon.net/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.oignon.net/dist/",
            httpsDistMirror => "https://www.oignon.net/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

       mirror002 => {
            adminContact => "",
            orgName => "Boinc",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.boinc.ch/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.boinc.ch/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror003 => {
            adminContact => "citizen428 AT gmail DOT com",
            orgName => "[[:bbs:]]",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.blingblingsquad.net/",
            httpsWebsiteMirror => "https://tor.blingblingsquad.net/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.blingblingsquad.net/dist",
            httpsDistMirror => "https://tor.blingblingsquad.net/dist",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror005 => {
            adminContact => "contact AT algorithmus DOT com",
            orgName => "Spline",
            isoCC => "DE",
            subRegion => "FU",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://rem.spline.de/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

	    mirror006 => {
            adminContact => "BarkerJr AT barkerjr DOT net",
            orgName => "BarkerJr",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torproject.us/",
            httpsWebsiteMirror => "https://www.torproject.us/",
            rsyncWebsiteMirror => "rsync://rsync.torproject.us/tor",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.us/dist/",
            httpsDistMirror => "https://www.torproject.us/dist/",
            rsyncDistMirror => "rsync://rsync.torproject.us/tor/dist",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

       mirror007 => {
            adminContact => "info AT zentrum-der-gesundheit DOT de",
            orgName => "Zentrum der Gesundheit",
            isoCC => "DK",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.idnr.ws/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.idnr.ws/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror008 => {
            adminContact => "root AT amorphis DOT eu",
            orgName => "Amorphis",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.amorphis.eu/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.amorphis.eu/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror009 => {
            adminContact => "mirror AT bit DOT nl",
            orgName => "BIT BV",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "ftp://ftp.bit.nl/mirror/tor/",
            httpDistMirror => "http://ftp.bit.nl/mirror/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror010 => {
            adminContact => "webmaster AT ccc DOT de",
            orgName => "CCC",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.ccc.de/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.ccc.de/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror011 => {
            adminContact => "root AT kamagurka DOT org",
            orgName => "Kamagurka",
            isoCC => "NL",
            subRegion => "Haarlem",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.kamagurka.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.kamagurka.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror012 => {
            adminContact => "evert AT meulie DOT net",
            orgName => "Meulie",
            isoCC => "NO",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.meulie.net/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror013 => {
	    adminContact => "hostmaster AT zombiewerks DOT com",
            orgName => "TheOnionRouter",
            isoCC => "US",
            subRegion => "New Jersey",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://www.theonionrouter.com/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.theonionrouter.com/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

        mirror014 => {
            adminContact => "tormaster AT xpdm DOT us",
            orgName => "Xpdm",
            isoCC => "US",
            subRegion => "",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://torproj.xpdm.us/",
            httpsWebsiteMirror => "https://torproj.xpdm.us/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproj.xpdm.us/dist/",
            httpsDistMirror => "https://torproj.xpdm.us/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "http://h3prhz46uktgm4tt.onion/",
            updateDate => "Unknown",
        },

        mirror016 => {
            adminContact => "security AT hostoffice DOT hu",
            orgName => "Unknown",
            isoCC => "HU",
            subRegion => "Hungary",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.hu/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror017 => {
            adminContact => "",
            orgName => "Technica-03",
            isoCC => "UA",
            subRegion => "Ukraine",
            region => "Eastern Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torua.reactor-xg.kiev.ua/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tordistua.reactor-xg.kiev.ua/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	    mirror018 => {
            adminContact => "",
            orgName => "chaos darmstadt",
            isoCC => "DE",
            subRegion => "Germany",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirrors.chaos-darmstadt.de/tor-mirror/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirrors.chaos-darmstadt.de/tor-mirror/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror019 => {
            adminContact => "webmaster AT askapache DOT com",
            orgName => "AskApache",
            isoCC => "US",
            subRegion => "California",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.askapache.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.askapache.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror020 => {
            adminContact => " mail AT benjamin-meier DOT info ",
            orgName => "beme it",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.beme-it.de/",
            httpsWebsiteMirror => "https://tor.beme-it.de/",
            rsyncWebsiteMirror => "rsync://tor.beme-it.de/tor",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.beme-it.de/dist/",
            httpsDistMirror => "https://tor.beme-it.de/dist/",
            rsyncDistMirror => "rsync://tor.beme-it.de/tor/dist",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror021 => {
            adminContact => "",
            orgName => "India Tor Fans",
            isoCC => "IN",
            subRegion => "",
            region => "IN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torproject.org.in/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.org.in/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror023 => {
            adminContact => "sina at accessnow.org",
            orgName => "Access",
            isoCC => "IR",
            subRegion => "",
            region => "IR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Yes",
            httpWebsiteMirror => "http://irani-tor.ath.cx/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://irani-tor.ath.cx/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror024 => {
            adminContact => "",
            orgName => "homosu",
            isoCC => "SE",
            subRegion => "",
            region => "SE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.homosu.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.homosu.net/dist",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror025 => {
            adminContact => "margus.random at mail.ee",
            orgName => "CyberSIDE",
            isoCC => "EE",
            subRegion => "",
            region => "EE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://cyberside.planet.ee/tor/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://cyberside.net.ee/tor/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror026 => {
            adminContact => "me_ at tomyn dot com",
            orgName => "tomyn",
            isoCC => "UK",
            subRegion => "",
            region => "UK",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.tomyn.com",
            httpsWebsiteMirror => "https://tor.tomyn.com",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "ftp://tor.tomyn.com",
            httpDistMirror => "http://tor.tomyn.com/dist",
            httpsDistMirror => "https://tor.tomyn.com/dist",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror027 => {
            adminContact => "",
            orgName => "mirrors.sykotik.org",
            isoCC => "RO",
            subRegion => "",
            region => "RO",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "ftp://mirrors.sykotik.org/pub/tor/",
            httpDistMirror => "http://mirrors.sykotik.org/pub/tor/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror028 => {
            adminContact => "gouki",
            orgName => "5ª Coluna",
            isoCC => "PT",
            subRegion => "",
            region => "PT",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor-www.5coluna.com",
            httpsWebsiteMirror => "https://tor-www.5coluna.com",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor-www.5coluna.com/dist/",
            httpsDistMirror => "https://tor-www.5coluna.com/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror029 => {
            adminContact => "",
            orgName => "",
            isoCC => "US",
            subRegion => "WA",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.nwlinux.us",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.nwlinux.us/dist",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },
        mirror030 => {
            adminContact => "",
            orgName => "LazyTiger",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.taiga-san.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.taiga-san.net/dist",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        }
);

my $count = values %m;
print "We have a total of $count mirrors\n";
print "Fetching the last updated date for each mirror.\n";

my $tortime;
$tortime = FetchDate("http://www.torproject.org/");
# Adjust offical Tor time by out-of-date offset: number of days * seconds per day 
$tortime -= 1 * 172800; 
print "The official time for Tor is $tortime. \n";

foreach my $server ( keys %m ) {

    print "Attempting to fetch from $m{$server}{'orgName'}\n";

    if ($m{$server}{'httpWebsiteMirror'}) {
        print "Attempt to fetch via HTTP.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'httpWebsiteMirror'}");
    } elsif ($m{$server}{'httpsWebsiteMirror'}) {
        print "Attempt to fetch via HTTPS.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'httpsWebsiteMirror'}");
    } elsif ($m{$server}{'ftpWebsiteMirror'}) {
        print "Attempt to fetch via FTP.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'ftpWebsiteMirror'}");
    } else {
        print "We were unable to fetch or store anything. We still have the following: $m{$server}{'updateDate'}\n";
    }

    print "We fetched and stored the following: $m{$server}{'updateDate'}\n";

 }


print "We sorted the following mirrors by their date of last update: \n";
foreach my $server ( sort { $m{$b}{'updateDate'} <=> $m{$a}{'updateDate'}} keys %m ) {

     print "\n";
     print "Mirror $m{$server}{'orgName'}: \n";

     foreach my $attrib ( sort keys %{$m{$server}} ) {
        print "$attrib = $m{$server}{$attrib}";
        print "\n";
     };
}

my $outFile = "include/mirrors-table.wmi";
my $html;
open(OUT, "> $outFile") or die "Can't open $outFile: $!";

# Here's where we open a file and print some wml include goodness
# This is storted from last known recent update to unknown update times
foreach my $server ( sort { $m{$b}{'updateDate'} <=> $m{$a}{'updateDate'}} keys %m ) {

     my $time;
     if ( "$m{$server}{'updateDate'}" ne "Unknown") {
	  if ( $m{$server}{'updateDate'} > $tortime ) {
	    $time = "Up to date";
	  } else { $time = "Out of date"; }
     } else { $time = "Unknown"; }
print OUT <<"END";
     \n<tr>\n
         <td>$m{$server}{'isoCC'}</td>\n
         <td>$m{$server}{'orgName'}</td>\n
         <td>$time</td>\n
END

     my %prettyNames = (
                        httpWebsiteMirror => "http",
                        httpsWebsiteMirror => "https",
                        ftpWebsiteMirror => "ftp",
                        rsyncWebsiteMirror => "rsync",
                        httpDistMirror => "http",
                        httpsDistMirror => "https",
                        rsyncDistMirrors => "rsync", );

     foreach my $precious ( sort keys %prettyNames )
     {
        if ($m{$server}{"$precious"}) {
            print OUT "    <td><a href=\"" . $m{$server}{$precious} . "\">" .
                      "$prettyNames{$precious}</a></td>\n";
        } else { print OUT "    <td> - </td>\n"; }
     }

     print OUT "</tr>\n";
}

close(OUT);
