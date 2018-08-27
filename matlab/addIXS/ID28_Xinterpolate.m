function Xs_interp = ID28_Xinterpolate(data,specfile,scan_numbers,state,analysers)
% FUNCTION ID28_Xinterpolate calculates an interpolated version of the
% energy transfer scale for summing the data. Note that the output can have
% a variable energy step size depending on the datasets which are to be
% added together
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

    % Go through all runs, finding the minimum and maximum values of T, as well
    % as the minimum increment in T over the whole scan
    i=1;
    for j=1:length(specfile)
        scan_nums=cell2mat(scan_numbers(j));
        for k=1:length(scan_nums)
            if true(state(i))
                structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
                for m=analysers
                    eval(['X_min_array(i,m)=min(' structname '.Xs(:,m));']);
                    eval(['X_max_array(i,m)=max(' structname '.Xs(:,m));']);
                    eval(['DX_mean_array(i,m) = mean(diff(' structname '.Xs(:,m)));']);
                end
            end
            i=i+1;
        end
    end

    % Find the minimum and maximum values of T for all the scans to be summed, 
    % as well as the minimum increment in T
    X_min=min(X_min_array(state,analysers));
    X_max=max(X_max_array(state,analysers));
    DX_mean=min(DX_mean_array(state,analysers));

    % Find the length of the new interpolated T array for first analyser in
    % selection
    length_Xs_interp = length(X_min:DX_mean:X_max);

%     i=1;
%     X_temp=X_min;
%     while X_temp<=X_max
%         X(i)=X_temp;
%         logical=X_min_array(state,analysers)<=X(i)&X(i)<=X_max_array(state,analysers);
%         if(any(logical))
%             DX_temp=DX_mean_array(state,analysers);
%             DX=min(DX_temp(logical));
%             X_temp=X_temp+DX;
%         elseif(all(~logical))
%             X_step=X_min_array(state,analysers)-X_temp;
%             X_temp=X_temp+min(X_step(X_step>0));
%         end
%         i=i+1;
%     end
%     
%     for m=analysers
%         Xs_interp(:,m)=X';
%     end
    
	i=1;
    X_temp=X_min;
    while X_temp<=X_max
        logical=X_min_array(state,analysers)<=X_temp&X_temp<=X_max_array(state,analysers);
        if(any(logical))
            X(i)=X_temp;
            DX_temp=DX_mean_array(state,analysers);
            DX=min(DX_temp(logical));
            X_temp=X_temp+DX;
            i=i+1;
        elseif(all(~logical))
            X_step=X_min_array(state,analysers)-X_temp;
            X_temp=X_temp+min(X_step(X_step>0));
        end
    end
    
    for m=analysers
        Xs_interp(:,m)=X';
    end
    
    
%     
% %     % Initialise 2D array for all the interpolated T arrays for all the
% %     % analysers
% %     Xs_interp=zeros(length_Xs_interp,max(analysers));
% %     % Write new interpolated T arrays to Ts_interp
% %     for m=analysers
% %         Xs_interp(:,m) = linspace(X_min(m),X_max(m),length_Xs_interp);
% %     end
%     
% elseif isequal(interp_choice,'user')
% 
%     if isequal(numel(interp_par),1)
%         % Go through all runs, finding the minimum and maximum values of T
%         i=1;
%         for j=1:length(specfile)
%             scan_nums=cell2mat(scan_numbers(j));
%             for k=1:length(scan_nums)
%                 if true(state(i))
%                     structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
%                     for m=analysers
%                         eval(['X_min_array(i,m)=min(' structname '.Xs(:,m));']);
%                         eval(['X_max_array(i,m)=max(' structname '.Xs(:,m));']);
%                     end
%                 end
%                 i=i+1;
%             end
%         end
% 
%         % Find the minimum and maximum values of T for all the scans to be
%         % summed
%         X_min=min(X_min_array(state,:));
%         X_max=max(X_max_array(state,:));
% 
%         length_Xs_interp = length(X_min(analysers):interp_par:X_max(analysers));
% 
%         % Initialise 2D array for all the interpolated T arrays for all the
%         % analysers
%         Xs_interp=zeros(length_Xs_interp,max(analysers));
%         % Write new interpolated T arrays to Ts_interp
%         for m=analysers
%                 Xs_interp(:,m) = linspace(X_min(m),X_max(m),length_Xs_interp);
%         end
%         
%     elseif numel(interp_par)>1
% 
%         length_Xs_interp = length(X_min(analysers):interp_par:X_max(analysers));
% 
%         % Initialise 2D array for all the interpolated T arrays for all the
%         % analysers
%         Xs_interp=zeros(length_Xs_interp,max(analysers));
%         % Write new interpolated T arrays to Ts_interp
%         for m=analysers
%                 Xs_interp(:,m) = interp_par';
%         end      
%         
%     end
% 
% end

