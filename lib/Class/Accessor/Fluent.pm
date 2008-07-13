package Class::Accessor::Fluent;

use strict;
use warnings;
use Carp;
use Tie::Hash;
use base qw( Tie::StdHash );
use Sub::Install;

our $VERSION = '0.02';

sub mk_fluent_accessors {
  my ($class, @names) = @_;

  foreach my $name ( @names ) {
    Sub::Install::install_sub({
      code => sub {
        my $self = shift;
        $self = $self->new unless ref $self;

        if ( @_ && @_ == 1 ) {
          $self->{$name} = shift;
        }
        elsif ( @_ ) {
          $self->{$name} = [@_];
        }
        else {
          if ( ref $self->{$name} eq 'ARRAY' ) {
            return wantarray
              ? @{ $self->{$name} }
              : $self->{$name};  # should be $self->{$name}->[0] ?
          }
          return $self->{$name};
        }

        return $self;
      },
      into => $class,
      as   => $name,
    });
  }
  my %fields = map { $_ => 1 } @names;
  Sub::Install::install_sub({
    code => sub { wantarray ? keys %fields : \%fields },
    into => $class,
    as   => '_fields',
  });
}

sub new {
  my ($class, %hash) = @_;

  my %self;
  foreach my $field ( $class->_fields ) {
    $self{$field} = delete $hash{$field};
  }
  if ( %hash ) {
    croak "not allowed: ".(join ", ", sort { $a cmp $b } keys %hash);
  }
  tie %self, $class;
  bless \%self, $class;
}

sub STORE {
  my ($self, $key, $value) = @_;

  croak "$key is not allowed" unless $self->_fields->{$key};

  $self->{$key} = $value;
}

1;

__END__

=head1 NAME

Class::Accessor::Fluent - do you like fluent interface?

=head1 SYNOPSIS

  in your class:

    package MyApp;
    use base qw(Class::Accessor::Fluent);

    __PACKAGE__->mk_fluent_accessors(qw( foo bar ));

    sub do_something {
      my $self = shift;

      print $self->foo, "\n", $self->bar, "\n";
    }

    1;

  then:

    #!perl
    my $app = MyApp->new;
       $app->foo('foo')->bar('bar')->do_something;

  actually you can omit ->new:

    MyApp->foo('foo')->bar('bar')->do_something;

  (you may need extra parentheses to modify the precedence, though)

  run it:

    > myapp.pl
    foo
    bar

  note that you can't set undeclared key/value combos:

    my $app = MyApp->new( not_allowed => 1 );  # croaks
    my $app = MyApp->new;
       $app->{not_allowed} = 1;  # croaks

  so you should always use set/get values via accessors/mutators.

  see the point?

=head1 DESCRIPTION

This class is to implement so-called "fluent interface" (well, kind of). This is not so cool and useful way of setting options for perl but anyway, there's no accounting for taste :)

=head1 CLASS METHODS

=head2 mk_fluent_accessors

Takes the names of fluent accessors and creates/export them into the caller package.

=head2 new

basic constructor that generates a hash based object.

=head1 SEE ALSO

L<Class::Accessor::Fast>,

L<Class::Accessor::Chained>,

L<http://d.hatena.ne.jp/antipop/20080710/1215626395> (Japanese blog entry)

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
