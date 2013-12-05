#!/usr/bin/perl -w
use warnings;
use strict;
use Data::Dumper;
use LWP::Simple;
use HTML::LinkExtor;
use LWP;
use Date::Parse;
use Date::Format;
use Digest::SHA qw(sha256_hex);

# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt

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
sub ExtractLinks {
    my $content = shift; 
    my $url     = shift;
    my @links;

    my $parser = HTML::LinkExtor->new(undef, $url);
    $parser->parse($content);
    foreach my $linkarray($parser->links)
    {
         my ($elt_type, $attr_name, $attr_value) = @$linkarray;
         if ($elt_type eq 'a' && $attr_name eq 'href' && $attr_value =~ /\/$/ && $attr_value =~ /^$url/)
         {
         	push @links, Fetch($attr_value, \&ExtractLinks);
         }
	 elsif ($attr_value =~ /\.(xpi|dmg|exe|tar\.gz)$/)
	 #elsif ($attr_value =~ /\.(asc)$/) # small pgp files easier to test with
         {
         	push @links, $attr_value;
         }
    }
    return @links;
}

sub ExtractDate {
    my $content = shift;  
    $content    = sanitize($content);
    my $date    = str2time($content);

    if ($date) {
    	print "ExtractDate($content) = $date\n";
        return $date;
    } else {
    	print "ExtractDate($content) = ?\n";
	return undef;
    }
}

sub ExtractSig {
    my $content = shift;
    return sha256_hex($content); 
}

sub Fetch {
    my ($url, $sub) = @_; # Base url for mirror

    my $request = new HTTP::Request GET => "$url";
    my $result = $lua->request($request);
    my $code = $result->code();
    print "\nGET $url: $code\n";

    if ($result->is_success && $code eq "200"){
       my $content = $result->content;
       if ($content) {
	    return $sub->($content, $url);
        } else {
            print "Unable to fetch $url, empty content returned.\n";
        }
    }

    return undef;
}
my @columns;
sub LoadMirrors {
    open(CSV, "<", "include/tor-mirrors.csv") or die "Cannot open tor-mirrors.csv: $!"; 
    my $line = <CSV>;
    chomp($line);
    @columns = split(/\s*,\s*/, $line);
    my @mirrors;
    while ($line = <CSV>)
    {
        chomp($line);
	my @values = split(/\s*,\s*/, $line);
	my %server;
	for (my $i = 0; $i < scalar(@columns); $i++)
	{
	    $server{$columns[$i]} = $values[$i] || '';
	}
	$server{updateDate} = str2time($server{updateDate}) if ($server{updateDate});
	push @mirrors, {%server};
    }
    close(CSV);
    return @mirrors;
}

sub DumpMirrors {
    my @m = @_;
    open(CSV, ">", "tor-mirrors.csv") or die "Cannot open tor-mirrors.csv: $!";
    print CSV join(", ", @columns) . "\n";
    foreach my $server(@m) {
	$server->{updateDate} = gmtime($server->{updateDate}) if ($server->{updateDate});
        print CSV join(", ", map($server->{$_}, @columns));
	print CSV "\n";
    }

    close(CSV);
}

my @m     = LoadMirrors();
my $count = scalar(@m);
print "We have a total of $count mirrors\n";
print "Fetching the last updated date for each mirror.\n";

my $tortime  = Fetch("https://www.torproject.org/project/trace/www-master.torproject.org", \&ExtractDate);
my @torfiles = Fetch("https://www.torproject.org/dist/", \&ExtractLinks); 
my %randomtorfiles;

for (1 .. 1)
{
	my $r = int(rand(scalar(@torfiles)));
	my $suffix = $torfiles[$r];
	$suffix =~ s/^https:\/\/www.torproject.org//;
	$randomtorfiles{$suffix} = Fetch($torfiles[$r], \&ExtractSig);
}

print "Using these files for sig matching:\n";
print join("\n", keys %randomtorfiles);

# Adjust official Tor time by out-of-date offset: number of days * seconds per day
$tortime -= 1 * 172800;
print "The official time for Tor is $tortime. \n";

for(my $server = 0; $server < scalar(@m); $server++) {
    foreach my $serverType('httpWebsiteMirror', 'httpsWebsiteMirror', 'ftpWebsiteMirror', 'httpDistMirror', 'httpsDistMirror')
    {
        if ($m[$server]->{$serverType}) {
            my $updateDate = Fetch("$m[$server]->{$serverType}/project/trace/www-master.torproject.org", \&ExtractDate);
    				      
            if ($updateDate) {
		$m[$server]->{updateDate} = $updateDate;
		$m[$server]->{sigMatched} = 1;
                foreach my $randomtorfile(keys %randomtorfiles) {
                    my $sig = Fetch("$m[$server]->{$serverType}/$randomtorfile", \&ExtractSig);
            	    if (!$sig) {
		        print STDERR "Unreadable $randomtorfile on $m[$server]->{$serverType}";
			$m[$server]->{sigMatched} = 0;
            	    	last;
		    } elsif ($sig ne $randomtorfiles{$randomtorfile}) {
			$m[$server]->{sigMatched} = 0;
		        print STDERR "Sig mismatch of $randomtorfile on $m[$server]->{$serverType}";
            	    	last;
            	    }
		}
            }
	    last;
        }
    }
}

sub PrintServer {
     my $server = shift;
     my $time;
     if ( $server->{'updateDate'} ) {
	  if ( $server->{'updateDate'} > $tortime ) {
	    $time = "Up to date";
	  } else { $time = "DO NOT USE. Out of date."; }
     } else { $time = "Unknown"; }
print OUT <<"END";
     \n<tr>\n
         <td>$server->{'isoCC'}</td>\n
         <td>$server->{'orgName'}</td>\n
         <td>$time</td>\n
END

     my %prettyNames = (
                        httpWebsiteMirror => "http",
                        httpsWebsiteMirror => "https",
                        ftpWebsiteMirror => "ftp",
                        rsyncWebsiteMirror => "rsync",
                        httpDistMirror => "http",
                        httpsDistMirror => "https",
                        rsyncDistMirror => "rsync", );

     foreach my $precious ( sort keys %prettyNames )
     {
        if ($server->{"$precious"}) {
            print OUT "    <td><a href=\"" . $server->{$precious} . "\">" .
                      "$prettyNames{$precious}</a></td>\n";
        } else { print OUT "    <td> - </td>\n"; }
     }

     print OUT "</tr>\n";
}


my $outFile = "include/mirrors-table.wmi";
open(OUT, "> $outFile") or die "Can't open $outFile: $!";

# Here's where we open a file and print some wml include goodness
# This is sorted from last known recent update to unknown update times
foreach my $server ( sort { $b->{'updateDate'} <=> $a->{'updateDate'}} grep {$_->{updateDate} && $_->{sigMatched}} @m ) {
    PrintServer($server);
}
foreach my $server ( grep {!$_->{updateDate} || !$_->{sigMatched}} @m ) {
    PrintServer($server);
}

DumpMirrors(@m);

close(OUT);
