# Alien::Build::Plugin::Fetch::HostAllowList ![static](https://github.com/PerlAlien/Alien-Build-Plugin-Fetch-HostAllowList/workflows/static/badge.svg) ![linux](https://github.com/PerlAlien/Alien-Build-Plugin-Fetch-HostAllowList/workflows/linux/badge.svg)

Require that Alien::Build based aliens only fetch from an allow list of hosts

# SYNOPSIS

Using with environment variables only:

```
export ALIEN_BUILD_PRELOAD=Fetch::HostAllowList
export ALIEN_BUILD_HOST_ALLOW=github.com,ftp.gnu.org
```

Using from `~/.alienbuild/rc.pl`:

```perl
preload sub {
  my($meta) = @_;
  $meta->apply_plugin('Fetch::HostAllowList', allow_hosts => [qw( github.com ftp.gnu.org )])
};
```

# DESCRIPTION

This is an [Alien::Build](https://metacpan.org/pod/Alien::Build) plugin that will, when enabled, reject any fetch requests
made by an [Alien::Build](https://metacpan.org/pod/Alien::Build) based [Alien](https://metacpan.org/pod/Alien) that are fetching from a remote host that
is not in the provided allow list.

[Alien](https://metacpan.org/pod/Alien)s that bundle packages are not affected, as this plugin does not check
`file` URLs.

If no allow list is specified (either via the property or environment variable,
see below) then no remote hosts will be allowed.

# PROPERTIES

## allow\_hosts

```perl
plugin 'Fetch::HostAllowList', allow_hosts => \@hosts;
```

The list of domains that are allowed.  Should be provided as an array reference.
If not provided, then `ALIEN_BUILD_HOST_ALLOW` will be used (see below).

# ENVIRONMENT

- `ALIEN_BUILD_HOST_ALLOW`

    Comma separated list of hosts to allow.  If not specified when the
    plugin is applied then this list will be used.

# SEE ALSO

- [Alien::Build::Plugin::Fetch::HostBlockList](https://metacpan.org/pod/Alien::Build::Plugin::Fetch::HostBlockList)
- [Alien::Build](https://metacpan.org/pod/Alien::Build)
- [alienfile](https://metacpan.org/pod/alienfile)
- LAlien::Build::rc>

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2022 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
