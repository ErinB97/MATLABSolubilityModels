function [c,ceq] = NRTL_NLcon(x)
    %Non-Linear constrant for NRTL optimisation, restricts Tii & Tjj
    %interaction parameters to be = 0
    c = [];
    ceq = eye(3).*x*ones(3,1);
end

