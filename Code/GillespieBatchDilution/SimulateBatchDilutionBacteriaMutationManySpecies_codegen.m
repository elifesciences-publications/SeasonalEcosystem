% SIMULATEBATCHDILUTIONBACTERIAMUTATIONMANYSPECIES_CODEGEN   Generate
%  MEX-function SimulateBatchDilutionBacteriaMutationManySpecies_mex from
%  SimulateBatchDilutionBacteriaMutationManySpecies.
% 
% Script generated from project
%  'SimulateBatchDilutionBacteriaMutationManySpecies.prj' on 27-Apr-2018.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.MexCodeConfig'.
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.EnableJIT = true;

%% Define argument types for entry-point
%  'SimulateBatchDilutionBacteriaMutationManySpecies'.
ARGS = cell(1,1);
ARGS{1} = cell(4,1);
ARGS{1}{1} = coder.typeof(0,[Inf  1],[1 0]);
ARGS_1_2 = struct;
ARGS_1_2.isneutral = coder.typeof(false);
ARGS_1_2.m = coder.typeof(0);
ARGS_1_2.m_initial = coder.typeof(0);
ARGS_1_2.E = coder.typeof(0);
ARGS_1_2.S = coder.typeof(0,[Inf 1]);
ARGS_1_2.p = coder.typeof(0);
ARGS_1_2.kc = coder.typeof(0);
ARGS_1_2.nu = coder.typeof(0);
ARGS_1_2.uniformStrategies = coder.typeof(false);
ARGS_1_2.Strategies = coder.typeof(0,[Inf  Inf],[1 0]);
ARGS_1_2.withSpecialists = coder.typeof(false);
ARGS_1_2.n0 = coder.typeof(0,[Inf  1],[1 0]);
ARGS_1_2.randomInitialn0 = coder.typeof(false);
ARGS{1}{2} = coder.typeof(ARGS_1_2);
ARGS{1}{3} = coder.typeof(0);
ARGS{1}{4} = coder.typeof(0);

%% Invoke MATLAB Coder.
codegen -config cfg SimulateBatchDilutionBacteriaMutationManySpecies -args ARGS{1} -nargout 6

