package Alien::Build::Plugin::Fetch::HostAllowList;

use strict;
use warnings;
use 5.008004;
use Alien::Build::Plugin;
use URI;

# ABSTRACT: Require that Alien::Build based aliens only fetch from an allow list of hosts
# VERSION

has allow_hosts => sub { [
  defined $ENV{ALIEN_BUILD_HOST_ALLOW}
  ? split /,/, $ENV{ALIEN_BUILD_HOST_ALLOW}
  : ()
] };

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
        my $host = eval { $url->host };
        die "unable to determine host from $url: $@" if $@;
        die "The host $host is not in the allow list" unless $allowed{$host};
      }
    }

    $orig->($build, @_);
  });
}

=head1 ENVIRONMENT

=over 4

=item C<ALIEN_BUILD_HOST_ALLOW>

Comma separated list of hosts to allow.  If not specified when the
plugin is applied then this list will be used.

=back

1;
