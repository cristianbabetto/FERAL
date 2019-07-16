function [ ga, gb, gc ] = calc_dq2abc( gd, gq, thetame )
%CALC_DQ2ABC transform a quantity in the dq-axes reference frames in the
%abc one.
%   [ga,gb,gc] = CALC_DQ2ABC(gd,gq,theta)
%     - gd,gq: d- and q- axis quantities, respectively,
%     - thetame: electrical rotor angle in degrees.

thetame = thetame*pi/180;

ga = gd*cos(thetame)          - gq*sin(thetame);
gb = gd*cos(thetame - 2*pi/3) - gq*sin(thetame - 2*pi/3);
gc = gd*cos(thetame - 4*pi/3) - gq*sin(thetame - 4*pi/3);

end

