#!/usr/bin/env perl

# This CGI tries to do as little as possible. A URL is passed from the languages
# dropdown form generated in /include/foot.wmi and the client is redirected to that page
use CGI qw(:standard);
my $lang = param('Language');
print "Status: 302 Moved\nLocation: /$lang\n\n";
