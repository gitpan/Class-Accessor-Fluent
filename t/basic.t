use strict;
use warnings;
use Test::More qw( no_plan );

package Class::Accessor::Fluent::Test::Base;

use base qw( Class::Accessor::Fluent );

__PACKAGE__->mk_fluent_accessors(qw( foo bar ));

sub test { my $self = shift; $self->foo . ' ' . $self->bar; }

package Class::Accessor::Fluent::Test::Extended;

use base qw( Class::Accessor::Fluent::Test::Base );

package main;

{
  my $app = Class::Accessor::Fluent::Test::Base->new;
  my $ret = $app->foo('foo')->bar('bar')->test;
  ok $ret eq 'foo bar', "from object";
}

{
  my $ret = Class::Accessor::Fluent::Test::Base->foo('foo')->bar('bar')->test;
  ok $ret eq 'foo bar', "from class";
}

{
  my $app = Class::Accessor::Fluent::Test::Extended->new;
  my $ret = $app->foo('foo')->bar('bar')->test;
  ok $ret eq 'foo bar', "from extended object";
}

{
  my $ret = Class::Accessor::Fluent::Test::Extended->foo('foo')->bar('bar')->test;
  ok $ret eq 'foo bar', "from extended class";
}
