#!/usr/bin/perl

package Math::Base::Convert;	# into the main package

@BASES = qw( bin dna DNA oct dec hex HEX b62 b64 m64 iru url rex id0 id1 xnt xid b85 );

$signedBase = 16;               # largest allowable known signed base

my $package = __PACKAGE__;
my $packageLen = length __PACKAGE__;

sub _class {
  (my $class = (caller(1))[3]) =~ s/([^:]+)$/_bs::$1/;
  $class;
}

# return a pointer to a sub for the array blessed into Package::sub::name
#

sub bin { bless ['0', '1'], &_class}
sub dna { bless [qw( a c t g )], &_class}
sub DNA { bless [qw( A C T G )], &_class}
sub ocT { bless ['0'..'7'], &_class}
sub dec { bless ['0'..'9'], &_class}
sub heX { bless ['0'..'9', 'a'..'f'], &_class}
sub HEX { bless ['0'..'9', 'A'..'F'], &_class}
sub b62 { bless ['0'..'9', 'a'..'z', 'A'..'Z'], &_class}
sub b64 { bless ['0'..'9', 'A'..'Z', 'a'..'z', '.', '_'], &_class}
sub m64 { bless ['A'..'Z', 'a'..'z', '0'..'9', '+', '/'], &_class}
sub iru { bless ['A'..'Z', 'a'..'z', '0'..'9', '[', ']'], &_class}
sub url { bless ['A'..'Z', 'a'..'z', '0'..'9', '*', '-'], &_class}
sub rex { bless ['A'..'Z', 'a'..'z', '0'..'9', '!', '-'], &_class}
sub id0 { bless ['A'..'Z', 'a'..'z', '0'..'9', '_', '-'], &_class}
sub id1 { bless ['A'..'Z', 'a'..'z', '0'..'9', '.', '_'], &_class}
sub xnt { bless ['A'..'Z', 'a'..'z', '0'..'9', '.', '-'], &_class}
sub xid { bless ['A'..'Z', 'a'..'z', '0'..'9', '_', ':'], &_class}
sub b85 { bless ['0'..'9', 'A'..'Z', 'a'..'z', '!', '#',   # RFC 1924 for IPv6 addresses, might need to return Math::BigInt objs
            '$', '%', '&', '(', ')', '*', '+', '-', ';', '<', '=', '>', '?', '@', '^', '_', '`', '{', '|', '}', '~'], &_class}
sub ebcdic { bless [qw
	( 0  1  2  3 37 2D 2E 2F 16  5 25 0B 0C 0D 0E 0F 10 11 12 13 3C 3D 32 26 18 19 3F 27 1C 1D 1E 1F 
	 40 4F 7F 7B 5B 6C 50 7D 4D 5D 5C 4E 6B 60 4B 61 F0 F1 F2 F3 F4 F5 F6 F7 F8 F9 7A 5E 4C 7E 6E 6F 
	 7C C1 C2 C3 C4 C5 C6 C7 C8 C9 D1 D2 D3 D4 D5 D6 D7 D8 D9 E2 E3 E4 E5 E6 E7 E8 E9 4A E0 5A 5F 6D 
	 79 81 82 83 84 85 86 87 88 89 91 92 93 94 95 96 97 98 99 A2 A3 A4 A5 A6 A7 A8 A9 C0 6A D0 A1  7 
	 20 21 22 23 24 15 6 17 28 29 2A 2B 2C 9 0A 1B 30 31 1A 33 34 35 36 8 38 39 3A 3B  4 14 3E E1 41 
	 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 
	 77 78 80 8A 8B 8C 8D 8E 8F 90 9A 9B 9C 9D 9E 9F A0 AA AB AC AD AE AF B0 B1 B2 B3 B4 B5 B6 B7 B8
	 B9 BA BB BC BD BE BF CA CB CC CD CE CF DA DB DC DD DE DF EA EB EC ED EE EF FA FB FC FD FE FF)], &_class}

# Since we're not using BIcalc, the last test can be eliminated...
################### special treatment for override 'hex' ##################################

sub hex {
		#		unless	our package	and is a BC ref	and not a BI number (which is an ARRAY)
  unless (ref($_[0]) && $package eq substr(ref($_[0]),0,$packageLen) && (local *glob = $_[0]) && *glob{HASH}) {
# $package, $filename, $line, $subroutine, $hasargs
#       0       1        2         3            4
#   if   defined      and    hasargs
    if ( defined $_[0] && (caller(0))[4] ) {
      return CORE::hex $_[0];
    }
  }
  return heX();
}

################### special treatment for override 'oct' #################################
sub oct {
		#		unless	our package	and is a BC ref	and not a BI number (which is an ARRAY)
  unless (ref($_[0]) && $package eq substr(ref($_[0]),0,$packageLen) && (local *glob = $_[0]) && *glob{HASH}) {
# $package, $filename, $line, $subroutine, $hasargs
    #       0       1        2         3            4
#   if   defined      and    hasargs
    if ( defined $_[0] && (caller(0))[4] ) {
      return CORE::oct $_[0];
    }
  }
  return ocT();
}

################################## REMOVE ABOVE CODE ###################

# return a hash of all base pointers
#
sub _bases {
  no strict;
  my %bases;
  foreach (@BASES) {
    my $base = $_->();
    ref($base) =~ /([^:]+)$/;
    $bases{$1} = $base;
  }
  \%bases;
}
1;

__END__

=head1 NAME - Math::Base::Convert::Bases

This package contains no documentation

See L<Math::Base::Convert> instead

=head1 AUTHOR

Michael Robinton, michael@bizsystems.com

=head1 COPYRIGHT

Copyright 2012, Michael Robinton

This program is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.   

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut 

1;
