function [ gd, gq ] = calc_abc2dq( ga, gb, gc, thetame )
%CALC_ABC2DQ transform a quantity in the abc-axes reference frames in the
%dq one.
%   [gd,gq] = CALC_ABC2DQ(ga,gb,gc,theta)
%     - ga,gb,gc: a-,b- and c- axis quantities, respectively,
%     - theta: electrical rotor angle in degrees.

thetame = thetame*pi/180;

gd =  2/3*( ga.*cos(thetame) + gb.*cos(thetame - 2*pi/3) + gc.*cos(thetame - 4*pi/3) );
gq = -2/3*( ga.*sin(thetame) + gb.*sin(thetame - 2*pi/3) + gc.*sin(thetame - 4*pi/3) );

end
