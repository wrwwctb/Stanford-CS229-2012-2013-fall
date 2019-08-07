function trans_pro = fun_division_1( pro_numer, pro_denom, NUM_STATES )
    trans_pro = zeros( size(pro_numer) );
    for idx1 = 1:NUM_STATES
        trans_pro(:,:,idx1) = pro_numer(:,:,idx1) ./ pro_denom;
    end
    trans_pro( isnan( trans_pro ) ) = 1/NUM_STATES;
end
