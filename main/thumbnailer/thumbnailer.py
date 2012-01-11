# Clasificador Nit i Dia - GDSA - G41

import sys,os,Image

def generate_and_save_thumbnail(imageFile,thumb_dir, h, w):
    
    #Initialize
    base = os.path.basename(imageFile)
    ext  = os.path.splitext(base)[1]
    prefix = 'thumb_'

    #Create thumb dir if not exists
    if not os.path.isdir(thumb_dir):
        os.mkdir(thumb_dir)

    #Thumb file path construction
    imageThumbPath = os.path.join(thumb_dir,prefix + base + ext)
    
    #Create thumb if not exists
    if not os.path.isfile(imageThumbPath):
        image = Image.open(imageFile)
        image = image.resize((w, h), Image.ANTIALIAS)
        image.save(imageThumbPath)

    return imageThumbPath


#Input arguments
image = sys.argv[1]
thumb_dir = sys.argv[2]
h = int(sys.argv[3])
w = int(sys.argv[4])

print generate_and_save_thumbnail(image,thumb_dir, h, w)