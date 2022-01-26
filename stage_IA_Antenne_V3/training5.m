function  [netfin, trfin, y2_Train, y2_TrainTrue, y2_Val, y2_ValTrue, RMSEtrain, RMSEval, n] = training5(bd, couche, epochs, ptrain, pval, ptest, mode)
    %% Normalisation des donnees (H, Fr, Wp, Lp)->(Er, Fi, Wf, Gpf, Lg, Wg)
        % Definition des entrees et sorties du reseau de neuronne
    bd = bd.bd;
    %new
        bd=bd';
        xfin=bd([1 3 5:6],:);
        yfin=bd(2,:);
        yfin2 = log(yfin+1);
        xfin2 = zeros(4,length(yfin));
        for i =1:4
            xfin2(i,:) = (xfin(i,:)-min(xfin(i,:)))/(max(xfin(i,:))-min(xfin(i,:)));
        end
    %endnew
        
    %% Entrainement du resseau de neuronne (H, Fr, Wp, Lp)->(Er, Fi, Wf, Gpf, Lg, Wg)
    if(mode == false)    
        n = permR(couche);
    else
        n = couche;
    end
    
    RMSEtrain = zeros(1,size(n,1));
    RMSEval = zeros(1,size(n,1));
    
    for i = 1:size(n,1)
        hiddenLayerSizefin =n(i,:);
        netfin  = fitnet(hiddenLayerSizefin);
        netfin.divideParam.trainRatio =ptrain/100;
        netfin.divideParam.valRatio =pval/100;
        netfin.divideParam.testRatio =ptest/100;
        netfin.trainParam.epochs=epochs;
        [netfin,trfin]=train(netfin,xfin2,yfin2);

        % Determination du meilleur choix de 'hiddenlayersize'
        y2_Train = exp(netfin(xfin2(:,trfin.trainInd))) - 1;
        y2_TrainTrue = exp(yfin2(:,trfin.trainInd)) - 1;
        y2_Val = exp(netfin(xfin2(:,trfin.valInd))) - 1;
        y2_ValTrue = exp(yfin2(:,trfin.valInd)) - 1;
        for k=1:1
            RMSEtrain(k,i) = sqrt( mean( (y2_Train(k,:) - y2_TrainTrue(k,:)).^2 ) ); %RMSE
            RMSEval(k,i) = sqrt( mean( (y2_Val(k,:) - y2_ValTrue(k,:)).^2 ) ); %RMSE
        end
        
    end
    
end