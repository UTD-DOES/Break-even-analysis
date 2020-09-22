function Pcost=PayBackEqCost(Benefits,LifeY,Capacity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate Cos of Bat. in different Payback time
% input
% Capacity :Nominal capacity of the Battery [kW-hr] or [Amp-hr] (1D)
% LifeY (e.g. from 1 to 30 years)
% Cost benefit form ToU tarif structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:max(size(LifeY))
r=0.1;% Interest Rate (Predefined Number)
k=LifeY(i); %Number of annual payments
FCR=(r)*(1+r)^k/((1+r)^k-1);
IC=2000; %One time installation fee ($)
DIFF=sum(Benefits);
Pcost(i)=([(DIFF/FCR)-IC]/Capacity);
end
end