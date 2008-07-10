package Class::Accessor::Fluent;

use strict;
use warnings;
use Sub::Install;

our $VERSION = '0.01';

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
          return $self->{$name};
        }

        return $self;
      },
      into => $class,
      as   => $name,
    });
  }
}

sub new {
  my ($class, %self) = @_;

  bless \%self, $class;
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

  See the point?

=head1 DESCRIPTION

This class is to implement so-called "fluent interface" (well, kind of). This is not so cool and useful way of setting options for perl but anyway, there's no accounting for taste :)

=head1 CLASS METHODS

=head2 mk_fluent_accessors

Takes the names of fluent accessors and creates/export them into the caller package.

=head2 new

basic constructor that generates a hash based object.

=head1 SEE ALSO

L<Class::Accessor::Fast>

L<http://d.hatena.ne.jp/antipop/20080710/1215626395> (Japanese blog entry)

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
