%% predict_pets
% get predictions from predict files

%%
function [prdData, info] = predict_pets(parGrp, data, auxData)
% created 2015/01/17 by Goncalo Marques, modified 2015/03/30 by Goncalo Marques
% modified 2015/08/03 by Starrlight, 2015/08/26 by Goncalo Marques, 2018/05/22 by Bas Kooijman

%% Syntax
% [prdData, info] = <../predict_pets.m *predict_pets*>(parGrp, data, auxData)

%% Description
% get predictions from predict files
%
% Input
% 
% * parGrp: structure with par for several pets
% * data: structure with data for several pets
% * auxData: structure with auxiliary data for several pets
%
% Output
%
% * prdData: structure with predictions for several pets
% * info: scalar with combined success (1) or failure (0) of predictions
 
global pets toxs 

info = 0;
parPets = parGrp2Pets(parGrp); % convert parameter structure of group of that of pets 

% produce predictions
n_pets = length(pets);
n_toxs = length(toxs);
for i = 1:n_pets
  if n_toxs == 0
    [prdData.(pets{i}), info] = feval(['predict_', pets{i}], parPets.(pets{i}), data.(pets{i}), auxData.(pets{i}));
    if ~info
      return;
    end
  else
    for j = 1:n_toxs
      [prdData.(pets{i}).(toxs{j}), info] = feval(['predict_', pets{i}, '_', toxs{j}], parPets.(pets{i}), data.(pets{i}).(toxs{j}), auxData.(pets{i}).(toxs{j}));
      if ~info
        return;
      end
    end
  end
  
  % predict pseudodata
  prdData.(pets{i}) = predict_pseudodata(parPets.(pets{i}), data.(pets{i}), prdData.(pets{i}));
end
      