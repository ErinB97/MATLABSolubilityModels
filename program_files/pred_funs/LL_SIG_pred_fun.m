function Sm = LL_SIG_pred_fun(fc,Sp,logKow,s,t)
%Creates solubility predictions using Log-Linear: Yalkowsky Model
    Sm = 10^( log10(Sp)+ (s*logKow + t)*fc);
         
end