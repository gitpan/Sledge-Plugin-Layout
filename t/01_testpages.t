use strict;
use warnings;
use Test::More;
$| = 1;

BEGIN {
    eval "use Sledge::TestPages";
    plan $@ ? (skip_all => 'needs Sledge::TestPages for testing') : (tests => 3);
}

{
    package Mock::Pages;
    use strict;
    use warnings;
    use base qw(Sledge::TestPages);
    use Sledge::Plugin::Layout;
    use Sledge::Template::TT;
    __PACKAGE__->set_layout('layout.html');

    sub dispatch_foo {
        my $self = shift;
        $self->tmpl->param(i => 3);
    }
}

my $d = $Mock::Pages::TMPL_PATH;
$Mock::Pages::TMPL_PATH = 't/tmpl/';
my $c = $Mock::Pages::COOKIE_NAME;
$Mock::Pages::COOKIE_NAME = 'sid';
$ENV{HTTP_COOKIE}    = "sid=SIDSIDSIDSID";

my $page = Mock::Pages->new;
$page->dispatch('foo');

my $out = $page->output;

like($out, qr{3Foo+!!},  'extract templates');
like($out, qr{<html>},   'extract header');
like($out, qr{</html>},  'extract footer');
