package Geo::WKT::Simple;
use strict;
use warnings;
use utf8;

use parent 'Exporter';

our $VERSION = '0.01';

our @EXPORT = qw/
  parse_wkt_point
  parse_wkt_polygon
  parse_wkt_geomcol
  parse_wkt_linestring
  parse_wkt_multilinestring
  parse_wkt_polygon
  parse_wkt_multipolygon
  parse_wkt_geometrycollection
  parse_wkt
/;
#   wkt_point
#   wkt_multipoint
#   wkt_linestring
#   wkt_polygon
#   wkt_linestring
#   wkt_multilinestring
#   wkt_multipolygon
#   wkt_optimal
#   wkt_geomcollection
# /;

use Data::Dumper;
sub p { warn Dumper(@_) }

sub parse_wkt_point {
#    warn $_[0];
    $_[0] =~ /^point\(\s*([\w\.]+)\s+([\w\.]+)\)$/i
}

sub _parse_points_list {
#    warn "parse_points_list: $_[0]";
    map {
        [ split /\s+/, $_, 2 ]
    } $_[0] =~ /([\w\.]+\s+[\w\.]+)(?:,\s*)?/g
}

sub _parse_points_group {
#     warn "parse_points_group: $_[0]";
    map {
        [ _parse_points_list($_) ]
    } $_[0] =~ /\(((?:[\w\.]+\s+[\w\.]+(?:,\s*)?)*)\)(?:,\s*)?/g
}

sub _parse_points_group_list {
#     warn "parse_points_group_list: $_[0]";
    map {
        [ _parse_points_group($_) ]
    } $_[0] =~ /\(((?:\((?:[\w\.]+\s+[\w\.]+(?:,\s*)?)*\)(?:,\s*)?)*)\)(?:,\s*)?/g
}

sub parse_wkt_linestring {
    my @points = _parse_points_list(
        $_[0] =~ /^linestring\((.+)\)$/i,
    );

#     p \@points;

    @points;
}

sub parse_wkt_multilinestring {
    _parse_points_group(
        $_[0] =~ /^multilinestring\((.+)\)$/i
    )
}

sub parse_wkt_polygon {
    my @groups = _parse_points_group(
        $_[0] =~ /^polygon\((.+)\)$/i
    );

#     p \@groups;

    @groups;
}

sub parse_wkt_multipolygon {
    my @groups_list = _parse_points_group_list(
        $_[0] =~ /^multipolygon\((.+)\)$/i
    );

#     p \@groups_list;

    @groups_list;
}

my $ALLTYPES = "(?:MULTI)?(?:POINT|LINESTRING|POLYGON)|GEOMETRYCOLLECTION";
sub parse_wkt_geometrycollection {
    my ($wkt) = $_[0] =~ /^GEOMETRYCOLLECTION\((.+)\)$/
        or return;

    # Copy from Geo::WKT
    my @comps;
    while ($wkt =~ m/\D/) {
        last unless $wkt =~ s/^[^(]*\([^)]*\)//;
        my $take  = $&;
        while (1) {
            my @open  = $take =~ m/\(/g;
            my @close = $take =~ m/\)/g;
            last if @open==@close;
            $take .= $& if $wkt =~ s/^[^\)]*\)//;
        }
        my ($type) = $take =~ /^($ALLTYPES)/;
        push @comps, [ uc($type) => [ parse_wkt($type => $take) ] ];

        $wkt =~ s/^\s*\,\s*//;
    }

    @comps;
}

sub parse_wkt {
    my ($type, $wkt) = @_;

    return if uc($type) !~ /^$ALLTYPES$/;
    do {
        no strict 'refs';
        &{ 'parse_wkt_'.lc($type) }($_[1]);
    };
}

1;
__END__

=head1 NAME

Geo::WKT::Simple - Perl extension for parsing Well Known Text format string.

=head1 SYNOPSIS

  use Geo::WKT::Simple;

=head1 DESCRIPTION

Geo::WKT::Simple is a module to provide simple parser for Well Known Text(WKT) format string.

This module can parse WKT format string into pure perl data structure.

=head2 Why not L<Geo::WKT> ?

There is a few reasons.

=over

=item - I just need simple return value represented by pure perl data structure.
Geo::WKT returns results as a Geo::* instances which represents each type of geodetic components.

=item - L<Geo::Proj4> dependencies. L<Geo::Proj4> depends to libproj4

=item - I need to support MULTI(LINESTRING|POLYGON).

=back

=head1 AUTHOR

Yuto KAWAMURA(kawamuray) E<lt>kawamuray.dadada {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
