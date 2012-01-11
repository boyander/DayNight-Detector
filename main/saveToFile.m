function saveToFile(file,vector,precision,recall)

    %Header
    fid = fopen(file,'w');
    fprintf(fid,'\n');
    fprintf(fid,'Nom Imatge');
    fprintf(fid,'\t\t');
    fprintf(fid,'Classe real');
    fprintf(fid,'\t\t');
    fprintf(fid,'Classe assignada');
    fprintf(fid,'\n');

    %Compute all results
    L = length(vector);
    for i=1:L
        fprintf(fid,vector(i).path);
        fprintf(fid,'\t\t\t\t');
        fprintf(fid,'%d', vector(i).ground_th);
        fprintf(fid,'\t\t\t\t\t');
        fprintf(fid,'%d', vector(i).decision);
        fprintf(fid,'\n');
    end
    
    %Guardem al fitxer la precisió i el record que hem obtingut
    fprintf(fid,'\n');
    fprintf(fid,'La precisió és:');
    fprintf(fid,'\t');
    fprintf(fid,'%f',precision);
    fprintf(fid,'\n');
    fprintf(fid,'El record és:');
    fprintf(fid,'\t');
    fprintf(fid,'%f',recall);
    fprintf(fid,'\n');
    
    %Tanquem fitxer
    fclose(fid);
end

