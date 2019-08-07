clear all;close all;clc;
ndatasize   = [ 50 100 200 400 800 1400 2144 ];
nberror     = [ 0.0388  0.0262  0.0262 0.0187 0.0175 0.0163  0.0163];
svmdatasize = [ 50 100 200 400 800 1400 2144 ];
svmerror    = [ 0.0525 0.0312 0.0125 0.0150 0.0125 0.0100 0.0063];
plot(ndatasize,nberror);
xlabel('data size');
ylabel('error');