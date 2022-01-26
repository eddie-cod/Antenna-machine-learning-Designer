function [resTestfin] = CalculRNN(input, bd)

    testfin=input';
    bd=bd';
    xfin=bd(1:3,:);
    for i =1:length(input)
        testfin(i) = (testfin(i)-min(xfin(i,:)))/(max(xfin(i,:))-min(xfin(i,:)));
    end
    resTestfin=netfin(testfin);
    resTestfin=exp(resTestfin)-1;