=name Basic failures

=failures 15

=cut

our $var1 = 'foo';
our (%var2, %var3) = 'foo';
our (%VAR4, $var5) = ();

$Package::foo;
@Package::list = ('nuts');
%Package::hash = ('nuts');

$::foo = $bar;
@::foo = ($bar);
%::foo = ();

use vars qw($fooBar $baz);
use vars qw($fooBar @EXPORT);
use vars '$fooBar', "$baz";
use vars '$fooBar', '@EXPORT';
use vars ('$fooBar', '$baz');
use vars ('$fooBar', '@EXPORT');


#----------------------------------------------------------------

=name Basic passes

=failures 0

=cut

our $VAR1 = 'foo';
our (%VAR2, %VAR3) = ();
our $VERSION = '1.0';
our @EXPORT = qw(some symbols);

use vars qw($VERSION @EXPORT);
use vars ('$VERSION, '@EXPORT');
use vars  '$VERSION, '@EXPORT';

use vars  '+foo'; #Illegal, but not a violaton

#local $Foo::bar;
#local @This::that;
#local %This::that;
#local $This::that{ 'key' };
#local $This::that[ 1 ];
#local (@Baz::bar, %Baz::foo);

$Package::VERSION = '1.2';
%Package::VAR = ('nuts');
@Package::EXPORT = ();

$::VERSION = '1.2';
%::VAR = ('nuts');
@::EXPORT = ();
&Package::my_sub();
&::my_sub();
*foo::glob = $code_ref;


=name Lexicals should pass

=failures 0

=cut

my $var1 = 'foo';
my %var2 = 'foo';
my ($foo, $bar) = ();


#----------------------------------------------------------------

=name Default package exceptions

=failures 0

=cut

use File::Find;
print $File::Find::dir;


#----------------------------------------------------------------

=name Override default package exceptions

=failures 1

=parms {packages => 'Override::Defaults'}

=cut

use File::Find;
print $File::Find::dir;
$Override::Defaults::wango = $x;
$Override::Defaults::tango = 47;
END_PERL


#----------------------------------------------------------------

=name Add to default exceptions

=failures 1

=parms {add_packages => 'Addl::Package'}

=cut


use File::Find;
print $File::Find::dir;
$Addl::Package::bar = 27;
