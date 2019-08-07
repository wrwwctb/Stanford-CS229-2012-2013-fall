clear all; close all; clc;
xx = dlmread('q2x.dat');
yy = dlmread('q2y.dat');
plot(xx,yy,'.');
hold on;
%axis equal;
xlabel('q2x');
ylabel('q2y');

mm = length(yy);
nn = 2;
xx = [ones(mm,1) xx];

% i
th = ( xx' * xx ) \ xx' * yy;
x_sorted = sortrows(xx,2);
y_unweighted = x_sorted * th;
plot(x_sorted(:,2), y_unweighted,'linewidth',3);

% ii and iii
nn_query = 100;
xx_query = [ones(nn_query,1) linspace(min(xx(:,2)),max(xx(:,2)),nn_query)'];
tau      = .8; % bandwidth %[0.1 .3 .8 2 10];
for idx = 1:length(tau) % tau's
    y_weighted = zeros(nn_query,1);
    for jdx = 1:nn_query % query points
        ww = zeros(mm);
        for kdx = 1:mm % training data
            ww(kdx,kdx) = exp(-1/2/tau(idx)^2*(xx_query(jdx,2)- xx(kdx,2))^2);
        end
        th = (xx'*ww*xx)\xx'*ww*yy;
        y_weighted(jdx) = xx_query(jdx,:) * th;
    end
    plot(xx_query(:,2),y_weighted,'r');
end
hh = legend('training data','unweighted',['weighted. \tau = ' num2str(tau(1))]);
set(hh,'location','southeast')