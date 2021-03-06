function [ Data_out ] = tensorizeDataStruct( Data )
% tensorizeDataStruct( Data )
% converts (neuron,time,trial) array into (neuron,time,condition,trial)
% array. 
% 
% If all neuron-condition pairs (for sequential, single-neuron recordings)
% or if all conditions (for simultanous recordings) saw the same number of
% trials, then the array will be of size (N,T,C,R) where R is the number of
% trials. If each neuron-condition or just condition saw a different number
% of trials, then R is the max that any saw, and other entries will be
% padded with NaNs.
%

if length(Data)==1
  % Simultaneous recordings
  structType = 1;
else
  % Sequential recordings
  structType = 2;
end

switch structType
  %% case 1
  case 1
  Y = Data.Y;
  Ys = Data.Ys;
  cond = Data.cond;
  c = length(unique(cond));
  max_r = max(histc(cond,1:c));
  [n,t,r] = size(Y);
  Y_out = nan(n,t,c,max_r);
  Ys_out = nan(n,t,c,max_r);    
  for rr = 1:r
    prev_count = sum(~isnan(Y_out(1,1,cond(rr),:)));
    Y_out(:,:,cond(rr),prev_count+1) = Y(:,:,rr);
    Ys_out(:,:,cond(rr),prev_count+1) = Ys(:,:,rr);
  end
  Data_out.Y = Y_out;
  Data_out.Ys= Ys_out;
  Data_out.cond = cond;
    
%% case2
case 2
  n = length(Data);
  c = length(unique(vertcat(Data(:).cond)));
  % get max trial counts
  for nn = 1:n
    max_r(nn) = max(histc(Data(nn).cond,1:c));
    allConds{nn} = Data(nn).cond;
  end
  t = size(Data(1).Y,1);
  Y_out = nan(n,t,c,max(max_r));
  Ys_out = Y_out;
  for nn = 1:n
    Y = Data(nn).Y;
    Ys = Data(nn).Ys;
    cond = Data(nn).cond;           
    r = size(Y,2);
    for rr = 1:r
      prev_count = sum(~isnan(Y_out(nn,1,cond(rr),:)));
      Y_out(nn,:,cond(rr),prev_count+1) = Y(:,rr);
      Ys_out(nn,:,cond(rr),prev_count+1) = Ys(:,rr);
    end
  end
  Data_out.Y = Y_out;
  Data_out.Ys = Ys_out;
  Data_out.cond = allConds;
end

end

