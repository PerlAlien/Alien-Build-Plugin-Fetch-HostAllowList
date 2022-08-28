# Alien::Build::Plugin::Fetch::HostAllowList ![static](https://github.com/PerlAlien/Alien-Build-Plugin-Fetch-HostAllowList/workflows/static/badge.svg) ![linux](https://github.com/PerlAlien/Alien-Build-Plugin-Fetch-HostAllowList/workflows/linux/badge.svg)

Require that Alien::Build based aliens only fetch from an allow list of hosts

# ENVIRONMENT

- `ALIEN_BUILD_HOST_ALLOW`

    Comma separated list of hosts to allow.  If not specified when the
    plugin is applied then this list will be used.

1;

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2022 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
