package Alien::Build::Plugin::Fetch::HostAllowList;

use strict;
use warnings;
use 5.008004;
use Alien::Build::Plugin;
use URI;

# ABSTRACT: Require that Alien::Build based aliens only fetch from an allow list of hosts
# VERSION

=head1 SYNOPSIS

Using with environment variables only:

 export ALIEN_BUILD_PRELOAD=Fetch::HostAllowList
 export ALIEN_BUILD_HOST_ALLOW=github.com,ftp.gnu.org

Using from C<~/.alienbuild/rc.pl>:

 preload sub {
   my($meta) = @_;
   $meta->apply_plugin($preload, allow_hosts => [qw( github.com ftp.gnu.org )])
 };

=head1 DESCRIPTION

This is an L<Alien::Build> plugin that will, when enabled, reject any fetch requests
made by an L<Alien::Build> based L<Alien> that are fetching from a remote host that
is not in the provided allow list.

L<Alien>s that bundle packages are not affected, as this plugin does not check
C<file> URLs.

If no allow list is specified (either via the property or environment variable,
see below) then no remote hosts will be allowed.

=head1 PROPERTIES

=head2 allow_hosts

 plugin 'Fetch::HostALlowList', allow_hosts => \@hosts;

The list of domains that are allowed.  Should be provided as an array reference.
If not provided, then C<ALIEN_BUILD_HOST_ALLOW> will be used (see below).

=cut

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

=cut

1;
