function [f, C_eq, C_ineq]=ObjFunFindOptimumCapacity(x,InfoPre)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_eq=[];C_ineq=[];
p1=InfoPre.p1;p2=InfoPre.p2;p3=InfoPre.p3;p4=InfoPre.p4;p5=InfoPre.p5;p6=InfoPre.p6;p7=InfoPre.p7;
[PowerGrid_Mo,~]=DLController(p1,x,p2,0.95,p3,p4,p5);
[f1,~,~]=TariffModel(PowerGrid_Mo,p5,p4);
f2=EQCost(p7,p6,x);
f=f1+f2;
end