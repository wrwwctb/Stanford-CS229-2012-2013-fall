clear all; close all; clc;

%1(b)
xx = dlmread('q1x.dat');
yy = dlmread('q1y.dat');
si = size(xx);
mm = si(1);    % # of training data
nn = si(2)+1;  % # of features
xx = [ones(mm,1) xx];
th = zeros(nn,1); % parameters
del     = @(theta)   (   ( yy - 1./(1+exp(-xx*theta)) )' * xx   )';  % gradient of likelihood
hessian = @(theta)  -(   xx' * diag(1./(1+exp(-xx*theta)) ./(1+exp(xx*theta)) ) * xx);
counter = 0;
goal    = 3e-15;  % training goal: norm( gradient of likelihood ) < goal
while true
    DEL = del(th);
    normDEL = norm(DEL);
    %disp(normDEL);
    if ( normDEL < goal )
        break;
    else
        th = th - hessian(th)\DEL;
        counter = counter + 1;
    end
end
%disp(counter);
disp(th);

%1(c)
threshold = 0.5;
p0        = 0;
p1        = 0;
for idx = 1:mm
    if ( yy(idx) <= threshold )
        pp = plot(xx(idx,2),xx(idx,3),'o');
        if ( p0 == 0 )
            p0 = pp;
        end
    else
        pp = plot(xx(idx,2),xx(idx,3),'+');
        if ( p1 == 0 )
            p1 = pp;
        end
    end
    hold on;
end
legend([p0,p1],{'y^(^j^)=0','y^(^j^)=1'});
axis equal;
xlabel('q1x, 1st column');
ylabel('q1x, 2nd column');
etaT= fzero(@(x) 1./(1+exp(-x))-threshold,0); % the natural parameter eta (= theta' * xx) that makes h=threshold
% for all x_1, find the corresponding x_2 that makes eta = th' * xx = etaT
x1 = sortrows(xx(:,2));
x2 = zeros(1,length(x1));
for idx = 1:length(x1)
    x2(idx) = fzero(@(x) th'*[1;x1(idx);x] - etaT,0);
end
plot(x1,x2);