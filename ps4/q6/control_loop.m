clear all; close all; clc;
% seedss = [10 19 31 56 57 72 83 85 92,...
%           107 119 121 130 141 148 151 163 172 177,...
%           202 204 221 232 233 235 236 248 263 265 266 270 279 286 287,...
%           300 308 311 318 320 328 329 330 351 355 365 375 377 381 394 395 396,...
%           403 406 409 415 416 420 426 428 436 437 445 449 455 457 458 461 478,...
%           511 515 521 522 533 538 556 558 562 587 592,...
%           605 616 638 640 651 655 657 660 662 664 679 680 683 684,...
%           702 710 726 727 732 735 740 741 754 759 769 775 790,...
%           807 812 827 844 846 850 858 871 880 891,...
%           902 908 909 932 936 938 952 964 975 981 982]-1;
seedss = 0:1000;
n_seed = length(seedss);
time_steps_to_failure_bin = zeros( 500, n_seed );
matlabpool open 5;
parfor idx0 = 1:n_seed
    seednum = seedss( idx0 );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pause_time                        = 0.001;
min_trial_length_to_start_display = 10000;
display_started                   = 0;
display_at_all                    = 0;
NUM_STATES                        = 163;
GAMMA                             = 0.995; % Discount factor
TOLERANCE                         = 0.01;
NO_LEARNING_THRESHOLD             = 20;
time                              = 0; % Time step of the simulation
num_failures                      = 0;
time_at_start_of_current_trial    = 0;
max_failures                      = 500; % should be enough for convergence
time_steps_to_failure             = zeros( max_failures, 1 );
x                                 = 0.0; % the actual state vector
x_dot                             = 0.0; % starting state (0 0 0 0)
theta                             = 0.0;
theta_dot                         = 0.0;
state                             = get_state(x, x_dot, theta, theta_dot);
% the number given to this state
% only consider this representation of the state

if display_at_all == 1 &&...
        ( min_trial_length_to_start_display == 0 || display_started == 1 )
    show_cart( x, x_dot, theta, theta_dot, pause_time );
end

%seednum   = 9;
stream    = RandStream.create('mt19937ar','seed',seednum);
RandStream.setDefaultStream( stream );

%%% initialization. Assume no transitions or rewards have been observed
value_fun = rand ( [ NUM_STATES 1] ) *.1; % rand (0, 0.10)
trans_pro = ones ( [ NUM_STATES 2 NUM_STATES ]) / NUM_STATES; % uniform
pro_numer = zeros( [ NUM_STATES 2 NUM_STATES ]);
pro_denom = zeros( [ NUM_STATES 2 ]);
rewardfun = zeros( [ NUM_STATES 1 ]);
rewardnum = zeros( [ NUM_STATES 1 ]);
rewardden = zeros( [ NUM_STATES 1 ]);

n_consecutive_good_trials = 0;

while num_failures < max_failures &&...
        n_consecutive_good_trials < NO_LEARNING_THRESHOLD

    action               = fun_choose_action( state, theta, ...
                                              trans_pro, value_fun );
    [ x, x_dot,... % Get the next state by simulating the dynamics
        theta,theta_dot] = cart_pole(action, x, x_dot, theta, theta_dot);
    new_state            = get_state(x, x_dot, theta, theta_dot);
    time                 = time + 1;

    if display_at_all == 1 && display_started == 1
        show_cart( x, x_dot, theta, theta_dot, pause_time );
    end
  
    if new_state == NUM_STATES % Reward function - do not change
        R = -1;
    else
        R = 0; % -abs(theta)/2.0;
    end
    pro_numer( state, action, new_state ) = pro_numer(state,action,...
                                                      new_state) + 1;
    pro_denom( state, action )            = pro_denom(state,action) + 1;
    rewardnum( new_state )                = rewardnum( new_state ) + R;
    rewardden( new_state )                = rewardden( new_state ) + 1;
    % in order to treat the fail state as an ordinary state, we observe the
    % reward function that is deterministic. ridiculous tho
    if new_state == NUM_STATES % Recompute MDP model whenever pole falls
        trans_pro = fun_division_1( pro_numer, pro_denom, NUM_STATES );
        rewardfun = fun_division_2( rewardnum, rewardden );
        [ value_fun, n_iter ] = fun_value_iter_synchronous( TOLERANCE,...
            GAMMA, NUM_STATES, rewardfun, trans_pro, value_fun );
        if n_iter == 1
            n_consecutive_good_trials = n_consecutive_good_trials + 1;
        else
            n_consecutive_good_trials = 0;
        end
    end
    
    if new_state == NUM_STATES % simulation control and reinitialization
        num_failures                          = num_failures + 1;
        time_steps_to_failure( num_failures ) = time -...
                                            time_at_start_of_current_trial;
        time_at_start_of_current_trial        = time;
        if display_at_all == 1
            disp( time_steps_to_failure( num_failures ) );
            if time_steps_to_failure( num_failures ) >...
                    min_trial_length_to_start_display
                display_started = 1;
            end
        end
        x         = -1.1 + rand(1)*2.2; % 0.0;
        x_dot     = 0.0;
        theta     = 0.0;
        theta_dot = 0.0;
        state     = get_state(x, x_dot, theta, theta_dot);
    else 
        state = new_state;
    end
end
disp( [ 'seed:'...
         num2str( seedss( idx0 ) ) sprintf('\n')...
        'num_failures/max_failures:'...
         num2str(num_failures) '/' num2str(max_failures) sprintf('\n')...
        'max( time_steps_to_failure ):'...
         num2str( max( time_steps_to_failure )) ] );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time_steps_to_failure_bin( :, idx0 ) = time_steps_to_failure;
end
matlabpool close;
save control_loop
