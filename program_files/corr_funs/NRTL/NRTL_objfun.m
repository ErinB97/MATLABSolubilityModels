function [F] = NRTL_objfun(tor)
    global R Tfus Tsys Hfus NRTLfun Xexp
    
    %Objective function for optimisation routine of NRTL paramater
    %estimation
    
    lng = zeros(length(Xexp),3);
    
    for p = 1:length(Xexp)
        lng(p,:) = NRTLfun(Xexp(p,:),tor);
    end
    
    %Calculate Predictated Points
    Xpred = -(Hfus/R)*(1/Tsys - 1/Tfus) - lng(:,3);  
    
    %Objective function of relative error
    F =   sum( ((Xexp(:,3)-Xpred(:))./Xexp(:,3)).^2);
end

