function [OptimumCapacity_Weighted,OptimumCapacity_WeightedLB,OptimumCapacity_WeightedUB] =FindOptimumCapacity(PR,ReteHR,Y,LifeY,TuneParameter,UBCapacity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 1 Find 15min maximum in year
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Year=1:LifeY %% This part is NEW
    for MM=1:12
        %%% READ GRID LOAD DATA - in 15min window %%%
        fname1 = ['MonthEnergy',num2str(Year),num2str(MM)];
        load(fname1);
        eval(['Power','=','MonthEnergy',num2str(Year),num2str(MM),';']);
        Power(Power<0)=0;Power=Power(:);
        Power = fillmiss(Power);
        MaxPeak(MM)=max(Power);
    end
    [MaxPeakValue(Year),MaxPeakMM(Year)]=max(MaxPeak);
    DL(Year)=(1-PR)*MaxPeakValue;
    % Will be added: JIE's Group Lower and Upper Bounds of this DL based on the
    % predicted uncertainties:
    % DL_lower...
    % DL_upper....
    % Noted that the lower and upper bounds for the histrical data are
    % zero!
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 2 Find the capacity for these DLs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for Year=1:LifeY %% This part is NEW
    % For each Year: Reading the data for the peak month  
    fname1 = ['MonthEnergy',num2str(Year),num2str(MaxPeakMM(Year))];
    load(fname1);
    eval(['Power','=','MonthEnergy',num2str(Year),num2str(MaxPeakMM),';']);
    Power(Power<0)=0;Power=Power(:);
    Power = fillmiss(Power);

        InfoPre.p1 = Power;InfoPre.p2 = DL(Year);InfoPre.p3 = ReteHR;
        InfoPre.p4 = Y;InfoPre.p5 = MaxPeakMM;InfoPre.p6=LifeY;
        InfoPre.p7 = TuneParameter;
        %%% Call Optimization  %%%
        Nv = 1; % x_1:Capacity, x_2:BatCost
        Nvc = 1;
        Nvd = 0;
        Nobj = 1;
        Nc = 0;
        Ncie = 0;
        Nce = 0;
        vartype = [0,0];
        varlim = [1,UBCapacity];
        dvvec = [];
        max_min = 1;
        % Preparing Problem Inputs
        func_param = [Nv,Nvc,Nvd,Nobj,Nc,Ncie,Nce];
        % Preparing algorithm options
        algo_inputs = MDPSO_input_param(func_param,'Popsize',100,'InitpopGen','Sobols','Itermax',15);
        algo_control = MDPSO_control_param(func_param);
        run_options = MDPSO_run_options('display','off', 'plotconv', 'off','plotinterval','off');
        optim = MDPSO('ObjFunFindOptimumCapacity', func_param, max_min, vartype, varlim, dvvec, algo_inputs, algo_control, run_options,InfoPre);
        OptimalCapacityInit=optim.var;
        SOC_init=0.5;
        L=DegradationModel(SOC_init,Year);
        OptimumCapacity(Year)=OptimalCapacityInit/L;
        
        % DO THE SAME PROCESS FOR THE LOWER AND UPPER DLs
        % So we have: 
        % OptimumCapacity_lb = ..
        % OptimumCapacity_ub = ..
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 3 Find the optimal capacity 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Weighted average of OptimumCapacity the based on the Error %%%%

% OptimumCapacity_Weighted =.....
% OptimumCapacity_WeightedLB = .....
% OptimumCapacity_WeightedUB = .....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end