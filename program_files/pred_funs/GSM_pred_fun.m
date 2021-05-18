function Sm = GSM_pred_fun(fp,B0,B1,B2,B3,B4)
%Creates solubility predictions using General Single Model
%Inputs:  GSM_Cvals
%Outputs: Table of Solubility Predictions
    
    Sm = exp( B0 + B1*fp + B2*fp^2 + B3*fp^3 + B4*fp^4 ) ;
    
        
end