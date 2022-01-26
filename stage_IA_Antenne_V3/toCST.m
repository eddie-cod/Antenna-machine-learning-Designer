function toCST(Hs,Er, Wp, Lp,Fi, Wf,Gpf,Lg, Wg, Fmin, Fmax, t, Path_CST, filenameTXT)
    addpath(genpath(Path_CST));
    %addpath('CST-MATLAB-API-master');
    
%% Initialisation de CST
    
    cst = actxserver('CSTStudio.application');

    % Creation d'un nouveau Projet CST
    %pr = cst.invoke('NewProject');
    mws = cst.invoke('NewMWS');

    % Utiliser les unites par defaut de CST
    CstDefaultUnits(mws);

    % Definition de la plage de frequence
    CstDefineFrequencyRange(mws, Fmin, Fmax);

    % Initiates the auto meshing
    CstMeshInitiator(mws);

    % Definitionn des limites / echelle
    Xmin='expanded open';
    Xmax='expanded open';
    Ymin='expanded open';
    Ymax='expanded open';
    Zmin='expanded open';
    Zmax='expanded open';
    minfrequency = Fmin;
    CstDefineOpenBoundary(mws,minfrequency,Xmin,Xmax,Ymin,Ymax,Zmin,Zmax);

    % Definition du background des materiaux
    XminSpace = 0;
    XmaxSpace = 0;
    YminSpace = 0;
    YmaxSpace = 0;
    ZminSpace = 0;
    ZmaxSpace = 0;
    CstDefineBackroundMaterial(mws,XminSpace,XmaxSpace, YminSpace, YmaxSpace, ZminSpace, ZmaxSpace);

    % Definition des materiaux à utliser
    CstCopperAnnealedLossy(mws);
    CstFR4lossy(mws);
    
    % t est en micromètre !
    t = t*1e-3;% en mm
    
    % Definition des paramètres CST
    mws.invoke('MakeSureParameterExists','Wp', num2str(Wp));
    mws.invoke('MakeSureParameterExists','Lp', num2str(Lp));
    mws.invoke('MakeSureParameterExists','Fi', num2str(Fi));
    mws.invoke('MakeSureParameterExists','Wf', num2str(Wf));
    mws.invoke('MakeSureParameterExists','Gpf', num2str(Gpf));
    mws.invoke('MakeSureParameterExists','Lg', num2str(Lg));
    mws.invoke('MakeSureParameterExists','Wg', num2str(Wg));
    mws.invoke('MakeSureParameterExists','t', num2str(t));
    mws.invoke('MakeSureParameterExists','Hs', num2str(Hs));
    

%% Construction
    % Construction du plan de masse
    Name = 'Groundplane';
    component = 'component1';
    material = 'Copper (annealed)';
    Xrange = [-0.5*Wg 0.5*Wg];
    Yrange = [-0.5*Lg 0.5*Lg];
    Zrange = [0 t];
    Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange);

    % Construction du substrat
    Name = 'Substrate';
    Mue = 1;
    TanD = 0;
    ThermalConductivity = 0;
    Cstcreatedielectricmaterial(mws, Name, Er, Mue, TanD, ThermalConductivity)  
    
    component = 'component1';
    material = 'Substrate';
    
    Xrange = [-0.5*Wg 0.5*Wg];
    Yrange = [-0.5*Lg 0.5*Lg];
    Zrange = [t t+Hs];
    Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange);

    %This one creates the patch
    Name = 'Patch';
    component = 'component1';
    material = 'Copper (annealed)';
    Xrange = [-Wp/2 Wp/2];
    Yrange = [-Lp/2 Lp/2];
    Zrange = [t+Hs t+Hs+t];
    Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange)

    % Construction de la fente
    Name = 'slot';
    component = 'component1';
    material = 'Copper (annealed)';
    Xrange = [-((Wf/2)+Gpf)  ((Wf/2)+Gpf)];
    Yrange = [-Lp/2+Fi -Lp/2];
    Zrange = [t+Hs t+Hs+t];
    Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange);
    component1 = 'component1:Patch';
    component2 = 'component1:slot';
    CstSubtract(mws,component1,component2);

    % Creation de la ligne d'alimentation
    Name = 'FeedLine';
    component = 'component1';
    material = 'Copper (annealed)';
    Xrange = [-Wf/2 Wf/2];
    Yrange = [-Lp/2+Fi -Lg/2];
    Zrange = [t+Hs t+Hs+t];
    Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange);
    %This adds the feedline to the patch
    component1 = 'component1:Patch';
    component2 = 'component1:FeedLine';
    CstAdd(mws,component1,component2);
    
    
%% Assignation de port
    % Assignation d'un port au substrat
    Name = 'Substrate';
    id = 3;
    CstPickFace(mws,Name,id);

    % Assignation de port aux ligne d'onde
    PortNumber = 1;
    Xrange = [-36 36];
    Yrange = [-36 -36];
    Zrange = [0.035 1.635];
    XrangeAdd =[3*Wf 3*Wf];
    YrangeAdd =[0 0];
    ZrangeAdd =[t+Hs 4*Hs];
    Coordinates = 'Picks';
    Orientation = 'positive';
    CstWaveguidePort(mws,PortNumber, Xrange, Yrange, Zrange, XrangeAdd, YrangeAdd, ZrangeAdd,Coordinates,Orientation);
    
    
%% Assignation des moniteurs
    % Assigner des moniteurs pour visualiser les champs electromagnetiques à 2.45GHz 
    CstDefineEfieldMonitor(mws,strcat('e-field', '2.45'),2.45);
    CstDefineHfieldMonitor(mws,strcat('h-field', '2.45'), 2.45);
    CstDefineFarfieldMonitor(mws,strcat('Farfield','2.45'), 2.45);
    
%% Sauvegarde - simulation - exportation des résultats
    % Sauvegarde du projet
    CstSaveProject(mws);

    % Lancement de la simulation
    CstDefineTimedomainSolver(mws,-40);

    %--- Exporter et Enregistrer les résultats S21dB et S11Ph
    Sij_Name ='S1,1';       %filenameTXT = 'resultats.txt';
    exportpath = [pwd '\' filenameTXT]; 
    CstExportSparametersTXT(mws, Sij_Name, exportpath) %- export of S parameters
    

end