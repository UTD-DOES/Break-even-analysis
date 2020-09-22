function [BenefitMM,DLMM] = ObjFunctionUpperLevel(INFO)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Lower Level MAIN FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Ali Mehmani
% Copyright: By Ali Mehmani, 2017
% ali.mehmani@gmail.com
% am4515@columbia.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SOCGlobal=0.05;
for Year = 1:INFO.YY
    for MM=1:12

        %%% READ GRID LOAD DATA - in 15min window %%%
        fname1 = ['MonthEnergy',num2str(Year),num2str(MM)];
        load(fname1);
        eval(['Power','=','MonthEnergy',num2str(Year),num2str(MM),';']);
        Power(Power<0)=0;Power=Power(:);
        Power = fillmiss(Power);
        %-----*-----*------%-----*-----*------%-----*-----*------
        INFO.Power=Power;
        INFO.SOCGlobal=SOCGlobal;
        INFO.MM=MM;
        LBDL=INFO.LBDL;UBDL=INFO.UBDL;
        %-----*-----*------%-----*-----*------%-----*-----*------        
        %%% Call Optimization  %%%
        Nv = 1; % 
        Nvc = 1;
        Nvd = 0;
        Nobj = 1;
        Nc = 0;
        Ncie = 0;
        Nce = 0;
        vartype = [0,0];
        varlim = [LBDL,UBDL];
        dvvec = [];
        max_min = 1;
        % Preparing Problem Inputs
        func_param = [Nv,Nvc,Nvd,Nobj,Nc,Ncie,Nce];
        % Preparing algorithm options
        algo_inputs = MDPSO_input_param(func_param,'Popsize',100,'InitpopGen','Sobols','Itermax',15);
        algo_control = MDPSO_control_param(func_param);
        run_options = MDPSO_run_options('display','off', 'plotconv', 'off','plotinterval','off');
        optim = MDPSO('ObjFunctionLower', func_param, max_min, vartype, varlim, dvvec, algo_inputs, algo_control, run_options,INFO);            
        BenefitMM(Year,MM)=-1*optim.obj;
        DLMM(Year,MM)=optim.var;
        
        %%%% Read from upper level %%%%%%%%%%%%%%%%%%%%%%%%
        Power=INFO.Power;
        SOCGlobal=INFO.SOCGlobal;
        M=INFO.MM;
        Y=INFO.YY;
        L=DegradationModel(INFO.SOC,Y);
        Capacity=INFO.Capacity/L;
        ReteHR=INFO.ReteHR;
        DL=x; % Design Variable, Demand Limit
        [~,SOC_Mo(MM)]=DLController(Power,Capacity,DL,SOCGlobal,ReteHR,Y,M);
        
    end
    INFO.SOC=mean(SOC_Mo);
end

end % end function
