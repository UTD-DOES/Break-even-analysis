function L=DegradationModel(SOC,Year)
% % C : Capacity Loss = Calender loss + Cycclic loss
% % Input 
% % t : storage time [Day]
% % Parameter:
% % SoC =  average State of Charge in a year
% B=0;
% %T=25;
% Closs_cal = [165400*exp(-4148*T^(-1))*exp(0.01*SOC)-B]*t^(0.5);
% %Closs_cyc = (-0.14-0.08*DOD+1.92*DOD^(0.5)-2.51*ln(DOD))*(0.48*Crate^2-2.42*Crate+1.57)*t^(0.8);
% Closs_cyc=0;
% CLoss=Closs_cal+Closs_cyc;
S=SOC;
Tref=25;
D=1-.8857;
T=25;
A=5.75E-2;B=121;
t=Year*365*24*3600;
St=4.1400e-10*t;
Ssigma=exp(1.04*(S-0.50));
ST=exp((6.93*10^(-2))*(T-Tref)*(Tref/T));
Sd=(1.40E5*D^(-5.01E-1)-1.23E5)^(-1);
C=(St+Sd)*Ssigma*ST;
L=1-A*exp(-1*B*C)-(1-A)*exp(-1*C);
%
% The formulation is borrowed from:
% Xu, Bolun, Alexandre Oudalov, Andreas Ulbig, Goran Andersson, and Daniel Kirschen.
% "Modeling of lithium-ion battery degradation for cell life assessment." IEEE Transactions on Smart Grid (2016).