function  [netfin, trfin, y2_Train, y2_TrainTrue, y2_Val, y2_ValTrue, RMSEtrain, RMSEval, n] = training4(bd, couche, epochs, ptrain, pval, ptest, mode)
    %% Normalisation des donnees (Er, Fr)->(H, Wp, Lp, Fi, Wf, Gpf, Lg, Wg)
        % Definition des entrees et sorties du reseau de neuronne
    bd = bd.bd;
    %new
        bd=bd';
        xfin=bd(2:3,:);
        yfin=bd([1 5:6],:);
        yfin2 = log(yfin+1);
        xfin2 = zeros(2,length(yfin));
        for i =1:2
            xfin2(i,:) = (xfin(i,:)-min(xfin(i,:)))/(max(xfin(i,:))-min(xfin(i,:)));
        end
    %endnew
        
    %% Entrainement du resseau de neuronne (Er, Fr)->(H, Wp, Lp, Fi, Wf, Gpf, Lg, Wg)
    if(mode == false)    
        n = permR(couche);
    else
        n = couche;
    end
    
    RMSEtrain = zeros(3,size(n,1));
    RMSEval = zeros(3,size(n,1));
    
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
        for k=1:3
            RMSEtrain(k,i) = sqrt( mean( (y2_Train(k,:) - y2_TrainTrue(k,:)).^2 ) ); %RMSE
            RMSEval(k,i) = sqrt( mean( (y2_Val(k,:) - y2_ValTrue(k,:)).^2 ) ); %RMSE
        end
        
    end
    
end
%% verifier l'existence de Er,
%% separer les calculés et les resultats rnn
%% entrainer les reseaux au mieux
% effacer -> supprimer
% allignement
% choix 2 fois de la base de donnée et du réseau de neuronne
% rajouter fmin fmax et t. 
% position calcul
% design auto
%^pwd app designer %%6-4 --> RNN2  %%8-6 --> RNN3 %%4-8 -->RNN4
% t en micrometre