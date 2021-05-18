function [lng] = NRTL_lng(x,alpha,tor)
%NRTL function that outputs ln(gamma), i.e. natural log of the activity
%coefficients
% x : row vector of mole fractions of lenght nc
% alpha : value of non-randomness interaction parameter
% tor: nc by nc array of binary interaction parameters
% lng: row vector of ln(gamma) of length nc
    
    nc = length(x); % nc = number of components

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

