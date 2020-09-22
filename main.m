function Result=main(Rate,PR,Year,TuneParameter,UBCapacity,LBDL,UBDL)
% INPUT
% Rate : Rate of charge/discharge, {eg., 1 for 1C, 2 for 2C, 0.5 for C/2}
% PaybackYear : Payback time (Considering 10% Interest Rate)- (Considered from 3 year to 30 years)
% PR : a requiered Percentage reduction in yearly maximum peak value (in 15-min resolution)
% 0<PR<1
% Year : Year
% TuneParameter : A tune parameter in finding optimal capacity 1< <10
% UBCapacity : Epper bound for capacity in finding optimal capacity (kWh)
% LBDL : Lower bound for Demand Limit
% UBDL : Upper bound for Demand Limit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% MAIN FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
addpath('Data');
addpath('BatModel');
addpath('Optimizer');
%addpath('SolarModel');
addpath('TarifModel');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIND OPTIMUM CAPACITY
PaybackYear=5;
OptimumCapacity=FindOptimumCapacity(PR,Rate,Year,PaybackYear,TuneParameter,UBCapacity);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FIND OPTIMUM DLs
INFO.Capacity=OptimumCapacity;
INFO.YY=Year;
INFO.LifeY=PaybackYear;
INFO.ReteHR=Rate;
INFO.LBDL=LBDL;INFO.UBDL=UBDL;
[Benefits,~] = ObjFunctionUpperLevel(INFO);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NO READY %%%%%%%%
%PaybackYear=3:30;
%Pcost=PayBackEqCost(Benefits,PaybackYear,OptimumCapacity);
%Result(:,1)=PaybackYear;Result(:,2)=Pcost;
