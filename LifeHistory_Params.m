function LifeHistory_Params(Lf) 

% Specify life history parameters to be used in the model

Amax = 20 ; % Number of age classes (max age is Amax-1 bc start counting at age 0) %%% Vai de 0 a 19, logo tem 20 classes
a = 1 ; % constant in betacdf function (positive concavity) %%% Concavidade negativa

% Reproduction 
c = 7.04 ;  % Constant in fecundity relationship %%% v do artigo 
e = 2.95 ;  % Exponent in allometric relationship %%% w do artigo
K = 0.000003 ;  % Slope of fert. fxn parameter 
X = 0.09 ;  % Intercept of fertilization fxn parameter

% vonBert Growth
D = zeros(2,Amax) ;  %%% Cria uma matriz 2*20 de zeros
D(1,:) = (0:(Amax-1)) ; %%% Enche a primeira linha, todas as colunas de 0 a 19
D(2,1) = 8 ; %%% Poe o valor 8 na segunda linha, primeira coluna
k = 0.05 ; %original shape  %%% k do artigo
Linf = 90 ;  %%% Linf do artigo
T0 = -1.875 ; % Age at size 0 (gives it 8cm at size 0) %%% a0 do artigo
D(2,:) = Linf.*(1-exp(-k.*((0:(Amax-1))-T0))) ; %%% La do artigo - expressao 5 da pag.228

% Recruitment 
%uA = 0.42
%uA = 0.28
uA = 0.35 ;  % Adult mortality %%% miuA do artigo - mortalidade natural
Surv = exp(-uA.*D(1,:)'); %%% exp(-miuA * trans(classes da idade)) -> -0.35*[0,1,...,19]'
EggProd = c.*(D(2,:)').^e ; %%% v*La^w do artigo (parte da expressao 6)
% Stand-in maturity function to calculate LEP_unfished
Lm = 20 ; % Length at which 50% of fish mature %%% Lm do artigo
q = 1 ;  % Shape parameter in maturity function %%% q do artigo
% Probability of Maturity 
M_tmp = 1./(1+exp(-q.*((D(2,:)')-Lm)));  %%% pM(La) - expressao 8 do artigo
% Stock-recruitment function
CRT = 0.25; % Critical value of LEP for persistence %%% CTR do artigo - critical replacement threshold 
LEP_unfished = ((sum(Surv.*EggProd.*M_tmp))/2); %%% (sum(survival to age a * fecundidade to age a))/2
Alpha = 1/(CRT*LEP_unfished);  % BevHolt params. %%% alpha da tabela 2?? - density-independent beverton-holt settler survival
Beta = 1  ; %%% asymptotic beverton-holt maximum recruit density

% Adult Survival
r =1;  % Steepness of selectivity curve %%% r do artigo
isfished=nan(Amax,1) ; % Fishing mortality by age %%% vetor com 20 linhas e uma coluna
isfished(:,1)=1./(1+exp(-r.*((D(2,:)')-Lf))) ; %%% seletividade - expressao 3 da pag.228

save lifehistory_params.mat
clear 

% Parameters specific to each sex-change mode:
%--------------------------------------------------------------------------
% SC1 - Absolute Length
Lm = 20 ; % Length at which 50% of fish mature  %%% Lm do artigo
q = 1 ;  % Shape parameter in maturity function %%% q do artigo
Lc = 30 ;  % Length at which 50% of fish change sex %%% Lc do artigo  
p = 1 ; % Shape param. in sex change function %%% p do artigo

save SC1_params.mat
clear 

%--------------------------------------------------------------------------
% SC2 - Mean Length
Lm = 4 ; % Difference from the mean size at which prob. of maturity is 0.5 %%% Lm do artigo
q = 1 ;  % Shape parameter in maturity function %%% q do artigo
Lc = 14 ; % Difference from the mean size at which prob. sex change is 0.5 %%% Lc do artigo
p = 1 ;  % Shape parameter in sex change fxn %%% p do artigo

save SC2_params.mat
clear 

%--------------------------------------------------------------------------
% SC3 - Frequency of Smaller Individuals
Fm = 0.60 ; %%% Fm do artigo
%Fm = 0.50 ; % Frequency of smaller individuals where prob. of maturity is 0.5
q = 50 ;  % Shape parameter in maturity function %%% q do artigo
Fc = 0.67 ; %%%  Fc do artigo
%Fc = 0.67 ; %********* %Fc = 0.67 ;  % Frequency of smaller mature indiv where prob of sex change is 0.5
p = 50 ;  % Shape parameter in sex change fxn %%% p do artigo

save SC3_params.mat


