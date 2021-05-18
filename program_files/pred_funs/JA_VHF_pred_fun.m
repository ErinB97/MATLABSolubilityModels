function Sm = JA_VHF_pred_fun(T,fc,fp,A1,B1,A2,B2,J0,J1,J2)
%Creates solubility predictions using Jouyban-Acree - V'ant Hoff Model
%Inputs: pred_format , JA_VHF_Cvals
%Outputs: Table of Solubility Predictions
    
    Sm = exp(fc*(A2+B2/T) + fp*(A1+B1/T) + (1/T)*fc*fp*(J0 + J1*(fc-fp) + J2*(fc-fp)^2 ) ) ;
    
        
end