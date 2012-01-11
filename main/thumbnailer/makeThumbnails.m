function [ thumbnail ] = makeThumbnails(image, thumbnail_dir,h,w)
    image = strrep(image, ' ', '\ ');
    thumbnail_dir = strrep(thumbnail_dir, ' ', '\ ');
    pyCall = char(['python ./thumbnailer/thumbnailer.py ' image ' ' thumbnail_dir ' ' int2str(h) ' '  int2str(w)]);
    [~,thumbnail] = system(pyCall);
end

