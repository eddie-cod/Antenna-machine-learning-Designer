function Lg = calcLg(H,Lp)
    Lg=6*H+Lp;
    
    if ~isreal(Lp)
        Lp=0;
    end
end