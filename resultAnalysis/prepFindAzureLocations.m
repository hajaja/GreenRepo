clear all;
load ../wind/ds_merged_fanxin.mat;

%% find the 10 locations
% California, Washington, Oregon, Illinois, Georgia, Virginia, 
% Texas, Florida, North Carolina, and South Carolina
stateNames = ['VA';'IL'; 'CA'; 'IA'; 'TX'];
stateIndexs = [];
for n = 1:length(stateNames)
    stateName = stateNames(n, :);
    for i = 1:length(ds)
        if strcmp(ds(i).state, stateName)
            stateIndexs = [stateIndexs; i];
            break;
        end
        
        if i == length(ds)
            stateName
        end
    end
end
save('../data/stateIndexs_using_ds_calculated_Azure', 'stateIndexs', 'stateNames');
