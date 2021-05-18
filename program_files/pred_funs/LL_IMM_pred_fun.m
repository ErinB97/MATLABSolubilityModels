function Sm = LL_IMM_pred_fun(fc,Sc,fp,Sp)
%Creates solubility predictions using Log-Linear: Ideal Mixing Model 
    Sm = 10^(fc*log10(Sc) + fp*log10(Sp));
    
        
end