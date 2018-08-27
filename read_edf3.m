function [image_data,variance_data,header]=read_edf3(varargin)
% function to read ESRF data format (edf & ehf)
%
% Michael Sztucki, December 2005, November 2008
%                  May 2010, Jan-Sept 2011, Feb 2012
% V3.2 - with support for compressed files (zlib)


if nargin == 1
    filename=varargin{1};
    datablock=1;
elseif nargin == 2
    filename=varargin{1};
    datablock=varargin{2};
else
    return
end

if(exist(filename)~=0)
    %[pathstr, name, ext, versn] = fileparts(filename);
    variance_data=0;
    
    fid=fopen(filename,'r');
    bo=0;
    
    line=' '; z=0; ehffile=0;
    while line~='{'
        line=fgetl(fid);
        if isempty(line) line=' '; end
        z=z+1;
        if z>5
            image_data=0;
            header.title='error';
            fclose(fid);
            return;
        end
    end
    line=fgetl(fid);
    if size(findstr(upper(line),upper('EDF_DataFormatVersion')))>0
        ehffile=1;
    end
    
    header.offset_1='0';
    header.offset_2='0';
    header.center_1='0';
    header.center_2='0';
    header.detectorrotation_1='0';
    header.detectorrotation_2='0';
    header.detectorrotation_3='0';
    header.bsize_1='1';
    header.bsize_2='1';
    header.psize_1='5e-5';
    header.psize_2='5e-5';
    header.sampledistance='1';
    header.wavelength='1e-10';
    header.filename=filename;
    header.edf_datablocks='0';
    header.edf_headersize='0';
    header.edf_binarysize='0';
    header.edf_binaryfileposition='0';
    header.title='';
    header.dummy='-10';
    header.ddummy='0';
    header.projectiontype='Saxs';
    header.rasterorientation='1';
    header.axistype_1='Distance';
    header.axistype_2='Distance';
    header.compression='none';
    while ~(size(findstr(line,'}'),2)==1 && size(line,2)==1)
        [variable,value]=analyse_edfline(line);
        if size(variable)>0
            if isvarname(variable)
                eval(['header.' variable '=''' value ''';']);
            end
            bo=bo+strcmp(variable,'byteorder')+strcmp(variable,'datatype')+strcmp(variable,'dim_1')+strcmp(variable,'dim_2');
        end
        line=fgetl(fid);
    end
    
    edf_datablocks=0;
    while ehffile==1 && ~feof(fid)
        while line~='{'
            line=fgetl(fid);
        end
        edf_datablocks=edf_datablocks+1;
        while size(findstr(line,'}'))==0
            [variable,value]=analyse_edfline(line);
            if size(variable,1)>0 && edf_datablocks==datablock
                if isvarname(variable)
                    eval(['header.' variable '=''' value ''';']);
                end
                bo=bo+strcmp(variable,'byteorder')+strcmp(variable,'datatype')+strcmp(variable,'dim_1')+strcmp(variable,'dim_2');
            end
            line=fgetl(fid);
        end
    end
    if ehffile==1 && edf_datablocks>1
        header.title=[header.title ' (' num2str(datablock) ' of ' num2str(edf_datablocks) ')'];
    end
    header.edf_datablocks=num2str(edf_datablocks);
    
    if bo==4
        if strcmp(lower(header.byteorder),'highbytefirst')
            byteorder='b';
        else
            byteorder='l';
        end
    else
        image_data=0; variance_data=0; header.title='error';fclose(fid); return;
    end
    if ~size(str2num(header.edf_headersize),2)
        header.edf_headersize=header.edf_binaryfileposition;
    end
    if ~size(str2num(header.edf_headersize),2) || str2num(header.edf_headersize)==0
        header.edf_headersize=num2str(ftell(fid));
    end
    
    fclose(fid);
    if ehffile==1
        filename=header.edf_binaryfilename;
    end
    
    fid=fopen(filename,'r',byteorder); % re-open with good format
    
    xsize=str2num(header.dim_1);
    ysize=str2num(header.dim_2);
    rows=1:xsize;
    columns=1:ysize;
    switch lower(header.datatype)
        case {'unsignedbyte','unsigned8'}
            datatype='uint8';
            nbytes=1;
        case {'signedbyte','signed8'}
            datatype='int8';
            nbytes=1;
        case {'unsignedshort','unsigned16'}
            datatype='uint16';
            nbytes=2;
        case {'signedshort','signed16'}
            datatype='int16';
            nbytes=2;
        case {'unsignedinteger','unsignedlong','unsigned32'}
            datatype='uint32';
            nbytes=4;
        case {'signedinteger','signedlong','signed32'}
            datatype='int32';
            nbytes=4;
        case 'unsigned64'
            datatype='uint64';
            nbytes=8;
        case 'signed64'
            datatype='int64';
            nbytes=8;
        case {'float','floatvalue','real'}
            datatype='float32';
            nbytes=4;
        case 'doublevalue'
            datatype='double';
            nbytes=8;
    end
    
    fseek(fid,str2num(header.edf_headersize),-1);               % re-position at end of 1st header
    if strcmpi(header.compression,'zcompression')
        if strcmpi(datatype,'float32')
            datatype='single';
        end
        Z=fread(fid,str2num(header.edf_binarysize));
        import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;
        a=java.io.ByteArrayInputStream(Z);
        b=java.util.zip.InflaterInputStream(a);
        isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
        c = java.io.ByteArrayOutputStream;
        isc.copyStream(b,c);
        bytes=typecast(c.toByteArray,['uint8']);
        if strcmp(byteorder,'l')
            image_data=reshape((typecast(bytes,datatype)),str2num(header.dim_1),str2num(header.dim_2));
        else
            image_data=reshape(swapbytes(typecast(bytes,datatype)),str2num(header.dim_1),str2num(header.dim_2));
        end
    else
        image_data=fread(fid,[length(rows),length(columns)],sprintf('%d*%s',length(rows),datatype),nbytes*(xsize-length(rows)));
    end
    %convert to double if not already the case
    image_data=double(image_data);
    
    if strcmp(header.edf_binarysize,'0')
        variance_data=0;
    else
        fseek(fid,str2num(header.edf_headersize)*2+str2num(header.edf_binarysize),-1);               % re-position at end of 2nd header
        if strcmpi(header.compression,'zcompression')
            if strcmpi(datatype,'float32')
                datatype='single';
            end
            Z=fread(fid);
            if size(Z,1)>1
                import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;
                a=java.io.ByteArrayInputStream(Z);
                b=java.util.zip.InflaterInputStream(a);
                isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
                c = java.io.ByteArrayOutputStream;
                isc.copyStream(b,c);
                bytes=typecast(c.toByteArray,'uint8');
                if strcmp(byteorder,'l')
                    variance_data=reshape((typecast(bytes,datatype)),str2num(header.dim_1),str2num(header.dim_2));
                else
                    variance_data=reshape(swapbytes(typecast(bytes,datatype)),str2num(header.dim_1),str2num(header.dim_2));
                end
            else
                variance_data=0;
            end
        else
            variance_data=fread(fid,[length(rows),length(columns)],sprintf('%d*%s',length(rows),datatype),nbytes*(xsize-length(rows)));
        end
        
    end
    
    if size(image_data)~=size(variance_data)
        variance_data=0;
    end
    
    fclose(fid);
end


function [result1,result2]=analyse_edfline(data)
data=deblank(data);
pos=findstr('=',data);
if ~isempty(pos)
    result1=lower(strtrim(strrep(strrep(data(1:pos(1)-1),'-','_'),'~','_')));
    result2=strtrim(data(pos(1)+1:size(data,2)-1));
else
    result1='';
    result2='';
end
