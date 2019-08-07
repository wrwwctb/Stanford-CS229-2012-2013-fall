function rewardfun = fun_division_2( rewardnum, rewardden )
    rewardfun                       = rewardnum ./ rewardden;
    rewardfun( isnan( rewardfun ) ) = 0;
end

