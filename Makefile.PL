use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'Class::Accessor::Fluent',
  AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
  VERSION_FROM  => 'lib/Class/Accessor/Fluent.pm',
  ABSTRACT_FROM => 'lib/Class/Accessor/Fluent.pm',
  PREREQ_PM => {
    'Sub::Install'        => 0,
    'Test::More'          => '0.47',
    'Test::UseAllModules' => '0.09',
  },
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? ( LICENSE => 'perl' )
    : ()
  ),
);
