package Alien::Build::Plugin::Fetch::HostAllowList;

use strict;
use warnings;
use 5.008004;
use Alien::Build::Plugin;
use URI;

# ABSTRACT: Require that Alien::Build based aliens only fetch from an allow list of hosts
# VERSION

has allow_hosts => sub { [] };

sub init
{
  my($self, $meta) = @_;

  my %allowed = map { $_ => 1 } @{ $self->allow_hosts };

  $meta->around_hook( fetch => sub {
    my $orig = shift;
    my $build = shift;
    my $url = $_[0] || $build->meta_prop->{start_url};

    # If URL doesn't have a : then it doesn't have a scheme or
    # protocol and we assume that it is a file or directory.
    if($url =~ /:/)
    {
      my $url = URI->new($url);
      if($url->scheme ne 'file')
      {
        local $@ = '';
        my $host = eval { $url->host };
        die "unable to determine host from $url: $@" if $@;
        die "The host $host is not in the allow list" unless $allowed{$host};
      }
    }

    $orig->($build, @_);
  });
}

1;


