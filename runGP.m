function YStar = runGP(XTrain,YTrain,XTest,numinstances_train,numinstances_test,numfeatures)
% prepare data 
XTrain = [XTrain{:}]; 
XTrain = cell2mat(XTrain); 
XTrain = double(reshape(XTrain,numinstances_train,numfeatures));

XTest = [XTest{:}]; 
XTest = cell2mat(XTest); 
XTest = double(reshape(XTest,numinstances_test,numfeatures));

YTrain = [YTrain{:}]; 
YTrain = cell2mat(YTrain); 
YTrain = double(reshape(YTrain,numinstances_train,1));

meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [zeros(numfeatures,1); 0];
covfunc = @covSEiso;
ell = 1/4; sf = 1; hyp.cov = log([ell; sf]);
likfunc = @likGauss; sn = 0.1; hyp.lik = log(sn);

hyp = minimize(hyp, @gp, -100, @infExact, meanfunc, covfunc, likfunc, XTrain, YTrain);

YStar = gp(hyp, @infExact, meanfunc, covfunc, likfunc, XTrain, YTrain, XTest);
%hold on;plot(YTest,'g');hold off;
%corrcoef(YTest,YStar)

