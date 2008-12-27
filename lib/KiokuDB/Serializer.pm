#!/usr/bin/perl

package KiokuDB::Serializer;
use Moose::Role;

use Moose::Util::TypeConstraints;

use namespace::clean -except => 'meta';

with qw(KiokuDB::Backend::Serialize);

requires "serialize_to_stream";
requires "deserialize_from_stream";

my %types = (
    storable => "KiokuDB::Serializer::Storable",
    json     => "KiokuDB::Serializer::JSON",
    yaml     => "KiokuDB::Serializer::YAML",
);

coerce( __PACKAGE__,
    from Str => via {
        my $class = $types{lc($_)};
        Class::MOP::load_class($class);
        $class->new;
    },
    from HashRef => via {
        my %args = %$_;
        my $class = $types{lc(delete $args{format})};
        Class::MOP::load_class($class);
        $class->new(%args);
    },
);

__PACKAGE__

__END__