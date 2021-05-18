function JA_REG_Cvals = JA_REG_corr_fun(sol_data_set)
%Performs regression for Jouyban-Acree - Regular Model
%Inputs: Formatted? Solubility Data as Table
%Outputs: J0 J1 J2 model parameters in vertical vector
%sol_data_set: [1] Bcomp_fracP , [2] Bcomp_fracC, [3] solubility(?)
% this variable  must be formatted this way for this function to work!


    
    %Set Sc & Sp
     
    Sp = sol_data_set{1,3};
    Sc = sol_data_set{end,3};
   
    %create array for regression table
    % table headers: fp, fc, fp*fc, fp*fc*(fp-fc), fp*fc(fp-fc)^2,         
    % ln(Sm) - fc*ln(Sc) - fp*ln(Sp)
   
    reg_table = zeros(height(sol_data_set),6); 
    
    
    % assign fc from sol_data_set, then calculate fp values 
    reg_table(:,1) = sol_data_set{:,1}; 
    reg_table(:,2) = sol_data_set{:,2};
    
    % calculate independent variables for regression
     %reg_table format: [1] fc , [2] fp , [3] J0ind , [4] J1ind , [5] J2ind
     %[6] DepReg
    for i = 1:height(sol_data_set)
        
        fp = reg_table(i,1);
        fc = reg_table(i,2);     
        Sm = sol_data_set{i,3};
        
        reg_table(i,3) = fc*fp; % for J1
        reg_table(i,4) = fc*fp*(fc-fp); % for J2
        reg_table(i,5) = fc*fp*(fc-fp)^2; % for J3
        reg_table(i,6) = log(Sm) - fc*log(Sc) - fp*log(Sp);
    end
    
    %convert to table format
    %reg_table = array2table(reg_table,'VariableNames',{'fc','fp','J0ind','J1ind','J2ind','DepReg'});
   
    %JA_REG_Cvals = regress(comb_eth_reg.DepReg,[comb_eth_reg.J1ind, comb_eth_reg.J2ind, comb_eth_reg.J3ind])
    JA_REG_Cvals = regress(reg_table(:,6),[reg_table(:,3),reg_table(:,4),reg_table(:,5)]);

end