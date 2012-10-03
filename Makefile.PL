use inc::Module::Install;
name 'Geo-WKT-Simple';
all_from 'lib/Geo/WKT/Simple.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
