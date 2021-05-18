function Sm = JA_SIG_pred_fun(fc,sigma,fp,Sp,J0,J1,J2)
%Creates solubility predictions using Jouyban-Acree - Regular Model
%Inputs: pred_format , JA_REG_Cvals
%Outputs: Table of Solubility Predictions
    
    Sm = 10^(fc*(log10(Sp) -  sigma) + fp*log10(Sp) + fc*fp*(J0 + J1*(fc-fp) + J2*(fc-fp)^2 ) ) ;
    
        
end