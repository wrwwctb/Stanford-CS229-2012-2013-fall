clear all; close all; clc;
load control_loop;
n_seeds = size(time_steps_to_failure_bin,2);
trials = zeros(1,n_seeds);
for idx1 = 1:n_seeds
    temp = time_steps_to_failure_bin(:,idx1);
    temp( temp==0 ) = [];
    trials(idx1) = length(temp);
    
end
sum(trials)/n_seeds
std(trials)
hist(trials)
set(gca,'fontsize',16)
xlabel('Number of trials needed before convergence');
ylabel('Number of random seeds');
set(gca,'fontsize',16)