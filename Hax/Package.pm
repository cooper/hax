package Hax::Package;

use warnings;
use strict;

use Hax::Exporter prefix => 'package';

# adds a package to an ISA list if the
# package does not inherit from it already.
# package_make_child_of('Evented::Person', 'EventedObject', 1)
sub make_child_of {
    my ($package, $make_parent, $at_end) = @_;
    my $isa = package_get_variable($package, '@ISA');
    
    # package already inherits directly.
    return 1 if $make_parent ~~ @$isa;
    
    # check each class in ISA for inheritance.
    foreach my $parent (@$isa) {
        return 1 $parent->isa($make_parent);
    }
    
    # add to ISA.
    unshift @$isa, $make_parent unless $at_end;
    push    @$isa, $make_parent if     $at_end;
    
    return 1;
    
}

sub get_variable {
}

sub set_variable {
}

1
