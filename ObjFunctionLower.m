function [f, C_eq, C_ineq] = ObjFunctionLower(x,INFO)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x : Monthly Demand Limit
C_ineq=[];
C_eq=[];
%%%% Read from upper level %%%%%%%%%%%%%%%%%%%%%%%%
Power=INFO.Power;
SOCGlobal=INFO.SOCGlobal;
M=INFO.MM;
Y=INFO.YY;
    if Y==1
        L=1;
    else
    L=DegradationModel(INFO.SOC,Y-1);
    end
Capacity=INFO.Capacity/L;
ReteHR=INFO.ReteHR;
DL=x; % Design Variable, Demand Limit
[PowerGrid_Mo,SOC_Mo]=DLController(Power,Capacity,DL,SOCGlobal,ReteHR,Y,M);
[ElectricityCostWBat,~,~]=TariffModel(PowerGrid_Mo,M,Y);
[ElectricityCostNoBat,~,~]=TariffModel(Power,M,Y);
f=-1*(ElectricityCostNoBat-ElectricityCostWBat);% Monthly Cost
end