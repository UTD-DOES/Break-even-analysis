function [Cost,CostKw,CostKwhr]=TariffModel(EIN,M,Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% CoServ ToU Tarrid Model  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Public Buildings Time-Of-Use Rate. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
% EIN = 15-min window Energy Consumption in month
% M =   Month
% Y =   Year
% DayStr = Starting day (e.g., 1)
% Output
% Cost = Total Monthly Electricity Cost
% CostKw = Demand Cost
% CostKwhr = Energy Cost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function estimate Energy Cost [$/kwh]+[$/kw].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totKwMax=0;totKwMax2=0;totKwMax3=0;
N=eomday(Y,M);
for Day=1:N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Month and Day %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DayP=EIN((Day-1)*96+1:Day*96);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if M>=5 &&  M<=10
    MonthPeak=1;
else 
    MonthPeak=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kWhr Cost %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    KWhrCost=0.076062;% all hours
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kW Cost %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MonthPeak==0
    KWCost1=8.10;
    KWCost2=2.70;
    KWCost3=3.36;
elseif MonthPeak==1
    KWCost1=6.65;
    KWCost2=2.70;
    KWCost3=3.36;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MSCost=40;%for a month
%% Estimation
MeanP=zeros(1,24);MaxP=zeros(1,48);
for i=1:24
    ALI=DayP((i-1)*4+1:i*4);
    MeanP(i)=mean(ALI);% Mean Horly Power
end

for i=1:48
    ALI=DayP((i-1)*2+1:i*2);
    MaxP(i)=max(ALI);%   Maximum Power in 30 min interval
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kWhr Estimation %%%%%%%%%%%%%%%%%%%%%%%%
KwhrCostTotal(Day)=sum(MeanP*KWhrCost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kW Estimation %%%%%%%%%%%%%%%%%%%%%%%%%%

totKwMax=max(max(MaxP),totKwMax);
KWCost3OUT(Day)=totKwMax*KWCost3;

if MonthPeak==1
    totKwMax2=max(max(MaxP(31:33)),totKwMax2);  
else
    totKwMax2=max(max(MaxP(31:33)),totKwMax2);
end

KWCost2OUT(Day)=totKwMax2*KWCost2;

if MonthPeak==1
    totKwMax3=max(max(MaxP(32:40)),totKwMax3);  
else
    totKwMax3=max(max(max(MaxP(32:40)),max(MaxP(13:16))),totKwMax3);
end
KWCost1OUT(Day)=totKwMax3*KWCost1;
end

MountlyCost=MSCost+sum(KwhrCostTotal)+max(KWCost1OUT)+max(KWCost2OUT)+max(KWCost3OUT);
Cost=MountlyCost;
CostKw=max(KWCost1OUT)+max(KWCost2OUT)+max(KWCost3OUT);
CostKwhr=sum(KwhrCostTotal);
end