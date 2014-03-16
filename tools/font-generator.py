from PIL import Image, ImageDraw, ImageFont
import os, math

doc_template = """
{
    "name" : "%s",
    "texture" : "%s",
    "charmap" : {
        %s
    }
}
"""


descenders = 'pqy'


char_template = """
        "%s" : {
            "width" : %2.2f,
            "height" : %2.2f,
            "uvs": [ %s ],
            "verts" : [ %s ]
        }"""

def escape_json(s):
    s = s.replace("\\", "\\\\")
    s = s.replace("\"", '\\"')
    return s

def makeFont( font, color="#ffffff", font_size=36, image_size=512 ):
    img = Image.new("RGBA", (image_size, image_size))
    imgfont = ImageFont.truetype(font, font_size)
    ix, iy = image_size, image_size
    chars = []
    draw = ImageDraw.Draw(img)
    cx = 0
    cy = 0
    maxheight = 0

    DPI = 1.0 / float(font_size)

    for i in range(32, 127):
        ch = chr(i)
        print ch,
        chwidth, chheight = imgfont.getsize(ch)

        offsetx, offsety = imgfont.getoffset(ch)

        print ch, offsetx, offsety

        if cx + int(math.ceil(chwidth*1.1)) >= image_size:
            cx = 0
            cy += maxheight
        if chheight > maxheight:
            maxheight = chheight




        draw.text((int(cx),int(cy)), ch, font=imgfont, fill=color)

        # find bottom left corner in UV space
        x = (cx + 0.0) / ix
        y = 1.0 - ((cy+offsety + chheight + 0.0) / iy)


        tw = (chwidth + 0.0) / ix
        th = ((chheight + 0.0) / iy)

        descend = int( ch in descenders )

        offsety = offsety * descend

        voff = offsety * DPI

        verts = ",".join([str(s) for s in [0.0,-voff,0.0,
                                            chwidth*DPI, -voff, 0.0,
                                            chwidth*DPI, (-offsety+chheight)*DPI, 0.0,
                                            0.0, (-offsety+chheight)*DPI, 0.0]])
        uvs = ",".join([str(s) for s in [ x, y, x+tw, y, x+tw, y+th, x, y+th ]])
        #uvs = ",".join([str(s) for s in [x + tw, y, x, y, x, y-th, x + tw, y-th]])
        #verts = ",".join([str(s) for s in [chwidth, 0, 0,
        #                                   0, 0, 0,
        #                                   0, chheight, 0,
        #                                   chwidth, chheight, 0]])
        chars.append( char_template % ( escape_json(ch), float(chwidth)*DPI, float(chheight)*DPI, uvs, verts ) )
        cx += int(math.ceil(chwidth*1.1))
    texture_filename = font.replace(".ttf", ".png").split(os.sep)[-1]
    img.save(texture_filename)
    font_name = font.split(os.sep)[-1].split(".")[0]

    char_map = ",\n".join(chars)

    json = doc_template % ( font_name, texture_filename, char_map )

    with open( font_name + ".json", "w") as f:
        f.write(json)
    print "Done"

if __name__=='__main__':
    makeFont( "fonts\\arial.ttf" )
    import os, shutil

    p = os.path.abspath(os.curdir)

    outImagePath = os.path.join(p, os.pardir, 'www')
    outConfigPath = os.path.join(p, os.pardir, 'www', 'app', 'resources')

    shutil.copy('arial.png', outImagePath)
    shutil.copy('arial.json', outConfigPath)

        
    

        

        

    

        
    
    
