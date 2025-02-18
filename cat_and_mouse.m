function PRO = cat_and_mouse(feat,label,opts)
% Parameters
lb    = 0;
ub    = 1; 
thres = 0.05; 
Pmut  = 0.06;   % mutation probability

if isfield(opts,'N'), N = opts.N; end
if isfield(opts,'T'), max_Iter = opts.T; end
if isfield(opts,'Pmut'), Pmut = opts.Pmut; end 
if isfield(opts,'thres'), thres = opts.thres; end

% Double population size: Main = cat + mouse (1)
N   = N + N;
% Objective function
fun = @FitnessFunction; 
% Number of dimensions
dim = size(feat,2); 
% Initial 
X   = zeros(N,dim); 
for i = 1:N
	for d = 1:dim
    X(i,d) = lb + (ub - lb) * rand(); 
  end
end
% Fitness
fit  = zeros(1,N); 
fitG = inf;
for i = 1:N
  fit(i) = fun(feat,label,(X(i,:) > thres),opts); 
  % Best update
  if fit(i) < fitG
    fitG = fit(i);
    Xgb  = X(i,:);
  end
end
% Sort cat & mouse (2)
[fit, idx] = sort(fit,'ascend'); 
X          = X(idx,:); 
% Pre
XCnew   = zeros(N / 2, dim); 
XMnew   = zeros(N / 2, dim); 
fitCnew = zeros(1, N / 2); 
fitMnew = zeros(1, N / 2); 
curve = zeros(1,max_Iter);
curve(1) = fitG;
t = 2;
% Iteration
while t <= max_Iter
  % Divide cat & mouse
  XC   = X(1 : N / 2, :); 
  fitC = fit(1 : N / 2);
  XM   = X(N / 2 + 1 : N, :); 
  fitM = fit(N / 2 + 1 : N);
  % Select best cat individual
  [~, idxC] = min(fitC);
  XC_best   = XC(idxC,:);
  % Select best mouse individual
  [~, idxM] = min(fitM);
  XM_best   = XM(idxM,:);
  % Compute mean of cat
  XC_mean   = mean(XC,1); 
  % Compute worst of cat
  [~, idxW] = max(fitC); 
  XC_worst  = XM(idxW,:);
  % [cat population] 
  
  I =  round(1 + rand);
  
  for i = 1 : N / 2
    for d = 1:dim
      % Generate new cat (3)
      XCnew(i,d) = XC(i,d) + rand() * (XM(i,d) - I * XC(i,d)); % XC_best(d)
      % Mutation (6)
      if rand() < Pmut
        % Normal random number with mean = 0 & sd = 1 
        G = 0 + 1 * randn();
        % Mutation
        XCnew(i,d) = XCnew(i,d) + G;
      end
    end
    % Boundary 
    XB = XCnew(i,:); XB(XB > ub) = ub; XB(XB <lb) = lb; 
    XCnew(i,:) = XB;
    % Fitness of new cat 
    fitCnew(i) = fun(feat,label,(XCnew(i,:) > thres),opts); 
  end  
  % [mouse population] 
  
  fitH = zeros(N/2,1)'; 
  
  for i = 1 : N / 2
    for d = 1:dim
        
        h(i,d)=X(i,d);
        
      % Calculate pattern (5)
      pattern    = (XC_best(d) + XC_mean(d) + XC_worst(d)) / 3; 
      % Generate new mouse (4)
      XMnew(i,d) = XM(i,d) + rand() * (h(i,d) - 1 * XM(i,d))* sign(fitM(i) - fitH(i)); 
      % Mutation (7)
      if rand() < Pmut
        % Normal random number with mean = 0 & sd = 1 
        G = 0 + 1 * randn();
        % Mutation
        XMnew(i,d) = XMnew(i,d) + G;
      end
    end
    % Boundary 
    XB = XMnew(i,:); XB(XB > ub) = ub; XB(XB <lb) = lb;
    XMnew(i,:) = XB;
    % Fitness of new cat 
    fitMnew(i) = fun(feat,label,(XMnew(i,:) > thres),opts);
  end
  % Merge all four groups
  X   = [XC; XM; XCnew; XMnew];
  fit = [fitC, fitM, fitCnew, fitMnew];
  % Select the best N individual
  [fit, idx] = sort(fit,'ascend');
  fit        = fit(1:N);
  X          = X(idx(1:N),:);
  % Best update
  if fit(1) < fitG
    fitG = fit(1);
    Xgb  = X(1,:);
    
  end
  curve(t) = fitG; 
  
  t = t + 1;
end
% Select features based on selected index
Pos   = 1:dim;
[Sf, index]   = mink(Xgb,10);
sFeat = feat(:,index); 
% Store results
PRO.sf = Sf; 
PRO.index = index;
PRO.ff = sFeat; 
PRO.nf = length(Sf);
PRO.c  = curve; 
PRO.f  = feat; 
PRO.l  = label;
end
