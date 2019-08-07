function [ value_fun, n_iter ] = fun_value_iter_asynchronous( TOLERANCE, GAMMA, NUM_STATES, rewardfun, trans_pro, value_fun )
    maxchange = inf;
    n_iter = 0;
    while  maxchange > TOLERANCE
        value_fun_temp = value_fun;
        for idx1 = 1:NUM_STATES
            value_fun( idx1 ) = rewardfun( idx1 ) + GAMMA * max( squeeze( trans_pro( idx1,:,: ) )*value_fun );
        end
        maxchange = max( abs( value_fun_temp - value_fun ) );
        n_iter    = n_iter + 1;
    end
end

