function [sol_preds] = pred_driver(model_sel,sys_str)
%PREDICTION DRIVER
%INPUTS: model_sel (model to perform predictions) , sol_sys_str (struct
%array of required data to perform predictions), pred_info (struct array
%with information about how to run predictions)

%OUTPUTS: !!!preds_check (pass/fail on prediction), sol_preds (array of
%prediction data with co-solvent fractions)
    addpath("pred_funs\");
    addpath("pred_funs\NRTL");
    
    %Assign solvent fractions to sol_pred array
    sol_preds(:,1:2) = sys_str.sol_data(:,1:2);
    
    for i = 1:length(sys_str.sol_data)
           
        switch model_sel %Switch model to predict with
            case 'JA_REG'
                sol_preds(i,3) = JA_REG_pred_fun(sol_preds(i,2),sys_str.Sc,sol_preds(i,1),...
                    sys_str.Sp,sys_str.J0,sys_str.J1,sys_str.J2 );
                %JA_REG_pred_fun(fc,Sc,fp,Sp,J0,J1,J2)
                
            case 'LL_SIG'
                %Sm = LL_SIG_pred_fun(fc,Sp,logKow,s,t) 
                 sol_preds(i,3) = LL_SIG_pred_fun(sol_preds(i,2),sys_str.Sp,sys_str.logKow,...
                    sys_str.s, sys_str.t );
                
           case 'JA_VHF'
               %JA_VHF_pred_fun(T,fc,fp,A1,B1,A2,B2,J0,J1,J2)
                 sol_preds(i,3) = JA_VHF_pred_fun(sys_str.T,sol_preds(i,2), sol_preds(i,1),...
                   sys_str.A1, sys_str.B1, sys_str.A2,sys_str.B2, sys_str.J0,sys_str.J1,sys_str.J2 );  
            
            case 'GSM'
                %GSM_pred_fun(fp,B0,B1,B2,B3,B4)
                 sol_preds(i,3) = GSM_pred_fun(sol_preds(i,1),sys_str.B0,sys_str.B1,...
                     sys_str.B2,sys_str.B3,sys_str.B4);   
                 
            case 'NRTL'
                
                lng = NRTL_lng([sol_preds(i,1:2),0],sys_str.alpha,sys_str.TOR);
                
                sol_preds(i,3) = exp(-(sys_str.Hfus/8.314)*(1/sys_str.Tsys ...
                    - 1/sys_str.Tfus) - lng(3));
                
            case 'LL_IMM'
                sol_preds(i,3) = LL_IMM_pred_fun(sol_preds(i,2),sys_str.Sc,sol_preds(i,1),...
                    sys_str.Sp);
                %LL_IMM_pred_fun(fc,Sc,fp,Sp)
        end
            
    end        

            
    
end