# Copyright (c) 2013, Mitchell Cooper
package Hax::Exporter;

use warnings;
use strict;

our %p;

# the exporter's import subroutine.
sub import {
    my ($class, %opts) = @_;
    my $package = caller;
    
    # export sub prefix.
    if (defined $opts{prefix}) {
        $p{$package}{prefix} = $opts{prefix};
    }
    
    # export the package's import()
    export_code($package, 'import', sub { _import($package, (caller)[0], @_[1..$#_]) });
        
}

# exported import subroutine.
sub _import {
    my ($export_pkg, $import_pkg, @import) = @_;

    # import each item.
    foreach my $item (@import) {
        my $code   = $export_pkg->can($item) or next;
        my $prefix = defined $p{$export_pkg}{prefix} ? $p{$export_pkg}{prefix}.q(_) : q();
        export_code($import_pkg, $prefix.$item, $code);
    }
}

# export a subroutine.
# export_code('My::Package', 'my_sub', \&_my_sub)
sub export_code {
    my ($package, $sub_name, $code) = @_;
    no strict 'refs';
    *{"${package}::$sub_name"} = $code;
}

1
