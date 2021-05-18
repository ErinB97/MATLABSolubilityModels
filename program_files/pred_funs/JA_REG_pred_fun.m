function Sm = JA_REG_pred_fun(fc,Sc,fp,Sp,J0,J1,J2)
%Creates solubility predictions using Jouyban-Acree - Regular Model
%Inputs: pred_format , JA_REG_Cvals
%Outputs: Table of Solubility Predictions
    
    Sm = exp(fc*log(Sc) + fp*log(Sp) + fc*fp*(J0 + J1*(fc-fp) + J2*(fc-fp)^2 ) ) ;
    
        
end