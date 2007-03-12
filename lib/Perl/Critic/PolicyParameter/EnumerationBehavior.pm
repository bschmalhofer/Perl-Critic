##############################################################################
#      $URL$
#     $Date$
#   $Author$
# $Revision$
##############################################################################

package Perl::Critic::PolicyParameter::EnumerationBehavior;

use strict;
use warnings;
use Carp qw(confess);
use Perl::Critic::Utils qw{ $PERIOD &words_from_string &hashify };

use base qw{ Perl::Critic::PolicyParameter::Behavior };

our $VERSION = 1.03;

#-----------------------------------------------------------------------------

sub initialize_parameter {
    my ($self, $parameter, $specification) = @_;

    my $values = $specification->{enumeration_values}
        or confess 'No enumeration_values given for ',
                    $parameter->get_name(), $PERIOD;
    ref $values eq 'ARRAY'
        or confess 'The value given for enumeration_values for ',
                    $parameter->get_name(), ' is not an array reference.';
    scalar @{$values} > 1
        or confess 'There were not at least two valid values given for',
                   ' enumeration_values for ', $parameter->get_name(),
                   $PERIOD;

    my %values = hashify( @{$values} );

    my $policy_variable_name = q{_} . $parameter->get_name();

    my $allow_multiple_values =
        $specification->{enumeration_allow_multiple_values};

    if ($allow_multiple_values) {
        $parameter->_set_parser(
            sub {
                # Normally bad thing, obscuring a variable in a outer scope
                # with a variable with the same name, done in order to remain
                # consistent with the parser function interface.
                my ($policy, $parameter, $config_string) = @_;

                my @potential_values;
                if ( defined $config_string ) {
                    @potential_values = words_from_string($config_string);

                    my @bad_values =
                        grep { not exists $values{$_} } @potential_values;
                    if (@bad_values) {
                        die q{Invalid values: },
                            join (q{, }, @bad_values),
                            qq{.\n};
                    }
                }

                $policy->{ $policy_variable_name } = \@potential_values;
                return;
            }
        );
    } else {
        $parameter->_set_parser(
            sub {
                # Normally bad thing, obscuring a variable in a outer scope
                # with a variable with the same name, done in order to remain
                # consistent with the parser function interface.
                my ($policy, $parameter, $config_string) = @_;

                if ( not defined $values{$config_string} ) {
                    die qq{Invalid value: $config_string.\n};
                }

                $policy->{ $policy_variable_name } = $config_string;
            }
        );
    }

    return;
}

#-----------------------------------------------------------------------------

1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::PolicyParameter::Behavior - Type-specific subroutines for a PolicyParameter.


=head1 DESCRIPTION

Provides a standard set of functionality for an enumerated
L<Perl::Critic::PolicyParameter> so that the developer of a policy does not
have to provide it her/himself.


=head1 METHODS

=over

=item C<initialize_parameter( $parameter, $specification )>

Plug in the functionality this behavior provides into the parameter, based
upon the configuration provided by the specification.

This behavior looks for two configuration items:

=over

=item enumeration_values

Mandatory.  The set of valid values for the parameter, as an array reference.

=item enumeration_allow_multiple_values

Optional, defaults to false.  Should the parameter support a single value or
accept multiple?

=back

=back


=head1 AUTHOR

Elliot Shank <perl@galumph.org>

=head1 COPYRIGHT

Copyright (c) 2006-2007 Elliot Shank.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
