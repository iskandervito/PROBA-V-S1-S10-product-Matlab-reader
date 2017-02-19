% Copyright (C) <2014>  <Iskander Benhadj> email <iskander.benhadj@vito.be>
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
clc;
close all;
clear all;
fclose all;

%Settings
cfgfile = './cfg/layers.txt';
version = '1.0';
fprintf('       --------------------------------\n');
fprintf('       *        PV-EXTRACT v1.0       *\n');
fprintf('       --------------------------------\n');
if exist(cfgfile,'file') == 0
    error([cfgfile,' file not found']);
end
%-------------------------------------%
% Get layer info                      %
%-------------------------------------%
fid = fopen(cfgfile,'r');
tline ='t';
cnt = 1;
while ischar(tline)
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    if strfind(tline,'#')
        continue
    end
    layer(cnt).value = strtrim(tline);
    layer(cnt).value = deblank(layer(cnt).value);
    cnt = cnt+1;
end
if isempty(layer)
    error([cfgfile, ' is an emty file']);
end
fclose(fid);

pvlist = dir('./input/*.hdf5');
if isempty(pvlist)
    pvlist = dir('./input/*.HDF5');
    if isempty(pvlist)
        error('empty input folder');
    end
end
%-------------------------------------%
% Extract layer data                  %
%-------------------------------------%
%Get the number of files
n = length(pvlist);

%loop on the files
for j = 1:n
    tic;
    productname = ['./input/',pvlist(j).name];
    fprintf('Extracting data from %s\n',productname);
    [pathstr, name] = fileparts(productname);
    %create the output dir if it does not exist
    outdir = ['./output/',name];
    if exist(outdir,'dir') == 0
        mkdir(outdir);
    end
    %loop on layer to be extracted
    for nl = 1:length(layer)
        lval = layer(nl).value;
        
        %get metadata and create header
        try
            info = h5info(productname,['/',lval]);
        catch exception
            % fprintf('-> Failed Layer not found!\n');
            %warning (['Layer ', lval,' is not found in the product ',name,'.HDF5']);
            continue; %next layer
        end
        fprintf('      Extracting %s ',lval);
        extra = regexprep(lval,'\/','-');
        fileout = [outdir,'/',name,'-',extra,'.img'];
        %run h5dump to extract the image from the HD5 PROBA-V product
        
        %check the type of the operating system (32 or 64bits)
        os = computer;
        if strcmp(os,'PCWIN64')
            [status, result] = system(['.\bin\h5dump_64.exe -d ',lval,' -b LE -o ',fileout,' ',productname]);
        else
            if strcmp(os,'PCWIN')
                [status, result] = system(['.\bin\h5dump_32.exe -d ',lval,' -b LE -o ',fileout,' ',productname]);
            else
                if  strcmp(os,'GLNXA64')
                    [status, result] = system(['./bin/h5dump -d ',lval,' -b LE -o ',fileout,' ',productname]);
                else
                    error('Operating system not supported!! (linux  or windows)');
                end
            end
        end
        if status~=0
            if ~isempty(result)
                error(result);
            else
                error('h5dump conflict operating system!!');
            end
            return;
            
        end
        
        %get image type
        s = info.Datatype.Size;
        switch (s)
            case  1
                type = 1;
            case  2
                type = 2;
            otherwise
                error('Type not yet supported!!')
        end
        
        %Write the envi header for the extracted image
        fid = fopen([fileout(1:end-3),'hdr'],'w');
        fprintf(fid,'%s\n','ENVI');
        fprintf(fid,'%s\n',['description = {',extra,' Generated by PV_extract v',version,'}']);
        fprintf(fid,'%s\n',['samples = ',num2str(info.Dataspace.Size(1))]);
        fprintf(fid,'%s\n',['lines   = ',num2str(info.Dataspace.Size(2))]);
        fprintf(fid,'%s\n','bands   = 1');
        fprintf(fid,'%s\n','sensor type   = PROBA-V');
        fprintf(fid,'%s\n',['data ignore value = ',num2str(info.Attributes(4).Value)]);
        fprintf(fid,'%s\n',['data offset values = ',num2str(info.Attributes(2).Value)]);
        fprintf(fid,'%s\n',['data scale values = ',num2str(info.Attributes(1).Value)]);
        fprintf(fid,'%s\n','header offset = 0');
        fprintf(fid,'%s\n','file type = ENVI Standard');
        fprintf(fid,'%s\n',['data type = ',num2str(type)]);
        fprintf(fid,'%s\n','interleave = bsq');
        fprintf(fid,'%s\n','sensor type = Unknown');
        fprintf(fid,'%s\n','byte order = 0');
        fprintf(fid,'%s\n','wavelength units = Unknown');
        if(length(info.Attributes(5).Value) == 9)
            index = 5;
        else
            index = 6;
        end
        fprintf(fid,'%s\n',['map info = {Geographic Lat/Lon, 1.500, 1.500,', char(info.Attributes(index).Value(4)),', ', ...
            char(info.Attributes(index).Value(5)),', ',char(info.Attributes(index).Value(6)),', ', ...
            char(info.Attributes(index).Value(6)),', WGS84,units=Degrees}']);
        fclose(fid);
        fprintf('-> Done!\n');
    end
    toc;
end
fprintf('Job extraction done!\n');