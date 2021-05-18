%-------------------------------Script Set-Up------------------------------
clear all
format short
addpath("pred_funs\");
addpath("corr_funs\");

%Add NRTL function folders to path
addpath("corr_funs\NRTL\")
addpath("pred_funs\NRTL\")

%Add UNIQUAC function folder to path
addpath("pred_funs\UNIQUAC\")
addpath("corr_funs\UNIQUAC\")


global R Tsys Tfus Hfus alpha nc NRTLfun Xexp UNIQUACfun Rg Qg Cg

%%
%---------------------------Read Solublity Data----------------------------

%Uncomment this block for UI file selection
%{
%Select File to Import System Data as Data Store
[sol_data_FILENAME,sol_data_FILEPATH] = uigetfile("../data_files");         
DataFilePathEditField.Value = [sol_data_FILEPATH,sol_data_FILENAME];
%}

sheet_name = "Prop-DS"; % Modify this line for data selection
%"Prop-DS" , "Prop-Mesa_T" , "Prop-Alan_T" , "Prop-Aspa_T"

%Import Datastore
%Un-comment first line for manual file selection
%exp_sol_DATASTORE = spreadsheetDatastore([sol_data_FILEPATH,sol_data_FILENAME]);
exp_sol_DATASTORE = spreadsheetDatastore("..\data_files\SolubilityData - Glycerol.xlsx");

%"..\data_files\SolubilityData - Glycerol.xlsx"
%"..\data_files\SolubilityData - Propanol.xlsx"
%"..\data_files\SolubilityData - PEG400.xlsx"





%Datastore set-up, can mostly be ignored
%exp_sol_DATASTORE.Sheets = sheet_name; % Modify this line for data selection
exp_sol_DATASTORE.SelectedVariableNames = {'solv_frac1','solv_frac2','solt_sol'};

%load solubility data itself
sys_sol_data = exp_sol_DATASTORE.read();
ImportedSolDataTable.Data = sys_sol_data;

%load system data for selected data set
reset(exp_sol_DATASTORE);
exp_sol_DATASTORE.Sheets = sheet_name;
exp_sol_DATASTORE.SelectedVariableNames = {'sys_T','solv_unit','sol_unit','solv_1','solv_2','solute'};
temp_table = rmmissing(exp_sol_DATASTORE.read());



%these variables are used to correlate/run the models 
sys_T =  temp_table{1,1};
sys_frac_unit =  temp_table{1,2}{:};
sys_sol_unit = temp_table{1,3}{:};
sys_solv1 = temp_table{1,4}{:};
sys_solv2 = temp_table{1,5}{:};
sys_solute = temp_table{1,6}{:};

%%
%----------------------Activity Coefficient Model Set-up-------------------
%{
R = 8.314;    % Gas Constant [J/mol K

Hfus = 91884; % Heat of Fusion [kJ / mol]
Tfus = 553.15;% Temp. of fusion [K]
Tsys = 298.15;


%NRTL Parameters
    alpha = 2 ; %NRTL non-randomness parameter
    NRTLfun = @NRTL_lng;


%UNIQUAC Parameters

    %UNIQUAC Groups - GROUP DATA AVAILABLE IN UNIQUAC_groups.txt

    %Water, 2-Propanol, Mesalazine
    % 	H20(7)   , CH2(1), CH(1) , OH(5), CH3(1), ACH (10), AC (11) , C=C (67), COO(77)
    nc = 3; %number of components in mixture
    Rg = [0.9200 , 0.6744, 0.4469, 1    , 0.9011, 0.5313 , 0.3652, 1.0613, 1.380];
    Qg = [1.4    , 0.540 , 0.228 , 1.2  ,  0.848, 0.4    ,0.120  , 0.784 , 1.200];

    Cg=  [ 1 0 0 0 0 0 0 0 0;
           0 2 1 3 0 0 0 0 0;
           0 1 0 0 1 9 3 1 1]; 
    
    UNIQUACfun = @UNIQUAC_lng;   
%}   


%%
%------------------------------Other Model Set-Up -----------------------------

%Log-Linear Model
%N/A

%Predictive Log-Linear Model
ll_s = 1.11;
ll_t = -0.5;
logKow = 4.51;

%Jouyban-Acree Model
JAREG_Cvals = JA_REG_corr_fun(sys_sol_data);

%Jouyban-Acree v'ant Hoff Model
JAVHF_Cvals = JA_VHF_corr_fun(sys_sol_data,sys_T+273.15);

%General Single Model
GSM_Cvals = GSM_corr_fun(sys_sol_data);


%{
%NRTL OPTIMISATION

Xexp = sys_sol_data{:,:};
A = [];
b = [];
Aeq = [];%eye(3);
beq = [];%zeros(1,3);
lb = [];
ub = [];
x0 = zeros(3);

%{
opts = optimoptions('fmincon',"MaxFunctionEvaluations",3.0e+5...
   ,"MaxIterations",1.0e+5,"OptimalityTolerance",1.0e-16);
%}

TOR2 = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,@mycon2);


%}



%{
%UNIQUAC OPTIMISATION
%Using the same problem definition for NRTL
Xexp = sys_sol_data{:,:};
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
x0 = (ones(3));

%{
opts = optimoptions('fmincon',"MaxFunctionEvaluations",3.0e+5...
   ,"MaxIterations",1.0e+5,"OptimalityTolerance",1.0e-20,"StepTolerance",...
   1.0e-20);
%}
TOR = fmincon(@objfunUNI,x0,A,b,Aeq,beq,lb,ub,@mycon);


%}

%%
%----------------------------------Run Model-------------------------------
 
%{

sol_preds = [linspace(0,1,21)',linspace(1,0,21)',zeros(21,1)];
%sol_preds = sys_sol_data{:,:};

for i = 1:length(sol_preds)

    %{
    %Log-Linear Model
        sol_preds(i,3) = LL_IMM_pred_fun(sol_preds(i,2),sys_str.Sc,sol_preds(i,1),...
                                        sys_str.Sp);
    %}

    %{
    Predictive Log-Linear Model
 
        sol_preds(i,3) = LL_SIG_pred_fun(sol_preds(i,2),sol_preds(1,3),logKow,...
                                        ll_s, ll_t );
    %}

    %{
    %Jouban-Acree Model
        sol_preds(i,3) = JA_REG_pred_fun(sol_preds(i,2),sol_preds(end,3),sol_preds(i,1),...
                                         sol_preds(1,3),JAREG_Cvals(1),JAREG_Cvals(2),JAREG_Cvals(3) );
    %}
    
    %{
    %Jouyban-Acree V'ant Hoff
    %JA_VHF_pred_fun(T,fc,fp,A1,B1,A2,B2,J0,J1,J2)
    sol_preds(i,3) = JA_VHF_pred_fun(sys_T + 273.15,sol_preds(i,2),sol_preds(i,1),JAVHF_CvalsT(1), JAVHF_CvalsT(2),...
    JAVHF_CvalsT(3), JAVHF_CvalsT(4), JAVHF_CvalsT(5), JAVHF_CvalsT(6), JAVHF_CvalsT(7));
    %}
    
    %{
    %General Single Model
     sol_preds(i,3) = GSM_pred_fun(sol_preds(i,1),GSM_Cvals(1),GSM_Cvals(2),GSM_Cvals(3)...
         ,GSM_Cvals(4),GSM_Cvals(5));
    %}
    
    %{
    %NRTL Model
    lng = NRTL(sol_preds(i,:),TOR);
    gamma(i,:) = exp(lng); 

    sol_preds(i,3) = (-(Hfus/R)*(1/Tsys - 1/Tfus) - lng(3));
    %sol_preds(i,3) = (-(Hfus/R)*(1/Tsys - 1/Tfus) - logG);
    
    %}
    
    %{
    %UNIQUAC Model

    
    lng =  UNIQUAC(Rg,Qg,Cg, sol_preds(i,:),TOR);
    %gamma(i,:) = exp(lng);   
    
    sol_preds(i,3) = exp(-(Hfus/R)*((1/Tsys) - (1/Tfus)) - lng(3));
    %sol_preds(i,3) = - (exp(-0.023*(Tfus-Tsys)) ./(exp(lng(3))));

    %}

end
 %}

%{
 exp_preds = [sys_sol_data{:,1:2}, zeros(height(sys_sol_data),1)];
    
for i = 1:length(exp_preds)

    %{
    %Log-Linear Model
        exp_preds(i,3) = LL_IMM_pred_fun(exp_preds(i,2),sys_str.Sc,exp_preds(i,1),...
                                        sys_str.Sp);
    %}

    %{
    Predictive Log-Linear Model
 
        exp_preds(i,3) = LL_SIG_pred_fun(exp_preds(i,2),exp_preds(1,3),logKow,...
                                        ll_s, ll_t );
    %}

    %{
    %Jouban-Acree Model
        exp_preds(i,3) = JA_REG_pred_fun(exp_preds(i,2),exp_preds(end,3),exp_preds(i,1),...
                                         exp_preds(1,3),JAREG_Cvals(1),JAREG_Cvals(2),JAREG_Cvals(3) );
    %}
    
    %{
    %Jouyban-Acree V'ant Hoff
    %JA_VHF_pred_fun(T,fc,fp,A1,B1,A2,B2,J0,J1,J2)
    exp_preds(i,3) = JA_VHF_pred_fun(sys_T + 273.15,exp_preds(i,2),exp_preds(i,1),JAVHF_CvalsT(1), JAVHF_CvalsT(2),...
    JAVHF_CvalsT(3), JAVHF_CvalsT(4), JAVHF_CvalsT(5), JAVHF_CvalsT(6), JAVHF_CvalsT(7));
    %}
    
    %{
    %General Single Model
     exp_preds(i,3) = GSM_pred_fun(exp_preds(i,1),GSM_Cvals(1),GSM_Cvals(2),GSM_Cvals(3)...
         ,GSM_Cvals(4),GSM_Cvals(5));
    %}
    
    %{
    %NRTL Model
    lng = NRTL(exp_preds(i,:),TOR);
    gamma(i,:) = exp(lng); 

    exp_preds(i,3) = (-(Hfus/R)*(1/Tsys - 1/Tfus) - lng(3));
    %exp_preds(i,3) = (-(Hfus/R)*(1/Tsys - 1/Tfus) - logG);
    
    %}
    
    %{
    %UNIQUAC Model

    
    lng =  UNIQUAC(Rg,Qg,Cg, exp_preds(i,:),TOR);
    %gamma(i,:) = exp(lng);   
    
    exp_preds(i,3) = exp(-(Hfus/R)*((1/Tsys) - (1/Tfus)) - lng(3));
    %exp_preds(i,3) = - (exp(-0.023*(Tfus-Tsys)) ./(exp(lng(3))));

    %}

end
     

%} 

%{
sol_preds2 = [linspace(0,1,21)',linspace(1,0,21)',zeros(21,1)];
%sol_preds2 = sys_sol_data{:,:};

for i = 1:length(sol_preds2)

    %
    %NRTL Model
    lng = NRTL(sol_preds2(i,:),TOR2);
    %gamma(i,:) = exp(lng); 
    
    
    sol_preds2(i,3) = exp(-(Hfus/R)*((1/Tsys) - (1/Tfus)) - lng(3));
    %test(i,1) =  (-(Hfus/R)*((1/Tsys) - (1/Tfus)) - lng(3));
    
    
    %
    
end
%}

%%
%-------------------------------Plot Results-------------------------------
%{
figure
hold on; grid on;
%plot(sol_preds2(:,2),test(:,1),'r');
plot(sol_preds2(:,2),sol_preds2(:,3),'r');
plot(sys_sol_data.solv_frac2,sys_sol_data.solt_sol,'bx');
ylabel('Mesalazine Solubility (Mole Frac)');
xlabel('2-Propanol Mole Fraction');
legend('NRTL','Experimental',"Location","NorthEast");
title('Ideal Solute & NRTL Model');

%}

%{
figure
hold on; grid on;
plot(sol_preds(:,2),sol_preds(:,3),'r');
plot(sys_sol_data.solv_frac2,sys_sol_data.solt_sol,'bx');
ylabel('Mesalazine Solubility (Mole Frac)');
xlabel('2-Propanol Mole Fraction');
legend('UNIQUAC','Experimental',"Location","NorthEast");
title('Ideal Solute & UNIQUAC Model');

%}

%%
%-------------------------------Functions----------------------------------
%These functions are here are placeholders for functions to go into the 
%appropriate folders! 

%NRTL Functions

%
function lng = NRTL(x,tor)

% x : row vector of mole fractions of lenght nc

global  alpha nc


G   = exp(-alpha .* tor);

  for i=1:nc
    st(i)=sum( x(:) .* tor(:,i) .* G(:,i));
    s(i) =sum( x(:) .* G(:,i));
  end
  
S = st ./ s;

for i=1:nc
 g (i,:)=x .* G(i,:)./s;
end

for i=1:nc
  lng(i)=S(i)+sum(g(i,:).*(tor(i,:)-S));
end

end

function F = objfun(tor)
    global R Tfus Tsys Hfus NRTLfun Xexp
    
    lng = zeros(length(Xexp),3);
    
    for p = 1:length(Xexp)
        lng(p,:) = NRTLfun([Xexp(p,1:2),0],tor);
    end
    
    %Calculate Predictated Points
    for p = 1:length(Xexp)
        Xpred(p,1) = exp(-(Hfus/R)*((1/Tsys) - (1/Tfus)) - lng(p,3));  
    end
    %Objective function of relative error
    F =   sum( ((Xexp(:,3)-Xpred(:))./Xexp(:,3)).^2);
    
  

    %relative error seems to be better
    %F = sum((Xexp(:,3)-Xpred(:)).^2);
end
%}
function [c,ceq] = mycon(x)
        %Non-Linear constrant for NRTL optimisation, restricts Tii & Tjj
        %interaction parameters to be = 0
        c = [];
        
        %NRTL
        %ceq = eye(3).*x*ones(3,1);
        
        %UNIQUAC
        ceq = eye(3).*x*ones(3,1) - 1;
end

function [c,ceq] = mycon2(x)
        %Non-Linear constrant for NRTL optimisation, restricts Tii & Tjj
        %interaction parameters to be = 0
        c = [];
        
        %NRTL
        ceq = eye(3).*x*ones(3,1);
        

end

function F = objfunUNI(tor)
 global R Tfus Tsys Hfus UNIQUACfun Xexp Rg Qg Cg
    
    lng = zeros(length(Xexp),3);
    
    for p = 1:length(Xexp)
        Xin = [Xexp(p,1:2),0];
        %Xexp(p,:)
        lng(p,:) = UNIQUACfun(Rg,Qg,Cg, Xin,tor);
    end
    
    %Calculate Predictated Points

    Xpred = exp(-(Hfus/R)*(1/Tsys - 1/Tfus) - lng(:,3));  
    %Xpred = - (exp(-0.023*(Tfus-Tsys)) ./(exp(lng(:,3))));
    
    %Objective function of relative error
    F =   sum( ((Xexp(:,3)-Xpred(:))./Xexp(:,3)).^2);
    
    %relative error seems to be better
    %F = sum((Xexp(:,3)-Xpred(:)).^2);
    
    if F < 2121.9
     %  disp('WHOOHOO'); 
    end
end