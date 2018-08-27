classdef analyzer_resolutions_object < handle
    properties
        ana1
        ana2
        ana3
        ana4
        ana5
        ana6
        ana7
        ana8
        ana9
        Int
        yDataNorm
        eDataNorm
        vEnd
        vEndNorm
        yEnd
        yEndNorm
        resnorm
        nominalres
        fitted = 'false'
    end    
     
     methods
         function AR = analyzer_resolutions_object
            for k = 1:9
                 number= int2str(k);
                 str = strcat('ana',number);
                 AR.(str)(1:50,1) = 1;
                 AR.(str)(1:50,2) = 1;
            end
         end

         function ImportData(datadir,AR,reflexion,mode,anal_choice,file_id)
            extension = '.exp';
            AR.fitted ='false';
            analysers=[1:9];
            for k = analysers(find(anal_choice))
                 number= int2str(k);
                 str = strcat('a',number,'res',reflexion,'_',mode,file_id,extension);
                 str2 = strcat('ana',number);
                 AR.(str2) = load([datadir  '/' str]);
                 % Data normalization to 1
                 AR.Int.(str2) = max(AR.(str2)(:,2));
                 AR.(str2)(:,2) = AR.(str2)(:,2)/AR.Int.(str2);
            end
         end
         
         function FitData(AR,reflexion, mode, FitFunc,anal_choice)
            
            switch reflexion               
                case '7'
                w = 7;
                wL = 7;
                wG = 7;
                nominalres = 8;
                case '8'
                w = 5;
                wL=5;
                wG=5;
                nominalres = 5.4;
                case '9'
                w = 2.5;
                wL = 2.5;
                wG = 2.5;                                
                nominalres = 3.0;
                case '11'
                w = 1.25;
                wL = 1.25;
                wG = 1.25;
                nominalres = 1.8;
                case '12'
                w = 1;
                wL = 1;
                wG = 1;
                nominalres = 1.1;
                case '13'
                w =0.8;
                wL = 0.8;
                wG = 0.8;
                nominalres = 0.8;
            end

            switch FitFunc
                case 1 %PseudoVoigt1
                    y0 = 0;
                    A = 2;
                    mu = 0.5;
                    xc = 0;
                    vStart=[y0,A,mu,xc,w];
                    analysers=[1:9];
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        x.(str2)=AR.(str2)(:,1);
                        y.(str2)=AR.(str2)(:,2);
                        yStart.(str2)=PV(vStart,x.(str2));
                        %definition of lowerbound for the fit
                        vlow=[0,0,0,-3,1];
                        %definition of upperbound for the fit 
                        y0up = min(y.(str2));
                        vup=[y0up,10,1,3,8];
                        % using lsqcurvefit
                        [AR.vEnd.(str2),AR.resnorm.(str2)]=lsqcurvefit(@PV,vStart,x.(str2),y.(str2),vlow,vup);
                        AR.yEnd.(str2)=PV(AR.vEnd.(str2),x.(str2));
                        func = @(x)PV(AR.vEnd.(str2),x); 
                        Integrale.(str2)=quad(func,-50,50);
                        AR.yEndNorm.(str2)=AR.yEnd.(str2)/Integrale.(str2);
                        AR.vEndNorm.(str2) = AR.vEnd.(str2);
                        AR.vEndNorm.(str2)(1)=AR.vEnd.(str2)(1)/Integrale.(str2);
                        AR.vEndNorm.(str2)(2)=AR.vEnd.(str2)(2)/Integrale.(str2);
                        AR.yDataNorm.(str2)=AR.(str2)(:,2)/Integrale.(str2);
                        AR.eDataNorm.(str2)=AR.(str2)(:,3)/(Integrale.(str2)*AR.Int.(str2));                        
                        fprintf('End:  y0=%f  A=%f  mu=%f xc=%f  w=%f\n',AR.vEnd.(str2)(1),AR.vEnd.(str2)(2),AR.vEnd.(str2)(3),AR.vEnd.(str2)(4),AR.vEnd.(str2)(5)); 
                     end

                case 2 %PseudoVoigt2
               
                    y0 = 0;
                    A = 2;
                    mu = 0.5;
                    xc = 0;
                    vStart=[y0,A,mu,xc,wL,wG];
                    analysers=[1:9];
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        x.(str2)=AR.(str2)(:,1);
                        y.(str2)=AR.(str2)(:,2);
                        yStart.(str2)=PV(vStart,x.(str2));
                        %definition of lowerbound for the fit
                        vlow=[0,0,0,-3,1];
                        %definition of upperbound for the fit 
                        y0up = min(y.(str2));
                        vup=[y0up,10,1,3,8];
                        % using lsqcurvefit
                        [AR.vEnd.(str2),AR.resnorm.(str2)]=lsqcurvefit(@PV2,vStart,x.(str2),y.(str2),vlow,vup);
                        AR.yEnd.(str2)=PV2(AR.vEnd.(str2),x.(str2));
                        func = @(x)PV2(AR.vEnd.(str2),x); 
                        Integrale.(str2)=quad(func,-50,50);
                        AR.yEndNorm.(str2)=AR.yEnd.(str2)/Integrale.(str2);
                        AR.vEndNorm.(str2) = AR.vEnd.(str2);
                        AR.vEndNorm.(str2)(1)=AR.vEnd.(str2)(1)/Integrale.(str2);
                        AR.vEndNorm.(str2)(2)=AR.vEnd.(str2)(2)/Integrale.(str2);
                        AR.yDataNorm.(str2)=AR.(str2)(:,2)/Integrale.(str2);
                        AR.eDataNorm.(str2)=AR.(str2)(:,3)/(Integrale.(str2)*AR.Int.(str2));
                        fprintf('End:  y0=%f  A=%f  mu=%f xc=%f  wL=%f wG=%f\n',AR.vEnd.(str2)(1),AR.vEnd.(str2)(2),AR.vEnd.(str2)(3),AR.vEnd.(str2)(4),AR.vEnd.(str2)(5), AR.vEnd.(str2)(6)); 
                     end
 
                case 3 %Voigt
               
                    y0 = 0;
                    A = 2;
                    xc = 0;
                    wL = 1;
                    wG = 1;
                    vStart=[y0,A,xc,wL,wG];
                    
                    analysers=[1:9];
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        x.(str2)=AR.(str2)(:,1);
                        y.(str2)=AR.(str2)(:,2);
                        yStart.(str2)=Voigt_v2(vStart,x.(str2));
                        %definition of lowerbound for the fit
                        vlow=[0,0,-0.5,0,0];
                        %definition of upperbound for the fit 
                        y0up = min(y.(str2));
                        vup=[y0up,10,0.5,3,3];
                        % using lsqcurvefit
                        [AR.vEnd.(str2),AR.resnorm.(str2)]=lsqcurvefit(@Voigt_v2,vStart,x.(str2),y.(str2),vlow,vup);
                        AR.yEnd.(str2)=Voigt_v2(AR.vEnd.(str2),x.(str2));
                        func = @(x)Voigt_v2(AR.vEnd.(str2),x); 
                        Integrale.(str2)=quad(func,-50,50);
                        AR.yEndNorm.(str2)=AR.yEnd.(str2)/Integrale.(str2);
                        AR.vEndNorm.(str2) = AR.vEnd.(str2);
                        AR.vEndNorm.(str2)(1)=AR.vEnd.(str2)(1)/Integrale.(str2);
                        AR.vEndNorm.(str2)(2)=AR.vEnd.(str2)(2)/Integrale.(str2);
                        AR.yDataNorm.(str2)=AR.(str2)(:,2)/Integrale.(str2);
                        AR.eDataNorm.(str2)=AR.(str2)(:,3)/(Integrale.(str2)*AR.Int.(str2));
                        fprintf('End:  y0=%f  A=%f  xc=%f  wL=%f wG=%f\n',AR.vEnd.(str2)(1),AR.vEnd.(str2)(2),AR.vEnd.(str2)(3),AR.vEnd.(str2)(4),AR.vEnd.(str2)(5)); 
                     end
                     
                case 4 %Lorentz
                    y0 = 0;
                    A = 2;
                    xc = 0;
                    vStart=[y0,A,xc,w];  
                    analysers=[1:9];
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        x.(str2)=AR.(str2)(:,1);
                        y.(str2)=AR.(str2)(:,2);
                        yStart.(str2)=Lorentz(vStart,x.(str2));
                        %definition of lowerbound for the fit
                        vlow=[0,0,-3,1];
                        %definition of upperbound for the fit 
                        y0up = min(y.(str2));
                        vup=[y0up,10,3,8];
                        % using lsqcurvefit
                        [AR.vEnd.(str2),AR.resnorm.(str2)]=lsqcurvefit(@Lorentz,vStart,x.(str2),y.(str2),vlow,vup);
                        AR.yEnd.(str2)=Lorentz(AR.vEnd.(str2),x.(str2));
                        func = @(x)Lorentz(AR.vEnd.(str2),x); 
                        Integrale.(str2)=quad(func,-50,50);
                        AR.yEndNorm.(str2)=AR.yEnd.(str2)/Integrale.(str2);
                        AR.vEndNorm.(str2) = AR.vEnd.(str2);
                        AR.vEndNorm.(str2)(1)=AR.vEnd.(str2)(1)/Integrale.(str2);
                        AR.vEndNorm.(str2)(2)=AR.vEnd.(str2)(2)/Integrale.(str2);
                        AR.yDataNorm.(str2)=AR.(str2)(:,2)/Integrale.(str2);
                        AR.eDataNorm.(str2)=AR.(str2)(:,3)/(Integrale.(str2)*AR.Int.(str2));
                        fprintf('End:  y0=%f  A=%f  xc=%f  w=%f\n',AR.vEnd.(str2)(1),AR.vEnd.(str2)(2),AR.vEnd.(str2)(3),AR.vEnd.(str2)(4)); 
                     end
                     
                case 5 %Gauss    
                    y0 = 0;
                    A = 2;
                    xc = 0;
                    vStart=[y0,A,xc,w];
                    analysers=[1:9];
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        x.(str2)=AR.(str2)(:,1);
                        y.(str2)=AR.(str2)(:,2);
                        yStart.(str2)=Gauss(vStart,x.(str2));
                        %definition of lowerbound for the fit
                        vlow=[0,0,-3,1];
                        %definition of upperbound for the fit 
                        y0up = min(y.(str2));
                        vup=[y0up,10,3,8];
                        % using lsqcurvefit
                        [AR.vEnd.(str2),AR.resnorm.(str2)]=lsqcurvefit(@Gauss,vStart,x.(str2),y.(str2),vlow,vup);
                        AR.yEnd.(str2)=Gauss(AR.vEnd.(str2),x.(str2));
                        func = @(x)Gauss(AR.vEnd.(str2),x); 
                        Integrale.(str2)=quad(func,-50,50);
                        AR.yEndNorm.(str2)=AR.yEnd.(str2)/Integrale.(str2);
                        AR.vEndNorm.(str2) = AR.vEnd.(str2);
                        AR.vEndNorm.(str2)(1)=AR.vEnd.(str2)(1)/Integrale.(str2);
                        AR.vEndNorm.(str2)(2)=AR.vEnd.(str2)(2)/Integrale.(str2);
                        AR.yDataNorm.(str2)=AR.(str2)(:,2)/Integrale.(str2);
                        AR.eDataNorm.(str2)=AR.(str2)(:,3)/(Integrale.(str2)*AR.Int.(str2));
                        fprintf('End:  y0=%f  A=%f  xc=%f  w=%f\n',AR.vEnd.(str2)(1),AR.vEnd.(str2)(2),AR.vEnd.(str2)(3),AR.vEnd.(str2)(4)); 
                     end    
                      
            
                fprintf('Start:  y0=%f  A=%f  xc=%f  w=%f\n',vStart(1),vStart(2),vStart(3),vStart(4));
                
                case 6 %PseudoVoigt with stretched Lorentzian
               
                    y0 = 0;
                    A = 2;
                    mu = 0.5;
                    xc = 0;
                    ex = 2;
                    vStart=[y0,A,mu,xc,wL,wG,ex];
                    analysers=[1:9];
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        x.(str2)=AR.(str2)(:,1);
                        y.(str2)=AR.(str2)(:,2);
                        yStart.(str2)=PV(vStart,x.(str2));
                        %definition of lowerbound for the fit
                        vlow=[0,0,0,-3,1];
                        %definition of upperbound for the fit 
                        y0up = min(y.(str2));
                        vup=[y0up,10,1,3,8];
                        % using lsqcurvefit
                        [AR.vEnd.(str2),AR.resnorm.(str2)]=lsqcurvefit(@PV_stretchedL_v2,vStart,x.(str2),y.(str2),vlow,vup);
                        AR.yEnd.(str2)=PV2(AR.vEnd.(str2),x.(str2));
                        func = @(x)PV_stretchedL_v2(AR.vEnd.(str2),x); 
                        Integrale.(str2)=quad(func,-50,50);
                        AR.yEndNorm.(str2)=AR.yEnd.(str2)/Integrale.(str2);
                        AR.vEndNorm.(str2) = AR.vEnd.(str2);
                        AR.vEndNorm.(str2)(1)=AR.vEnd.(str2)(1)/Integrale.(str2);
                        AR.vEndNorm.(str2)(2)=AR.vEnd.(str2)(2)/Integrale.(str2);
                        AR.yDataNorm.(str2)=AR.(str2)(:,2)/Integrale.(str2);
                        AR.eDataNorm.(str2)=AR.(str2)(:,3)/(Integrale.(str2)*AR.Int.(str2));
                        fprintf('End:  y0=%f  A=%f  mu=%f xc=%f  wL=%f wG=%f ex=%f\n',AR.vEnd.(str2)(1),AR.vEnd.(str2)(2),AR.vEnd.(str2)(3),AR.vEnd.(str2)(4),AR.vEnd.(str2)(5), AR.vEnd.(str2)(6), AR.vEnd.(str2)(7)); 
                     end            
            
           
            
            end
            AR.fitted ='true';
         end
         
         function PlotData(AR, Location,anal_choice)
            
            switch AR.fitted
                case  'false'
                    for i = 1:9
                        hold off
                        eval(['subplot(3,3,' num2str(i) ',''Parent'',Location);' ]);
                        if anal_choice(i) == 1
                            cla
                            eval(['plot(AR.ana' num2str(i) '(:,1), AR.ana' num2str(i) '(:,2),''Marker'',''o'',''LineStyle'',''none'',''Color'',[0 0 1]);' ]);
                            xlim([-45 45]);
                            ylim([0.0001 3]);
                            set(gca,'yscale','log','YMinorTick','on','FontSize',12)
                            xlabel('Energy (meV)','FontSize',12);
                            ylabel('Intensity (arb. Units)','FontSize',12);
                            title(['Analyzer #' num2str(i)]);
                            box('on');
                        else
                            cla
                            xlim([-45 45]);
                            ylim([0.0001 3]);
                            set(gca,'yscale','log','YMinorTick','on','FontSize',12)
                            xlabel('Energy (meV)','FontSize',12);
                            ylabel('Intensity (arb. Units)','FontSize',12);
                            title(['Analyzer #' num2str(i)]);
                            box('on');
                        end
                          
                    end
                
                case 'true'
                    for i = 1:9
                        hold off
                        eval(['subplot(3,3,' num2str(i) ',''Parent'',Location);']);
                        if anal_choice(i) == 1
                            cla
                            eval(['plot(AR.ana' num2str(i) '(:,1), AR.ana' num2str(i) '(:,2),''Marker'',''o'',''LineStyle'',''none'',''Color'',[0 0 1]);' ]);
                            hold on
                            eval(['plot(AR.ana' num2str(i) '(:,1),AR.yEnd.ana' num2str(i) '(:,1),''-r'',''LineWidth'',2);']);  
                            xlim([-45 45]);
                            ylim([0.0001 3]);
                            set(gca,'yscale','log','YMinorTick','on','FontSize',12)
                            xlabel('Energy (meV)','FontSize',12);
                        	ylabel('Intensity (arb. Units)','FontSize',12);
                            title(['Analyzer #' num2str(i)]);
                            box('on');
                         else
                            cla
                            xlim([-45 45]);
                            ylim([0.0001 3]);
                            set(gca,'yscale','log','YMinorTick','on','FontSize',12)
                            xlabel('Energy (meV)','FontSize',12);
                            ylabel('Intensity (arb. Units)','FontSize',12);
                            title(['Analyzer #' num2str(i)]);
                            box('on');
                        end
                    end
            end
         end
        
         function ExportFittedData(datadir,AR, reflexion, mode, FitFunc,anal_choice,file_id)
             
            switch FitFunc 
                case 1
                    %% Prints the results in the outputfile
                    filename = strcat('res',reflexion,'_',mode,file_id,'.txt');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'Operation mode: %s \n \n', mode);
                    fprintf(outputfile,'Some definitions:\n\nIntensity: Maximum intensity in original data\n');
                    fprintf(outputfile,'y0: Fitted flat background\nA: Fitted intensity of (normalised) PV\nmu:Fitted mixing parameter of PV\nxc: Fitted centre of PV\nw: Fitted width of PV\n');
                    fprintf(outputfile,'resnorm: Squared 2-norm of the residual\n\n\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, 'PSEUDOVOIGT FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');
           
                    analysers=1:9;
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, 'Analyzer Number %s: \n\n', number);
                        fprintf(outputfile, 'Intensity=%f \ny0=%f \nA=%f \nmu=%f \nxc=%f \nw=%f\nresnorm=%f\n', AR.Int.(str2), AR.vEndNorm.(str2)(1), AR.vEndNorm.(str2)(2),AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(4),AR.vEndNorm.(str2)(5),AR.resnorm.(str2));
                        fprintf(outputfile, '#############################################################\n');
                        
                        fitfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.fit');
                        outputfit = fopen([datadir '/' fitfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        v_fit=[AR.vEndNorm.(str2)(1) 1 AR.vEndNorm.(str2)(3) 0 AR.vEndNorm.(str2)(5)];
                       
                        fit_energy=linspace(-50,50,500);
                        fit_intens=PV(v_fit,fit_energy);
                        fit_array=[fit_energy' fit_intens'];
                        dlmwrite(fitfilename, fit_array, ' ');                                   
                        
                        fclose(outputfit);
                        
                        norfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.nor');
                        outputnor = fopen([datadir '/' norfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        for kk = 1:ss
                            fprintf(outputnor,'%f %f %f\n', AR.(str2)(kk,1), AR.yDataNorm.(str2)(kk),AR.eDataNorm.(str2)(kk));                                
                        end
                        fclose(outputnor);
                        
                    end
                    fclose(outputfile);
                    %% .param file for ixs_fitter
                    filename = strcat('res',reflexion,'_',mode,file_id,'.param');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'# Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'# Operation mode: %s \n', mode);
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, '# PSEUDOVOIGT FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, '# Parameters for resolution function for ixs_fitter\n');
                    fprintf(outputfile, '# usage : res_param = {detector_number:[mu,wG,wL],...,n:[mun,wGn,wLn]}\n');
                    fprintf(outputfile, '# \n');
                    fprintf(outputfile, 'res_param ={ \n');
                    for k = 1:8
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, '%s:[', number);
                        fprintf(outputfile, '%f,%f,%f',AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(5),AR.vEndNorm.(str2)(5));
                        fprintf(outputfile, '],\n');
                    end
                    for k = 9
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, '%s:[', number);
                        fprintf(outputfile, '%f,%f,%f',AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(5),AR.vEndNorm.(str2)(5));
                        fprintf(outputfile, ']\n');
                    end
                    fprintf(outputfile, '}\n');
                    fprintf(outputfile, '# Temperature (important : floating type is mandatory)\n');
                    fprintf(outputfile, 'T = 297.0\n');
                    fclose(outputfile);
                 case 2
                    %% Prints the results in the outputfile
                    filename = strcat('res',reflexion,'_',mode,file_id,'.txt');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'Operation mode: %s \n \n \n', mode);
                    fprintf(outputfile,'Some definitions:\n\nIntensity: Maximum intensity in original data\n');
                    fprintf(outputfile,'y0: Fitted flat background\nA: Fitted intensity of (normalised) PV\nmu:Fitted mixing parameter of PV\nxc: Fitted centre of PV\nwL: Fitted width of Lorentzian in PV\nwG: Fitted width of Gaussian in PV\n');
                    fprintf(outputfile,'resnorm: Squared 2-norm of the residual\n\n\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, 'PSEUDOVOIGT2 FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');

                    analysers=1:9; 
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, 'Analyzer Number %s: \n\n', number);
                        fprintf(outputfile, 'Intensity=%f \ny0=%f \nA=%f \nmu=%f \nxc=%f \nwL=%f\nwG=%f\nresnorm=%f\n', AR.Int.(str2), AR.vEndNorm.(str2)(1), AR.vEndNorm.(str2)(2),AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(4),AR.vEndNorm.(str2)(5),AR.vEndNorm.(str2)(6),AR.resnorm.(str2));
                        fprintf(outputfile, '#############################################################\n');
                        fitfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.fit');
                        outputfit = fopen([datadir '/' fitfilename],'wt');
                        [ss, pp]=size(AR.(str2));
%             
                        v_fit=[AR.vEndNorm.(str2)(1) 1 AR.vEndNorm.(str2)(3) 0 AR.vEndNorm.(str2)(5) AR.vEndNorm.(str2)(6)];
                       
                        fit_energy=linspace(-50,50,500);
                        fit_intens=PV2(v_fit,fit_energy);
                        fit_array=[fit_energy' fit_intens'];
                        dlmwrite(fitfilename, fit_array, ' ');                                   
                        
                        fclose(outputfit);
                        
                        norfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.nor');
                        outputnor = fopen([datadir '/' norfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        for kk = 1:ss
                            fprintf(outputnor,'%f %f %f\n', AR.(str2)(kk,1), AR.yDataNorm.(str2)(kk),AR.eDataNorm.(str2)(kk));                                
                        end
                        fclose(outputnor);
                        
                    end
                    fclose(outputfile);
                    %%% .param file for ixs_fitter
                    filename = strcat('res',reflexion,'_',mode,file_id,'.param');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'# Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'# Operation mode: %s \n', mode);
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, '# PSEUDOVOIGT2 FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, '# Parameters for resolution function for ixs_fitter\n');
                    fprintf(outputfile, '# usage : res_param = {detector_number:[mu,wG,wL],...,n:[mun,wGn,wLn]}\n');
                    fprintf(outputfile, '# \n');
                    fprintf(outputfile, 'res_param ={ \n');
                    for k = 1:8
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, '%s:[', number);
                        fprintf(outputfile, '%f,%f,%f',AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(6),AR.vEndNorm.(str2)(5));
                        fprintf(outputfile, '],\n');
                    end
                    for k = 9
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, '%s:[', number);
                        fprintf(outputfile, '%f,%f,%f',AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(6),AR.vEndNorm.(str2)(5));
                        fprintf(outputfile, ']\n');
                    end
                    fprintf(outputfile, '}\n');
                    fprintf(outputfile, '# Temperature (important : floating type is mandatory)\n');
                    fprintf(outputfile, 'T = 297.0\n');
                    fclose(outputfile);
                  case 3
                    %% Prints the results in the outputfile
                    filename = strcat('res',reflexion,'_',mode,file_id,'.txt');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'Operation mode: %s \n \n \n', mode);
                    fprintf(outputfile,'Some definitions:\n\nIntensity: Maximum intensity in original data\n');
                    fprintf(outputfile,'y0: Fitted flat background\nA: Fitted intensity of (normalised) V\nxc: Fitted centre of V\nwL: Fitted width of Lorentzian in V\nwG: Fitted width of Gaussian in V\n');
                    fprintf(outputfile,'resnorm: Squared 2-norm of the residual\n\n\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, 'VOIGT FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');

                    analysers=1:9;           
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, 'Analyzer Number %s: \n\n', number);
                        fprintf(outputfile, 'Intensity=%f \ny0=%f \nA=%f \nxc=%f \nwL=%f\nwG=%f\nresnorm=%f\n', AR.Int.(str2), AR.vEndNorm.(str2)(1), AR.vEndNorm.(str2)(2),AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(4),AR.vEndNorm.(str2)(5),AR.resnorm.(str2));
                        fprintf(outputfile, '#############################################################\n');
                        fitfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.fit');
                        outputfit = fopen([datadir '/' fitfilename],'wt');
                        [ss, pp]=size(AR.(str2));
            
                        v_fit=AR.vEndNorm.(str2);
                        v_fit(2)=1;    
                        v_fit(3)=0;
                        fit_energy=linspace(-50,50,500);
                        fit_intens=PV2(v_fit,fit_energy);
                        fit_array=[fit_energy' fit_intens'];
                        dlmwrite(fitfilename, fit_array, ' ');             
                        
                        fclose(outputfit);
                        
                        norfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.nor');
                        outputnor = fopen([datadir '/' norfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        for kk = 1:ss
                            fprintf(outputnor,'%f %f %f\n', AR.(str2)(kk,1), AR.yDataNorm.(str2)(kk),AR.eDataNorm.(str2)(kk));                                
                        end
                        fclose(outputnor);
                    end
                    fclose(outputfile);
                    
                 case 4
                    %% Prints the results in the outputfile
                    filename = strcat('res',reflexion,'_',mode,file_id,'.txt');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'Operation mode: %s \n \n \n', mode);
                    fprintf(outputfile,'Some definitions:\n\nIntensity: Maximum intensity in original data\n');
                    fprintf(outputfile,'y0: Fitted flat background\nA: Fitted intensity of (normalised) Lorentzian\nxc: Fitted centre of Lorentzian\nw: Fitted width of Lorentzian\n');
                    fprintf(outputfile,'resnorm: Squared 2-norm of the residual\n\n\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, 'LORENTZIAN FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');
                    
                    analysers=1:9;           
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, 'Analyzer Number %s: \n\n', number);
                        fprintf(outputfile, 'Intensity=%f \ny0=%f \nA=%f \nxc=%f \nw=%f\nresnorm=%f\n', AR.Int.(str2), AR.vEndNorm.(str2)(1), AR.vEndNorm.(str2)(2),AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(4),AR.resnorm.(str2));
                        fprintf(outputfile, '#############################################################\n');
                        fitfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.fit');
                        outputfit = fopen([datadir '/' fitfilename],'wt');
                        [ss, pp]=size(AR.(str2));
            
                        v_fit=AR.vEndNorm.(str2);
                        v_fit(2)=1;    
                        v_fit(3)=0;
                        fit_energy=linspace(-50,50,500);
                        fit_intens=PV2(v_fit,fit_energy);
                        fit_array=[fit_energy' fit_intens'];
                        dlmwrite(fitfilename, fit_array, ' ');

                        fclose(outputfit);
                        
                        norfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.nor');
                        outputnor = fopen([datadir '/' norfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        for kk = 1:ss
                            fprintf(outputnor,'%f %f %f\n', AR.(str2)(kk,1), AR.yDataNorm.(str2)(kk),AR.eDataNorm.(str2)(kk));                                
                        end
                        fclose(outputnor);
                    end
                    fclose(outputfile);
                 case 5
                    %% Prints the results in the outputfile
                    filename = strcat('res',reflexion,'_',mode,file_id,'.txt');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'Operation mode: %s \n \n \n', mode);
                    fprintf(outputfile,'Some definitions:\n\nIntensity: Maximum intensity in original data\n');
                    fprintf(outputfile,'y0: Fitted flat background\nA: Fitted intensity of (normalised) Gaussian\nxc: Fitted centre of Gaussian\nw: Fitted width of Gaussian\n');
                    fprintf(outputfile,'resnorm: Squared 2-norm of the residual\n\n\n');

                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, 'GAUSSIAN FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');
                    
                    analysers=1:9;           
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, 'Analyzer Number %s: \n\n', number);
                        fprintf(outputfile, 'Intensity=%f \ny0=%f \nA=%f \nxc=%f \nw=%f\nresnorm=%f\n', AR.Int.(str2), AR.vEndNorm.(str2)(1), AR.vEndNorm.(str2)(2),AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(4),AR.resnorm.(str2));
                        fprintf(outputfile, '#############################################################\n');
                        fitfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.fit');
                        outputfit = fopen([datadir '/' fitfilename],'wt');
                        [ss, pp]=size(AR.(str2));
            
                        
                        v_fit=AR.vEndNorm.(str2);
                        v_fit(2)=1;    
                        v_fit(3)=0;
                        fit_energy=linspace(-50,50,500);
                        fit_intens=PV2(v_fit,fit_energy);
                        fit_array=[fit_energy' fit_intens'];
                        dlmwrite(fitfilename, fit_array, ' ');                       

                        fclose(outputfit);
                        
                        norfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.nor');
                        outputnor = fopen([datadir '/' norfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        for kk = 1:ss
                            fprintf(outputnor,'%f %f %f\n', AR.(str2)(kk,1), AR.yDataNorm.(str2)(kk),AR.eDataNorm.(str2)(kk));                                
                        end
                        fclose(outputnor);
                    end
                    fclose(outputfile);
                case 6
                    %% Prints the results in the outputfile
                    filename = strcat('res',reflexion,'_',mode,file_id,'.txt');
                    outputfile = fopen([datadir '/' filename], 'wt');
                    fprintf(outputfile,'Reflection: %s %s %s\n', reflexion, reflexion, reflexion);
                    fprintf(outputfile,'Operation mode: %s \n \n \n', mode);
                    fprintf(outputfile,'Some definitions:\n\nIntensity: Maximum intensity in original data\n');
                    fprintf(outputfile,'y0: Fitted flat background\nA: Fitted intensity of (normalised) PV\nmu:Fitted mixing parameter of PV\nxc: Fitted centre of PV\nwL: Fitted Lorentzian width in PV\nwG: Fitted Gaussian width in PV\nex: Fitted exponent of Lorentzian in PV\n');
                    fprintf(outputfile,'resnorm: Squared 2-norm of the residual\n\n\n');
                    fprintf(outputfile, '#############################################################\n');
                    fprintf(outputfile, 'PSEUDOVOIGT WITH STRETCHED LORENTZIAN FINAL FITTING PARAMETERS VALUE:\n');
                    fprintf(outputfile, '#############################################################\n');

                    analysers=1:9; 
                    for k = analysers(find(anal_choice))
                        number= int2str(k);
                        str2 = strcat('ana',number);
                        fprintf(outputfile, 'Analyzer Number %s: \n\n', number);
                        fprintf(outputfile, 'Intensity=%f \ny0=%f \nA=%f \nmu=%f \nxc=%f \nwL=%f\nwG=%f\nex=%f\nresnorm=%f\n', AR.Int.(str2), AR.vEndNorm.(str2)(1), AR.vEndNorm.(str2)(2),AR.vEndNorm.(str2)(3),AR.vEndNorm.(str2)(4),AR.vEndNorm.(str2)(5),AR.vEndNorm.(str2)(6),AR.vEndNorm.(str2)(7),AR.resnorm.(str2));
                        fprintf(outputfile, '#############################################################\n');
                        fitfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.fit');
                        outputfit = fopen([datadir '/' fitfilename],'wt');
                        [ss, pp]=size(AR.(str2));
            
                        
                        v_fit=AR.vEndNorm.(str2);
                        v_fit(2)=1;    
                        v_fit(4)=0;
                        fit_energy=linspace(-50,50,500);
                        fit_intens=PV2(v_fit,fit_energy);
                        fit_array=[fit_energy' fit_intens'];
                        dlmwrite(fitfilename, fit_array, ' ');
                        
                        fclose(outputfit);
                        
                        norfilename = strcat('a',number,'res',reflexion,'_',mode,file_id,'.nor');
                        outputnor = fopen([datadir '/' norfilename],'wt');
                        [ss, pp]=size(AR.(str2));
                        for kk = 1:ss
                            fprintf(outputnor,'%f %f %f\n', AR.(str2)(kk,1), AR.yDataNorm.(str2)(kk),AR.eDataNorm.(str2)(kk));                                
                        end
                        fclose(outputnor);
                    end
                    fclose(outputfile);
                   
            end
        
         
         end
         
         function DisplayResults(AR,location, Fitfunc,anal_choice)           
            switch  Fitfunc
                case 1
                    hold off
                    analysers=[1:9];
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(5) '];
                    end
                    string=[string '],''o'');'];
                    eval(string);
                    hold on
                    xlabel('Analyzer Number'), ylabel('Resolution');
                    legend('Experimental resolution w')
                    xlim([0 9.5]);
                    ylim([0 7]);
                    box('on');
                case 2
                    hold off
                    analysers=[1:9];  
                    string='plot(location,(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(5) '];
                    end
                    string=[string '],''o'');'];
                    eval(string)
                    hold on
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(6) '];
                    end
                    string=[string '],''x'');'];
                    eval(string)
                    xlabel('Analyzer Number'), ylabel('Resolution');
                    legend('Experimental resolution wL', 'Experimental resolution wG')
                    xlim([0 9.5]);
                    ylim([0 7]);
                    box('on');
                case 3
                    hold off
                    analysers=[1:9];
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(4) '];
                    end
                    string=[string '],''o'');'];
                    eval(string)
                    hold on
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(5) '];
                    end
                    string=[string '],''x'');'];
                    xlabel('Analyzer Number'), ylabel('Resolution');
                    legend('Experimental resolution wL', 'Experimental resolution wG')
                    xlim([0 9.5]);
                    ylim([0 7]);
                    box('on');
                case 4
                    analysers=[1:9];
                    hold off
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(4) '];
                    end
                    string=[string '],''o'');'];
                    eval(string)
                    hold on
                    xlabel('Analyzer Number'), ylabel('Resolution');
                    legend('Experimental resolution w')
                    xlim([0 9.5]);
                    ylim([0 7]);
                    box('on');
                case 5
                    analysers=[1:9];
                    hold off
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(4) '];
                    end
                    string=[string '],''o'');'];
                    eval(string)
                    hold on
                    xlabel('Analyzer Number'), ylabel('Resolution');
                    legend('Experimental resolution w')
                    xlim([0 9.5]);
                    ylim([0 7]);
                    box('on');
                case 6
                    hold off
                    analysers=[1:9];  
                    string='plot(location,(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(5) '];
                    end
                    string=[string '],''o'');'];
                    eval(string)
                    hold on
                    string='plot(location,analysers(find(anal_choice)),[';
                    for i=analysers(find(anal_choice))
                        string=[string 'AR.vEnd.ana' num2str(i) '(6) '];
                    end
                    string=[string '],''x'');'];
                    eval(string)
                    xlabel('Analyzer Number'), ylabel('Resolution');
                    legend('Experimental resolution wL', 'Experimental resolution wG')
                    xlim([0 9.5]);
                    ylim([0 7]);
                    box('on');             
            end
         end
     end
end


