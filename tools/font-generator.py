from PIL import Image, ImageDraw, ImageFont
import os

doc_template = """
{
    "name" : "%s",
    "texture" : "%s",
    "charmap" : {
        %s
    }
}
"""


char_template = """
        "%s" : {
            "width" : %d,
            "height" : %d,
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
    cx = cy = 0.0
    maxheight = 0.0
    for i in range(32, 127):
        ch = chr(i)
        print ch,
        chwidth, chheight = imgfont.getsize(ch)

        if cx + chwidth*1.1 >= image_size:
            cx = 0.0
            cy += maxheight
        if chheight > maxheight:
            maxheight = chheight

        draw.text((cx,cy), ch, font=imgfont, fill=color)
        x = (cx + 0.0) / ix
        y = (cy + chheight + 0.0) / iy
        tw = (chwidth + 0.0) / ix
        th = (chheight + 0.0) / iy

        verts = ",".join([str(s) for s in [0.0,0.0,0.0,
                                            chwidth, 0.0, 0.0,
                                            chwidth, chheight, 0.0,
                                            0.0, chheight, 0.0]])

        uvs = ",".join([str(s) for s in [x + tw, y, x, y, x, y-th, x + tw, y-th]])
        #verts = ",".join([str(s) for s in [chwidth, 0, 0,
        #                                   0, 0, 0,
        #                                   0, chheight, 0,
        #                                   chwidth, chheight, 0]])
        chars.append( char_template % ( escape_json(ch), chwidth, chheight, uvs, verts ) )
        cx += (chwidth*1.1)
    texture_filename = font.replace(".ttf", ".png").split(os.sep)[-1]
    img.save(texture_filename)
    font_name = font.split(os.sep)[-1].split(".")[0]

    char_map = ",\n".join(chars)

    json = doc_template % ( font_name, texture_filename, char_map )

    with open( font_name + ".json", "w") as f:
        f.write(json)
    print "Done"

if __name__=='__main__':
    makeFont( "fonts\\OpenSans-Bold.ttf" )
        
    

        

        

    

        
    
    
