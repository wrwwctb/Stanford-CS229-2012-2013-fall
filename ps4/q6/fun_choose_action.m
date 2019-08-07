function action = fun_choose_action( state, theta, trans_pro, value_fun )
    temp = squeeze(trans_pro(state,:,:))*value_fun;
    if temp(1) == temp(2) % i.e. when two actions have the same V^pi
        if ( theta < 0 )
            action = 1;% left
        elseif ( theta > 0 )
            action = 2;
        else
            if ( rand(1) < 0.5 )
                action = 1;
            else
                action = 2;
            end
        end
    else % i.e. when one action is preferred
        [ ~, action ] = max( temp );
    end
end

