function GSM_Cvals = GSM_corr_fun(sol_data_set)
%Performs regression for General Single Model
%Inputs: Formatted? Solubility Data as Table
%Outputs: B0, B1, B2, B3, B4 model parameters in vertical vector
%sol_data_set: [1] Bcomp_fracP , [2] Bcomp_fracC, [3] solubility(?)
% this variable  must be formatted this way for this function to work!


    

    %create array for regression table
    % table headers: zeros, fp, fp^2, fp^3, fp^4 , ln(Sm)
  
   
    reg_table = zeros(height(sol_data_set),6); 
    
    reg_table(:,1) = ones(height(sol_data_set),1);
    reg_table(:,2) = sol_data_set{:,1}.^1;
    reg_table(:,3) = sol_data_set{:,1}.^2;
    reg_table(:,4) = sol_data_set{:,1}.^3;
    reg_table(:,5) = sol_data_set{:,1}.^4;
    reg_table(:,6) = log(sol_data_set{:,3});
    

     %reg_table format: [1] B0 , [2] B1 , [3] B2 , [4] B3 , [5] B4 ,[6] DepReg
 
    GSM_Cvals = regress(reg_table(:,6),[reg_table(:,1),reg_table(:,2),reg_table(:,3),reg_table(:,4),reg_table(:,5)]);

end