package Sledge::Plugin::Layout;

use strict;
use vars qw($VERSION);
$VERSION = '0.02';

sub import {
    my $self = shift;
    my $pkg  = caller(0);

    no strict 'refs';
    *{"$pkg\::set_layout"} = sub {
        my $self   = shift;
        my $layout = shift;

        $self->register_hook(BEFORE_DISPATCH => sub {
            my $h_self   = shift;

            my $filename = $h_self->tmpl->{_options}->{filename};
            $h_self->tmpl->{_options}->{filename} = $self->guess_filename($layout);
            $h_self->tmpl->param(template_for_layout => $filename);
        });
    };
}

1;
__END__

=head1 NAME

Sledge::Plugin::Layout - Rails like layout plugin for Sledge

=head1 SYNOPSIS

  project Your::Pages;
  use Sledge::Plugin::Layout;
  __PACKAGE__->set_layout('include/layout.html');
  sub dispatch_foo {
    my $self = shift;
    $self->tmpl->param(i => 3);
  }

  # include/layout.html 
  <html><head><title>Your Project</title></head><body>
  [% INCLUDE $template_for_layout %]
  </body></html>

  # foo.html
  [% i | html %]foo!!

  # extract ...
  <html><head><title>Your Project</title></head><body>
  3foo!!
  </body></html>

=head1 DESCRIPTION

Sledge::Plugin::Layout use to "wrap" some presentation around your views.

=head1 AUTHOR

MATSUNO Tokuhiro E<lt>tokuhiro at mobilefactory.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Bundle::Sledge>

=cut
