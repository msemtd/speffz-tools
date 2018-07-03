#!perl -w
use strict;
use tmstub;
=for docs

This is in perl for brevity but could be any language - it's just a vehicle 
for the programming concepts.

https://www.speedsolving.com/wiki/index.php/Speffz

TODO: -
apply given scramble
unit tests
generic abstract canvas style GUI
port it to various other languages
Transforms for each face turn move
Words for letter pairs!

=cut
t "Yo, let's speffz it up...";

my $scr = shift || "R U R' U'";
my $debug = 1;
my $cs = fresh_cube();
my $solved = $cs;




#~ print $cs;
#~ print "\n";
my $p = draw($cs, 1);
t $p;
$p = draw($cs, 0);
t $p;

$cs = apply_moves($cs, $scr);


## Unscrambled 3x3 cube state in speffz format - clockwise lettering of stickers
sub fresh_cube {
    my $s = "";
    foreach('A'..'X') { $s .= $_ . lc($_); }
    return $s;	
}

## Split speffz cube state into 6 faces
sub faces {
    local $_ = shift;
    die unless /^(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})$/;
    return ($1, $2, $3, $4, $5, $6); 
}

## Draw the given cube state as a human-friendly net
# here we can support different face orders
# ULFRBD is the speffz standard though
#
#     +-+
#     |U|
#   +-+-+-+-+
#   |L|F|R|B|
#   +-+-+-+-+
#     |D|
#     +-+
# 
#       AaB
#       d*b
#       DcC
#    EeFIiJMmNQqR
#    h*fl*jp*nt*r
#    HgGLkKPoOTsS
#       UuV
#       x*v
#       XwW
#   
#           +-+-+-+
#           |A|a|B|
#           +-+-+-+
#           |d|*|b|
#           +-+-+-+
#           |D|c|C|
#     +-+-+-+-+-+-+-+-+-+-+-+-+
#     |E|e|F|I|i|J|M|m|N|Q|q|R|
#     +-+-+-+-+-+-+-+-+-+-+-+-+
#     |h|*|f|l|*|j|p|*|n|t|*|r|
#     +-+-+-+-+-+-+-+-+-+-+-+-+
#     |H|g|G|L|k|K|P|o|O|T|s|S|
#     +-+-+-+-+-+-+-+-+-+-+-+-+
#           |U|u|V|
#           +-+-+-+
#           |x|*|v|
#           +-+-+-+
#           |X|w|W|
#           +-+-+-+
#     
sub draw {
    my $s = shift;
    my $boxes = shift;
    my @a = faces($s);
    my @rd = map{ facerows($_) }@a;
    my @rows;
    # here we can set up the drawing style to use - raw or boxes
    my $dent = $boxes ? ' 'x6 : ' 'x3;
    my $v = $boxes ? "|" : "";
    my ($u, $l, $f, $r, $b, $d) = @rd;
    if($boxes) { push @rows, $dent."+-+-+-+"; }
    push @rows, $dent.$v.join($v, @{$u->[0]}).$v;
    if($boxes) { push @rows, $dent."+-+-+-+"; }
    push @rows, $dent.$v.join($v, @{$u->[1]}).$v;
    if($boxes) { push @rows, $dent."+-+-+-+"; }
    push @rows, $dent.$v.join($v, @{$u->[2]}).$v;
    if($boxes) { push @rows, "+-+-+-+-+-+-+-+-+-+-+-+-+"; }
    push @rows, $v.join($v, @{$l->[0]}).$v.join($v, @{$f->[0]}).$v.join($v, @{$r->[0]}).$v.join($v, @{$b->[0]}).$v;
    if($boxes) { push @rows, "+-+-+-+-+-+-+-+-+-+-+-+-+"; }
    push @rows, $v.join($v, @{$l->[1]}).$v.join($v, @{$f->[1]}).$v.join($v, @{$r->[1]}).$v.join($v, @{$b->[1]}).$v;
    if($boxes) { push @rows, "+-+-+-+-+-+-+-+-+-+-+-+-+"; }
    push @rows, $v.join($v, @{$l->[2]}).$v.join($v, @{$f->[2]}).$v.join($v, @{$r->[2]}).$v.join($v, @{$b->[2]}).$v;
    if($boxes) { push @rows, "+-+-+-+-+-+-+-+-+-+-+-+-+"; }
    push @rows, $dent.$v.join($v, @{$d->[0]}).$v;
    if($boxes) { push @rows, $dent."+-+-+-+"; }
    push @rows, $dent.$v.join($v, @{$d->[1]}).$v;
    if($boxes) { push @rows, $dent."+-+-+-+"; }
    push @rows, $dent.$v.join($v, @{$d->[2]}).$v;
    if($boxes) { push @rows, $dent."+-+-+-+"; }
    return join("\n", @rows);
}

## Convert a face into 3 rows of 3 stickers - top to bottom, left to right
sub facerows {
    local $_ = shift;
    my @c = split //;
    return [[$c[0], $c[1], $c[2]], [$c[7], '*', $c[3]], [$c[6], $c[5], $c[4]]];
}

## Apply a sequence of moves to a state and return the result
sub apply_moves {
    my $cs = shift;
    my $moves = shift;
    # parse state...
    my @f = faces($cs);
    
    # parse and validate moves...
    my @moves = split / /, $moves;
    t d \@moves;
    
        
    return $cs;
}
