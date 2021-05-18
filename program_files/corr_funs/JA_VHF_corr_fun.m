function JA_VHF_Cvals = JA_VHF_corr_fun(sol_data_set,T_sys)
%Performs regression for Jouyban-Acree - V'ant Hoff Model

%Inputs: Formatted? Solubility Data as Table, System Temperature (deg K)
%Outputs: A1,B1,A2,B2,J0 J1 J2 model parameters in vertical vector

%sol_data_set: [1] B/Tcomp_fracP , [2] B/Tcomp_fracC, [3] solubility (open)
% this variable  must be formatted this way for this function to work!

   
    %Add 1 to limit "rank regression"
    sol_data_set{:,:} = sol_data_set{:,:};


    %create array for regression table
    % table headers: fp,fp/T, fc, fc/T, fp*fc, fp*fc*(fp-fc), fp*fc(fp-fc)^2,         
    % ln(Sm)
   
    reg_table = zeros(height(sol_data_set),8); 
    
    
    % Assign & Calculate the v'ant Hoff correlation parameters
    reg_table(:,1) = sol_data_set{:,1}; 
    reg_table(:,2) = reg_table(:,1)./T_sys;
    reg_table(:,3) = sol_data_set{:,2};
    reg_table(:,4) = reg_table(:,3)./T_sys;
    
    % calculate independent variables for regression
      %reg_table format: [1] fp , [2] fp/T , [3] fc , [4] fc/T , [5] J0ind , 
      %[6] J1ind , [7] J2ind , [8] DepReg    
     
     
    for i = 1:height(sol_data_set)
        
        
        fp = reg_table(i,1);
        fc = reg_table(i,3);          
        Sm = sol_data_set{i,3};
        
        reg_table(i,5) = (1/T_sys)*fc*fp; % for J1
        reg_table(i,6) = (1/T_sys)*fc*fp*(fc-fp); % for J2
        reg_table(i,7) = (1/T_sys)*fc*fp*(fc-fp)^2; % for J3
        reg_table(i,8) = log(Sm);
        
    end
    
    %convert to table format
    %reg_table = array2table(reg_table,'VariableNames',{'fc','fp','J0ind','J1ind','J2ind','DepReg'});
   
    % Order of Cvals: A1, B1, A2, B2, J0 , J1, J2
    JA_VHF_Cvals = regress(reg_table(:,8),[reg_table(:,1),reg_table(:,2),reg_table(:,3),...
        reg_table(:,4),reg_table(:,5),reg_table(:,6),reg_table(:,7)]);

end