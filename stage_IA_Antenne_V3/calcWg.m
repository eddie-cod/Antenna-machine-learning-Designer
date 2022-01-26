function Wg = calcWg(H,Wp)
    Wg=6*H+Wp;
    
    if ~isreal(Wg)
        Wg=0;
    end
end