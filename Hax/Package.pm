# Copyright (c) 2013, Mitchell Cooper
package Hax::Package;

use warnings;
use strict;
use feature 'switch';

use Hax::Exporter prefix => 'package';

# adds a package to an ISA list if the
# package does not inherit from it already.
# package_make_child_of('Evented::Person', 'EventedObject', 1)
sub make_child_of {
    my ($package, $make_parent, $at_end) = @_;
    my $isa = get_symbol($package, '@ISA');
    
    # package already inherits directly.
    return 1 if $make_parent ~~ @$isa;
    
    # check each class in ISA for inheritance.
    foreach my $parent (@$isa) {
        return 1 if $parent->isa($make_parent);
    }
    
    # add to ISA.
    unshift @$isa, $make_parent unless $at_end;
    push    @$isa, $make_parent if     $at_end;
    
    return 1;
    
}

# fetch a symbol from package's symbol table.
sub get_symbol {
    my ($package, $variable, $ref) = @_;
    
    # must start with a sigil.
    return if $variable !~ m/^([@\*%\$])(\w+)$/;
    my ($sigil, $var_name) = ($1, $2);
    
    my $symbol = $package.q(::).$var_name;
    no strict 'refs';
 
    # find the symbol.
    given ($sigil) {
        when ('$') { return $ref ? \$$symbol : $$symbol }
        when ('@') { return $ref ? \@$symbol : @$symbol }
        when ('*') { return $ref ? \*$symbol : *$symbol }
        when ('%') { return $ref ? \&$symbol : %$symbol }
    }
    
    return;
}

# fetch a reference to a symbol.
sub get_symbol_ref { get_symbol(@_, 1) }

# set a symbol in package's symbol table.
sub set_symbol {
}

# borrow Hax::Exporter's code exporter.
sub export_code;
*export_code = *Hax::Exporter::export_code;

1
