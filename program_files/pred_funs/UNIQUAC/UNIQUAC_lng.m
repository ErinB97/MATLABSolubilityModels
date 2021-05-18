function lng = UNIQUAC(R,Q,C,x,tor)
%This UNFIAC script is a modfication of the UNIFAC script that was given

format long g


s=size(C); %s : [ # of components, # of groups]

r=zeros(1,s(1)); %mol
q=zeros(1,s(1));
V=zeros(1,s(1)); %theta: volume fraction
F=zeros(1,s(1)); %phi : area fraction

X=zeros(1,s(2)); % 

%interaction parameter



%r and q calculation
for i=1:s(1)
   r(i)=C(i,:)*R'; 
   q(i)=C(i,:)*Q';
end  
%V and F calculation
for i=1:s(1)
    V(i)=r(i)/(x*r');
    F(i)=q(i)/(x*q');
    lnGammaC(i)=1-V(i)+log(V(i))-5*q(i)*(1-V(i)/F(i)+log (V(i)/F(i)));         %Calculation of combinatorial part
end

%Residual calculation
%{
%PSI caculation, all the values are devided by the temperature (T), for the
%diagonal values PSI=1;
SI=exp(-anm/Treactor);

% X calculation (for groups)
for i=1:s(1)
    ngroups(i)=sum(C(i,:));
    CALC1(i)=ngroups(i)*x(i);%This i iust a middle calculator for the calculation of X
end
CALC2=sum(CALC1);

for i=1:s(2)
    CALC3(i)=x*C(:,i);
end
Xgroups=CALC3/CALC2;
%teta for groups
for i=1:s(2)
    teta(i)=Xgroups(i)*Q(i)/sum(Xgroups.*Q);
end
%middle calculation for group Gamma calculations
for i=1:s(2) 
    CALC4(i,:)=teta.*SI(i,:);
end
for i=1:s(2) 
    CALC5(i,:)=teta.*SI(:,i)';
end
for i=1:s(2)
    for i=1:s(2)
        CALC6(i)=CALC4(i,i)/sum(CALC5(i,:));
    end
    lnY(i)=Q(i)*(1-log(teta*SI(:,i))-sum(CALC6)); %Group activity coefficients for the binary system
end
%Xpure calculation
for i=1:s(1)
    for i=1:s(2)
        Xpure(i,i)=C(i,i)/sum(C(i,:));
        
    end
end
%Teta pure calculation
for i=1:s(1)
    for i=1:s(2)
      
        CALC7(i,i)=Q(i)*Xpure(i,i); 
        
    end
    tetapure(i,:)=CALC7(i,:)./sum(CALC7(i,:)); %in this case teta pure is different for each component, while it was similar for the previous case
end

%middle calculation for pure Gamma calculations
for i=1:s(1)    
    for i=1:s(2)  
        CALC8(i)=tetapure(i,:)*SI(:,i); %this is for calculation of "denominator" part
        CALC9(i,:)=tetapure(i,:).*SI(i,:);%this is for calculation of "numerator" part
    end
    for i=1:s(2)
        CALC10(i,i)=sum(CALC9(i,:)./CALC8);
        CALC11(i,i)=log(sum(tetapure(i,:).*SI(:,i)'));

    end
    for i=1:s(2)
        
        lnYpure(i,i)=Q(i)*(1-CALC11(i,i)-CALC10(i,i));

    end
end

for i=2:s(1)    
    lnY(i,:)=lnY(1,:);
end

CALCl2=C.*(lnY-lnYpure);
for i=1:s(1)
    lnGammaR(i)=sum(CALCl2(i,:));
end
%}
%Added by Erin

for i=1:s(1)
   %sum1 & sum2 are the summation terms of residual equation
   %also the commented out lines are simply another way of writing the
   %equation that reduces the volume terms for each molecule
   
   %sum1(i) = sum( V(:) .* tor(:,i));
   sum1(i) = sum( q(:) .* x(:) .* tor(:,i)) / sum(q(:) .* x(:));

  % sum2(i) = sum( (V(:) .* tor(i,:)) ./ sum1(i) );
   
   for j = 1:s(1)
      %temp1(j) = sum( V(:) .* tor(:,j));
      temp1(j) = sum( q(:) .* x(:) .* tor(:,j));

   end
   
   %sum2(i) = sum( V(:)' .* tor(i,:) ./ temp1(:)');
   sum2(i) = sum( q(:)' .* x(:)' .* tor(i,:) ./ temp1(:)');
   
   %Calculate Residual energy contribution
   lnGammaR(i) = q(i) * (1 - log(sum1(i)) - sum2(i) );
   
   % st(i)=sum( x(:) .* tor(:,i) .* G(:,i));
   % s(i) =sum( x(:) .* G(:,i));
end

lnGamma=lnGammaR+lnGammaC;


lng = lnGamma;

end