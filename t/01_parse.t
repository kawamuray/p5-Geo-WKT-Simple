use strict;
use warnings;
use Test::More;

use Geo::WKT::Simple;

subtest "Parse POINT" => sub {
    is_deeply [ wkt_parse_point('POINT(10 20)') ],     [ 10, 20 ];
    is_deeply [ wkt_parse_point('POINT(10.0 20.0)') ], [ '10.0', '20.0' ];

    is_deeply [ wkt_parse(POINT => 'POINT(10 20)') ],  [ 10, 20 ];
};

subtest "Parse LINESTRING" => sub {
    is_deeply [ wkt_parse_linestring('LINESTRING(10 20)') ], [
        [ 10, 20 ],
    ];
    is_deeply [ wkt_parse_linestring('LINESTRING(10 20, 30 40)') ], [
        [ 10, 20 ],
        [ 30, 40 ],

    ];
    is_deeply [ wkt_parse(LINESTRING => 'LINESTRING(10 20)') ], [
        [ 10, 20 ],
    ];
};

subtest "Parse MULTILINESTRING" => sub {
    is_deeply [ wkt_parse_multilinestring('MULTILINESTRING((10 20))') ], [
        [ [ 10, 20 ] ],
    ];
    is_deeply [ wkt_parse_multilinestring('MULTILINESTRING((10 20, 30 40))') ], [
        [ [ 10, 20 ], [ 30, 40 ] ],
    ];
    is_deeply [ wkt_parse_multilinestring('MULTILINESTRING((10 20, 30 40), (50 60))') ], [
        [ [ 10, 20 ], [ 30, 40 ] ],
        [ [ 50, 60 ] ],
    ];
    is_deeply [ wkt_parse_multilinestring('MULTILINESTRING((10 20, 30 40), (50 60, 70 80))') ], [
        [ [ 10, 20 ], [ 30, 40 ] ],
        [ [ 50, 60 ], [ 70, 80 ] ],
    ];

    is_deeply [ wkt_parse(MULTILINESTRING => 'MULTILINESTRING((10 20))') ], [
        [ [ 10, 20 ] ],
    ];
};

subtest "Parse POLYGON" => sub {
    is_deeply [ wkt_parse_polygon('POLYGON((10 20))') ], [
        [ [ 10, 20 ] ],
    ];
    is_deeply [ wkt_parse_polygon('POLYGON((10 20, 30 40))') ], [
        [ [ 10, 20 ], [ 30, 40 ] ],
    ];
    is_deeply [ wkt_parse_polygon('POLYGON((10 20, 30 40), (50 60))') ], [
        [ [ 10, 20 ], [ 30, 40 ] ],
        [ [ 50, 60 ] ],
    ];
    is_deeply [ wkt_parse_polygon('POLYGON((10 20, 30 40), (50 60, 70 80))') ], [
        [ [ 10, 20 ], [ 30, 40 ] ],
        [ [ 50, 60 ], [ 70, 80 ] ],
    ];

    is_deeply [ wkt_parse(POLYGON => 'POLYGON((10 20))') ], [
        [ [ 10, 20 ] ],
    ];
};

subtest "Parse MULTIPOLYGON" => sub {
    is_deeply [ wkt_parse_multipolygon('MULTIPOLYGON(((10 20)))') ], [
        [
            [ [ 10, 20 ] ],
        ],
    ];
    is_deeply [ wkt_parse_multipolygon('MULTIPOLYGON(((10 20, 30 40)))') ], [
        [
            [ [ 10, 20 ], [ 30, 40 ] ],
        ],
    ];
    is_deeply [ wkt_parse_multipolygon('MULTIPOLYGON(((10 20, 30 40), (50 60)))') ], [
        [
            [ [ 10, 20 ], [ 30, 40 ] ],
            [ [ 50, 60 ] ],
        ],
    ];
    is_deeply [ wkt_parse_multipolygon('MULTIPOLYGON(((10 20, 30 40), (50 60, 70 80)))') ], [
        [ 
            [ [ 10, 20 ], [ 30, 40 ] ],
            [ [ 50, 60 ], [ 70, 80 ] ],
        ],
    ];

    is_deeply [ wkt_parse(MULTIPOLYGON => 'MULTIPOLYGON(((10 20)))') ], [
        [
            [ [ 10, 20 ] ],
        ],
    ];
};

subtest "Parse GEOMETRYCOLLECTION" => sub {
    is_deeply [ wkt_parse_geometrycollection(
        'GEOMETRYCOLLECTION(POLYGON((10 20, 30 40), (50 60, 70 80)), POINT(10 20), LINESTRING(10 20, 30 40))'
    )], [
        [ POLYGON    => [ [ [ 10, 20 ], [ 30, 40 ] ], [ [ 50, 60 ], [ 70, 80 ] ] ] ],
        [ POINT      => [ 10, 20 ]                                                 ],
        [ LINESTRING => [ [ 10, 20 ], [ 30, 40 ] ]                                 ],
    ];

    is_deeply [ wkt_parse(GEOMETRYCOLLECTION =>
        'GEOMETRYCOLLECTION(POLYGON((10 20, 30 40), (50 60, 70 80)), POINT(10 20), LINESTRING(10 20, 30 40))'
    )], [
        [ POLYGON    => [ [ [ 10, 20 ], [ 30, 40 ] ], [ [ 50, 60 ], [ 70, 80 ] ] ] ],
        [ POINT      => [ 10, 20 ]                                                 ],
        [ LINESTRING => [ [ 10, 20 ], [ 30, 40 ] ]                                 ],
    ];
};


done_testing;
