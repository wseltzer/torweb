#!/usr/bin/perl -w
use warnings;
use strict;
use LWP::Simple;
use LWP;
use Date::Parse;
use Date::Format;

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

    if ($result->is_success){
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
}

# This is the list of all known Tor mirrors
# Add new mirrors to the bottom!
my %m = ( 
       mirror000 => {
            orgName => "cypherpunks.at",
            isoCC => "AT",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.cypherpunks.at/",
            rsyncWebsiteMirror => "rsync://tor.cypherpunks.at/tor",
            httpDistMirror => "http://tor.cypherpunks.at/dist/",
            rsyncDistMirror => "rsync: tor.cypherpunks.at::tor/dist/",
            updateDate => "",
        },

       mirror001 => {
            orgName => "depthstrike.com",
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
            updateDate => "",
        },

       mirror002 => {
            orgName => "hermetix.org",
            isoCC => "CA",
            subRegion => "QC",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.hermetix.org/",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.hermetix.org/dist/",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror003 => {
            orgName => "Boinc.ch",
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
            updateDate => "",
        },

       mirror004 => {
            orgName => "anonymity.cn",
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
            updateDate => "",
        },

       mirror004 => {
            orgName => "bbs",
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
            updateDate => "",
        },

       mirror005 => {
            orgName => "Berapla",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://download.berapla.de/mirrors/tor/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror006 => {
            orgName => "cybermirror",
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
            updateDate => "",
        },

       mirror007 => {
            orgName => "Spline",
            isoCC => "DE",
            subRegion => "FU",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://rem.spline.de/tor/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror008 => {
            orgName => "mirror.bsdhost.eu",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://mirror.bsdhost.eu/www.torproject.org/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://mirror.bsdhost.eu/www.torproject.org/dist/",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror009 => {
            orgName => "onionland",
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
            rsyncDistMirror => "rsync: mirror.onionland.org::tor/dist/",
            updateDate => "",
        },

       mirror010 => {
            orgName => "plentyfact",
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
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror011 => {
            orgName => "loxal.net",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor-anonymizer.mirror.loxal.net/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor-anonymizer.mirror.loxal.net/dist/",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror012 => {
            orgName => "centervenus.com",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://www.centervenus.com/mirrors/tor/dist/",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror013 => {
            orgName => "zdg-gmbh.eu",
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
            updateDate => "",
        },

       mirror014 => {
            orgName => "CRAN",
            isoCC => "FR",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.miroir-francais.fr/",
            rsyncWebsiteMirror => "rsync: miroir-francais.fr::tor", 
            ftpWebsiteMirror => "ftp://miroir-francais.fr/pub/tor/",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror015 => {
            orgName => "tor.newworldorder.com.es",
            isoCC => "HU",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.newworldorder.com.es/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror016 => {
            orgName => "amorphis.eu",
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
            updateDate => "",
        },

       mirror017 => {
            orgName => "BIT BV",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://ftp.bit.nl/mirror/tor/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "ftp://ftp.bit.nl/mirror/tor/",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror018 => {
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
            updateDate => "",
        },

       mirror018 => {
            orgName => "kamagurka.org",
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
            updateDate => "",
        },

       mirror019 => {
            orgName => "OS Mirror",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.osmirror.nl/",
            rsyncWebsiteMirror => "rsync: rsync.osmirror.nl::tor/", 
            ftpWebsiteMirror => "ftp://ftp.osmirror.nl/pub/tor/",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },


       mirror020 => {
            orgName => "Meulie.net",
            isoCC => "NO",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.meulie.net/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror021 => {
            orgName => "Swedish Linux Society",
            isoCC => "SE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://ftp.se.linux.org/crypto/tor/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "ftp://ftp.se.linux.org/pub/crypto/tor/",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror022 => {
            orgName => "Ghirai.com",
            isoCC => "UK",
            subRegion => "London",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://www.ghirai.com/tor/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror023 => {
            orgName => "BJWOnline.com",
            isoCC => "US",
            subRegion => "California",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://mirror.bjwonline.com/tor/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror024 => {
            orgName => "Libertarian Action Network",
            isoCC => "",
            subRegion => "",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "ftp://libertarianactivism.com/tor.eff.org/dist/",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror025 => {
            orgName => "TheOnionRouter.com",
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
            updateDate => "",
        },

       mirror026 => {
            orgName => "Site2nd.org",
            isoCC => "USA",
            subRegion => "Texas",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.site2nd.org",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror027 => {
            adminContact => "jeroen\@unfix.org",
            orgName => "unfix",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.unfix.org/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
        },

       mirror028 => {
            adminContact => "jeroen\@unfix.org",
            orgName => "sixx",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.sixxs.net/",
            rsyncWebsiteMirror => "", 
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "",
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

     my $time = ctime($m{$server}{'updateDate'});
     chomp($time);
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
