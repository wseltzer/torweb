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

print "Creating LWP agent ($LWP::VERSION)...\n";
my $lua = LWP::UserAgent->new(
    keep_alive => 1,
    timeout => 15, 
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
    my $trace = "project/trace/www.torproject.org"; # Location of recent update info
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
            adminContact => "or-assistants.local",							
            orgName => "Cypherpunks",
            isoCC => "AT",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.cypherpunks.at/",
            rsyncWebsiteMirror => "rsync://tor.cypherpunks.at/tor",
            httpDistMirror => "http://tor.cypherpunks.at/dist/",
            rsyncDistMirror => "rsync://tor.cypherpunks.at::tor/dist/",
            updateDate => "Unknown",
        },

       mirror001 => {
            adminContact => "webmaster.depthstrike.com",							
            orgName => "Depthstrike",
            isoCC => "CA",
            subRegion => "NS",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.depthstrike.com/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.depthstrike.com/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror002 => {
            adminContact => "operator.hermetix.org",							
            orgName => "Hermetix",
            isoCC => "CA",
            subRegion => "QC",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.hermetix.org/",
            rsyncWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror003 => {
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

       mirror004 => {
            adminContact => "peihanru.yahoo.com.cn",							
            orgName => "Anonymity",
            isoCC => "CN",
            subRegion => "",
            region => "Asia",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.anonymity.cn/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.anonymity.cn/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror005 => {
            adminContact => "citizen428.gmail.com",							
            orgName => "Bbs",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.blingblingsquad.net/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.blingblingsquad.net/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       # mirror005 => {
            # orgName => "Berapla",
            # isoCC => "DE",
            # subRegion => "",
            # region => "Europe",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "http://download.berapla.de/mirrors/tor/",
            # ftpWebsiteMirror => "",
            # rsyncWebsiteMirror => "",
            # httpDistMirror => "",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       mirror006 => {
            adminContact => "cm.cybermirror.org",							
            orgName => "Cybermirror",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.cybermirror.org/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.cybermirror.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror007 => {
            adminContact => "contact.algorithmus.com",							
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

       mirror008 => {
            adminContact => "lechtermann\bsdhost.eu",							
            orgName => "Bsdhost",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://mirror.bsdhost.eu/www.torproject.org/",
            ftpWebsiteMirror => "ftp://mirror.bsdhost.eu/www.torproject.org/",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://mirror.bsdhost.eu/www.torproject.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror009 => {
            adminContact => "beaver.trash.net",							
            orgName => "Onionland",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://mirror.onionland.org/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "rsync: mirror.onionland.org::tor/",
            httpDistMirror => "http://mirror.onionland.org/dist/",
            rsyncDistMirror => "rsync://mirror.onionland.org::tor/dist/",
            updateDate => "Unknown",
        },

       mirror010 => {
												adminContact => "contact.plentyfact.org",
            orgName => "Plentyfact",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.plentyfact.net/",
            ftpWebsiteMirror => "",
            httpsWebsiteMirror => "https://tor.plentyfact.net/",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.plentyfact.net/dist/",
            httpsDistMirror => "https://tor.plentyfact.net/dist/",												
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       # mirror011 => {
            # orgName => "loxal.net",
            # isoCC => "DE",
            # subRegion => "",
            # region => "Europe",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "http://tor-anonymizer.mirror.loxal.net/",
            # ftpWebsiteMirror => "",
            # rsyncWebsiteMirror => "",
            # httpDistMirror => "http://tor-anonymizer.mirror.loxal.net/dist/",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       # mirror012 => {
            # orgName => "centervenus.com",
            # isoCC => "DE",
            # subRegion => "",
            # region => "Europe",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "",
            # ftpWebsiteMirror => "",
            # rsyncWebsiteMirror => "",
            # httpDistMirror => "http://www.centervenus.com/mirrors/tor/dist/",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       mirror013 => {
            adminContact => "info.zentrum-der-gesundheit.de",							
            orgName => "Zentrum der Gesundheit",
            isoCC => "DK",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.zdg-gmbh.eu/", 
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "", 
            httpDistMirror => "http://tor.zdg-gmbh.eu/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror014 => {
            adminContact => "kurt.miroir-francais.fr",							
            orgName => "CRAN",
            isoCC => "FR",
            subRegion => "Ile de France",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "rsync://miroir-francais.fr::tor", 
            ftpWebsiteMirror => "ftp://miroir-francais.fr/pub/tor/",
            httpDistMirror => "http://tor.miroir-francais.fr/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       # mirror015 => {
            # orgName => "tor.newworldorder.com.es",
            # isoCC => "HU",
            # subRegion => "",
            # region => "Europe",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "http://tor.newworldorder.com.es/",
            # rsyncWebsiteMirror => "", 
            # ftpWebsiteMirror => "",
            # httpDistMirror => "",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       mirror016 => {
            adminContact => "root.amorphis.eu",							
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

       mirror017 => {
            adminContact => "mirror.bit.nl",							
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

       mirror018 => {
            adminContact => "webmaster.ccc.de",							
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

       mirror018 => {
            adminContact => "root.kamagurka.org",
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

       mirror019 => {
            adminContact => "mirrors.osmirror.nl",							
            orgName => "OS Mirror",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "rsync://rsync.osmirror.nl::tor/", 
            ftpWebsiteMirror => "ftp://ftp.osmirror.nl/pub/tor/",
            httpDistMirror => "http://tor.osmirror.nl/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },


       mirror020 => {
            adminContact => "evert.meulie.net",							
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

       # mirror021 => {
            # orgName => "Swedish Linux Society",
            # isoCC => "SE",
            # subRegion => "",
            # region => "Europe",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "http://ftp.se.linux.org/crypto/tor/",
            # rsyncWebsiteMirror => "", 
            # ftpWebsiteMirror => "ftp://ftp.se.linux.org/pub/crypto/tor/",
            # httpDistMirror => "",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       mirror022 => {
            adminContact => "ghirai.ghirai.com",							
            orgName => "Ghirai",
            isoCC => "UK",
            subRegion => "London",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.ghirai.com/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror023 => {
							     adminContact => "",
            orgName => "BJWOnline",
            isoCC => "US",
            subRegion => "California",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://mirror.bjwonline.com/tor/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.bjwonline.com/tor/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       # mirror024 => {
            # orgName => "Libertarian Action Network",
            # isoCC => "US",
            # subRegion => "",
            # region => "North America",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "",
            # rsyncWebsiteMirror => "", 
            # ftpWebsiteMirror => "ftp://libertarianactivism.com/tor.eff.org/dist/",
            # httpDistMirror => "",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       mirror025 => {
							     adminContact => "hostmaster.zombiewerks.com",
            orgName => "TheOnionRouter",
            isoCC => "US",
            subRegion => "Texas",
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

       # mirror026 => {
            # orgName => "Site2nd.org",
            # isoCC => "USA",
            # subRegion => "Texas",
            # region => "North America",
            # ipv4 => "True",
            # ipv6 => "False",
            # loadBalanced => "Unknown",
            # httpWebsiteMirror => "http://tor.site2nd.org",
            # rsyncWebsiteMirror => "", 
            # ftpWebsiteMirror => "",
            # httpDistMirror => "",
            # rsyncDistMirror => "",
            # updateDate => "Unknown",
        # },

       mirror027 => {
            adminContact => "jeroen.unfix.org",
            orgName => "Unfix",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.unfix.org/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.unfix.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror028 => {
            adminContact => "jeroen.unfix.org",
            orgName => "Sixx",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.sixxs.net/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.sixxs.net/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror029 => {
            adminContact => "",
            orgName => "Crypto",
            isoCC => "US",
            subRegion => "",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://crypto.nsa.org/tor/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "http://crypto.nsa.org/tor/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror030 => {
            adminContact => "web2005a.year2005a.wiretapped.net",
            orgName => "Wiretapped",
            isoCC => "AU",
            subRegion => "Sydney",
            region => "Oceania",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "ftp://ftp.mirrors.wiretapped.net/pub/security/cryptography/network/tor/",
            httpDistMirror => "http://www.mirrors.wiretapped.net/security/cryptography/network/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },								

        mirror031 => {
            adminContact => "tormaster.xpdm.us",
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

        mirror032 => {
            adminContact => "abuse.misericordia.be",
            orgName => "Misericordia",
            isoCC => "FR",
            subRegion => "France",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.misericordia.be/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.misericordia.be/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },		

);

my $count = values %m;
print "We have a total of $count mirrors\n";
print "Fetching the last updated date for each mirror.\n";

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
     if( "$m{$server}{'updateDate'}" ne "Unknown") {
        $time = ctime($m{$server}{'updateDate'});
        chomp($time);
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
