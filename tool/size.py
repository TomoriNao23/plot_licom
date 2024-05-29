from PIL import Image
import matplotlib.pyplot as plt
import os

#类act裁剪图片大小并在.ipynb中显示

class act:
    
    def __init__(self,path,rect):
        self.p = path
        self.r = rect
        self.tem = "./tem.png"
        self.figs = (15, 15)#显示大小

    def imageshow(self):
        img_out = Image.open(self.tem)
        plt.figure(figsize = self.figs)
        plt.axis('off')
        plt.imshow(img_out)
        plt.show()

    def size_change(self):
        img = Image.open(self.p)
        print(img.size)
        crop_image = img.crop(self.r)
        crop_image.save(self.tem)
        self.imageshow()

    def save(self):
        os.system("cp ./tem.png "+self.p)
        os.system("rm ./tem.png")
        