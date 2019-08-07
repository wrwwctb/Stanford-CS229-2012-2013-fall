clear all; close all; clc;
%sampling frequency
Fs = 11025;
load mix.dat;
normalizedMix = 0.99 * mix ./ (ones(size(mix,1),1)*max(abs(mix)));
writeWav( 'mix', normalizedMix, Fs );
% initialize unmixing matrix
W = eye(5);
% anneal schedule
anneal  = [.1 .1 .1 .05 .05 .05 .02 .02 .01 .01 .005 .005 .002 .002 .001 .001 .0005 .0005 .0002 .0002 .0001 .0001];
sigmoid = @(x) 1./(1 + exp(-x));
% randomize the time order of data
stream        = RandStream.create('mt19937ar','seed',1);
RandStream.setDefaultStream( stream );
normalizedMix = [randperm(length(normalizedMix))' (1:length(normalizedMix))' normalizedMix];
normalizedMix = sortrows(normalizedMix);
orderKeeper   = normalizedMix(:,2);
normalizedMix = normalizedMix(:,3:end);
% to observe how W converges
W_bin         = zeros(length(anneal)*length(mix),1);
% stochastic gradient descent w/ annealing learning rate that changes after each pass thru the data
for idx1 = 1:length(anneal)
    for idx2 = 1:length(normalizedMix)
        W = W + anneal(idx1) * (  (1 - 2*sigmoid( W*normalizedMix(idx2,:)' ) )*normalizedMix(idx2,:) + inv(W')  );
        W_bin( (idx1-1)*length(normalizedMix)+idx2) = det(W);
    end
end;
% de-randomize the data
S = normalizedMix * W';
S = sortrows([orderKeeper S]);
S = S(:,2:end);
% rescale
S = 0.99 * S./(ones(size(mix,1),1)*max(abs(S)));
writeWav( 'unmix', S, Fs );
