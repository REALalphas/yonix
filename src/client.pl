#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;
use HTTP::Tiny;

print "Current directory: ", getcwd(), "\n";
use Cwd;
# Read config.ini
my $path = getcwd() . '/' . 'client.ini';

open(my $fh, '<', $path) or die "Cannot open file: $!";
my %config;
my $section;

while (<$fh>) {
    chomp;
    next if /^\s*$/ || /^\s*#/;  # Skip empty lines/comments

    if (/^\s*\[\s*(.+?)\s*\]\s*$/) {  # Section header
        $section = $1;
    } elsif (/^\s*([^=]+?)\s*=\s*(.*?)\s*$/) {  # Key-value pair
        $config{$section}{$1} = $2;
    }
}

close $fh;
#End of reading config


my $data_url = $config{Basic}{data_url};
my $branch = $config{Basic}{branch};
my $repo = $config{Data}{repo};
my $servers_file = $config{Data}{servers_file};

my $url = "$data_url/$repo/$branch/$servers_file";
my $response = `curl -s "$url"`;

print $url;
print $response;

# Create a TCP client socket
my $socket = IO::Socket::INET->new(
    PeerHost => 'localhost',
    PeerPort => 8080,
    Proto    => 'tcp',
) or die "Cannot connect: $!";

# Send data to the server
print $socket "ХУЙ!\n";

# Read the server's response
my $svresponse = <$socket>;
print "Server replied: $svresponse";

# Close the socket
close $socket;
