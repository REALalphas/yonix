#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;

# Create a TCP server socket
my $server = IO::Socket::INET->new(
    LocalHost => 'localhost',  # Bind to localhost
    LocalPort => 8080,         # Port to listen on
    Proto     => 'tcp',        # Protocol (TCP)
    Listen    => 5,            # Queue size for connections
    ReuseAddr => 1,            # Reuse address immediately
) or die "Cannot create server: $!";

print "Server running on port 8080...\n";

# Accept incoming connections
while (my $client = $server->accept()) {
    print "Client connected: ", $client->peerhost(), "\n";

    # Read client message
    my $data = <$client>;
    print "Received: $data";

    # Send a response
    print $client "Message received!\n";

    # Close the client connection
    close $client;
}

close $server;
