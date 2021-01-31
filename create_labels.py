# -*- coding: utf-8 -*-
"""create_labels.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1QX2hUKO5Lpv1VuJBNDyQ7tjr-KqhreV3
"""

import cv2
import numpy as np
import matplotlib.pyplot as plt
import os
from osgeo import gdal, ogr
from google.colab import drive
drive.mount('/drive')

path=[x[0] for x in os.walk('/content/drive/MyDrive/areas_rgb')]

path=sorted(path)

path

path=['/content/drive/MyDrive/areas_rgb/abukebir/Pair1',
 '/content/drive/MyDrive/areas_rgb/abukebir/Pair2',
 '/content/drive/MyDrive/areas_rgb/abukebir/Pair3',
 '/content/drive/MyDrive/areas_rgb/abukebir/Pair4',
  '/content/drive/MyDrive/areas_rgb/annubariyah/Pair1',
 '/content/drive/MyDrive/areas_rgb/annubariyah/Pair2',
 '/content/drive/MyDrive/areas_rgb/annubariyah/Pair3',
 '/content/drive/MyDrive/areas_rgb/banha/Pair1',
 '/content/drive/MyDrive/areas_rgb/banha/Pair2',
 '/content/drive/MyDrive/areas_rgb/banha/Pair3',
 '/content/drive/MyDrive/areas_rgb/banha/Pair4',
 '/content/drive/MyDrive/areas_rgb/beheira_etay/Pair1',
 '/content/drive/MyDrive/areas_rgb/beheira_etay/Pair2',
 '/content/drive/MyDrive/areas_rgb/beheira_etay/Pair3',
 '/content/drive/MyDrive/areas_rgb/beheira_etay/Pair4',
 '/content/drive/MyDrive/areas_rgb/beheria_qarya/Pair1',
 '/content/drive/MyDrive/areas_rgb/beheria_qarya/Pair2',
 '/content/drive/MyDrive/areas_rgb/beheria_qarya/Pair3',
 '/content/drive/MyDrive/areas_rgb/beheria_qarya/Pair4',
 '/content/drive/MyDrive/areas_rgb/bishla/Pair1',
 '/content/drive/MyDrive/areas_rgb/bishla/Pair2',
 '/content/drive/MyDrive/areas_rgb/bishla/Pair3',
 '/content/drive/MyDrive/areas_rgb/bishla/Pair4',
 '/content/drive/MyDrive/areas_rgb/biyla/Pair1',
 '/content/drive/MyDrive/areas_rgb/biyla/Pair2',
 '/content/drive/MyDrive/areas_rgb/biyla/Pair3',
 '/content/drive/MyDrive/areas_rgb/biyla/Pair4',
  '/content/drive/MyDrive/areas_rgb/blbes/Pair1',
 '/content/drive/MyDrive/areas_rgb/blbes/Pair2',
 '/content/drive/MyDrive/areas_rgb/blbes/Pair3',
 '/content/drive/MyDrive/areas_rgb/damanhour/Pair1',
 '/content/drive/MyDrive/areas_rgb/damanhour/Pair2',
 '/content/drive/MyDrive/areas_rgb/damanhour/Pair3',
 '/content/drive/MyDrive/areas_rgb/damanhour/Pair4',
 '/content/drive/MyDrive/areas_rgb/damietta/Pair1',
 '/content/drive/MyDrive/areas_rgb/damietta/Pair2',
 '/content/drive/MyDrive/areas_rgb/damietta/Pair3',
 '/content/drive/MyDrive/areas_rgb/damietta/Pair4',
 '/content/drive/MyDrive/areas_rgb/elkasasin/Pair1',
 '/content/drive/MyDrive/areas_rgb/elkasasin/Pair2',
 '/content/drive/MyDrive/areas_rgb/elkasasin/Pair3',
 '/content/drive/MyDrive/areas_rgb/elkasasin/Pair4',
 '/content/drive/MyDrive/areas_rgb/fayoum/Pair1',
 '/content/drive/MyDrive/areas_rgb/fayoum/Pair2',
 '/content/drive/MyDrive/areas_rgb/fayoum/Pair3',
 '/content/drive/MyDrive/areas_rgb/fayoum/Pair4',
 '/content/drive/MyDrive/areas_rgb/gamaleya/Pair1',
 '/content/drive/MyDrive/areas_rgb/gamaleya/Pair2',
 '/content/drive/MyDrive/areas_rgb/gamaleya/Pair3',
 '/content/drive/MyDrive/areas_rgb/gamaleya/Pair4',
 '/content/drive/MyDrive/areas_rgb/geiza/Pair1',
 '/content/drive/MyDrive/areas_rgb/geiza/Pair2',
 '/content/drive/MyDrive/areas_rgb/geiza/Pair3',
 '/content/drive/MyDrive/areas_rgb/geiza/Pair4',
 '/content/drive/MyDrive/areas_rgb/housh_eissa/Pair1',
 '/content/drive/MyDrive/areas_rgb/housh_eissa/Pair2',
 '/content/drive/MyDrive/areas_rgb/housh_eissa/Pair3',
 '/content/drive/MyDrive/areas_rgb/housh_eissa/Pair4',
 '/content/drive/MyDrive/areas_rgb/kafr_eldawar/Pair1',
 '/content/drive/MyDrive/areas_rgb/kafr_eldawar/Pair2',
 '/content/drive/MyDrive/areas_rgb/kafr_eldawar/Pair3',
 '/content/drive/MyDrive/areas_rgb/kafr_eldawar/Pair4',
 '/content/drive/MyDrive/areas_rgb/kafr_elsheikh/Pair1',
 '/content/drive/MyDrive/areas_rgb/kafr_elsheikh/Pair2',
 '/content/drive/MyDrive/areas_rgb/kafr_elsheikh/Pair3',
 '/content/drive/MyDrive/areas_rgb/kafr_elsheikh/Pair4',
 '/content/drive/MyDrive/areas_rgb/mansoura/Pair1',
 '/content/drive/MyDrive/areas_rgb/mansoura/Pair2',
 '/content/drive/MyDrive/areas_rgb/mansoura/Pair3',
 '/content/drive/MyDrive/areas_rgb/mansoura/Pair4',
 '/content/drive/MyDrive/areas_rgb/mutubas/Pair1',
 '/content/drive/MyDrive/areas_rgb/mutubas/Pair2',
 '/content/drive/MyDrive/areas_rgb/mutubas/Pair3',
 '/content/drive/MyDrive/areas_rgb/mutubas/Pair4',
 '/content/drive/MyDrive/areas_rgb/north_cairo/Pair1',
 '/content/drive/MyDrive/areas_rgb/north_cairo/Pair2',
 '/content/drive/MyDrive/areas_rgb/north_cairo/Pair3',
 '/content/drive/MyDrive/areas_rgb/north_cairo/Pair4',
 '/content/drive/MyDrive/areas_rgb/portsaid/Pair1',
 '/content/drive/MyDrive/areas_rgb/portsaid/Pair2',
 '/content/drive/MyDrive/areas_rgb/portsaid/Pair3',
 '/content/drive/MyDrive/areas_rgb/portsaid/Pair4',
 '/content/drive/MyDrive/areas_rgb/sadat_city/Pair1',
 '/content/drive/MyDrive/areas_rgb/sadat_city/Pair2',
 '/content/drive/MyDrive/areas_rgb/sadat_city/Pair3',
 '/content/drive/MyDrive/areas_rgb/sadat_city/Pair4',
 '/content/drive/MyDrive/areas_rgb/sharqia/Pair1',
 '/content/drive/MyDrive/areas_rgb/sharqia/Pair2',
 '/content/drive/MyDrive/areas_rgb/sharqia/Pair3',
 '/content/drive/MyDrive/areas_rgb/sharqia/Pair4',
 '/content/drive/MyDrive/areas_rgb/tanta/Pair1',
 '/content/drive/MyDrive/areas_rgb/tanta/Pair2',
 '/content/drive/MyDrive/areas_rgb/tanta/Pair3',
 '/content/drive/MyDrive/areas_rgb/tanta/Pair4']

labels=[x[0] for x in os.walk('/content/drive/MyDrive/Labels')]

sorted(labels)

labels=[
 '/content/drive/MyDrive/Labels/abukebir/cmap1',
 '/content/drive/MyDrive/Labels/abukebir/cmap2',
 '/content/drive/MyDrive/Labels/abukebir/cmap3',
 '/content/drive/MyDrive/Labels/abukebir/cmap4',
   '/content/drive/MyDrive/Labels/annubariyah/cmap1',
 '/content/drive/MyDrive/Labels/annubariyah/cmap2',
 '/content/drive/MyDrive/Labels/annubariyah/cmap3',
 '/content/drive/MyDrive/Labels/banha/cmap1',
 '/content/drive/MyDrive/Labels/banha/cmap2',
 '/content/drive/MyDrive/Labels/banha/cmap3',
 '/content/drive/MyDrive/Labels/banha/cmap4',
 '/content/drive/MyDrive/Labels/beheira_etay/cmap1',
 '/content/drive/MyDrive/Labels/beheira_etay/cmap2',
 '/content/drive/MyDrive/Labels/beheira_etay/cmap3',
 '/content/drive/MyDrive/Labels/beheira_etay/cmap4',
 '/content/drive/MyDrive/Labels/beheria_qarya/cmap1',
 '/content/drive/MyDrive/Labels/beheria_qarya/cmap2',
 '/content/drive/MyDrive/Labels/beheria_qarya/cmap3',
 '/content/drive/MyDrive/Labels/beheria_qarya/cmap4',
 '/content/drive/MyDrive/Labels/bishla/cmap1',
 '/content/drive/MyDrive/Labels/bishla/cmap2',
 '/content/drive/MyDrive/Labels/bishla/cmap3',
 '/content/drive/MyDrive/Labels/bishla/cmap4',
 '/content/drive/MyDrive/Labels/biyla/cmap1',
 '/content/drive/MyDrive/Labels/biyla/cmap2',
 '/content/drive/MyDrive/Labels/biyla/cmap3',
 '/content/drive/MyDrive/Labels/biyla/cmap4',
   '/content/drive/MyDrive/Labels/blbes/cmap1',
 '/content/drive/MyDrive/Labels/blbes/cmap2',
 '/content/drive/MyDrive/Labels/blbes/cmap3',
 '/content/drive/MyDrive/Labels/damanhour/cmap1',
 '/content/drive/MyDrive/Labels/damanhour/cmap2',
 '/content/drive/MyDrive/Labels/damanhour/cmap3',
 '/content/drive/MyDrive/Labels/damanhour/cmap4',
 '/content/drive/MyDrive/Labels/damietta/cmap1',
 '/content/drive/MyDrive/Labels/damietta/cmap2',
 '/content/drive/MyDrive/Labels/damietta/cmap3',
 '/content/drive/MyDrive/Labels/damietta/cmap4',
 '/content/drive/MyDrive/Labels/elkasasin/cmap1',
 '/content/drive/MyDrive/Labels/elkasasin/cmap2',
 '/content/drive/MyDrive/Labels/elkasasin/cmap3',
 '/content/drive/MyDrive/Labels/elkasasin/cmap4',
 '/content/drive/MyDrive/Labels/fayoum/cmap1',
 '/content/drive/MyDrive/Labels/fayoum/cmap2',
 '/content/drive/MyDrive/Labels/fayoum/cmap3',
 '/content/drive/MyDrive/Labels/fayoum/cmap4',
 '/content/drive/MyDrive/Labels/gamaleya/cmap1',
 '/content/drive/MyDrive/Labels/gamaleya/cmap2',
 '/content/drive/MyDrive/Labels/gamaleya/cmap3',
 '/content/drive/MyDrive/Labels/gamaleya/cmap4',
 '/content/drive/MyDrive/Labels/geiza/cmap1',
 '/content/drive/MyDrive/Labels/geiza/cmap2',
 '/content/drive/MyDrive/Labels/geiza/cmap3',
 '/content/drive/MyDrive/Labels/geiza/cmap4',
 '/content/drive/MyDrive/Labels/housh_eissa/cmap1',
 '/content/drive/MyDrive/Labels/housh_eissa/cmap2',
 '/content/drive/MyDrive/Labels/housh_eissa/cmap3',
 '/content/drive/MyDrive/Labels/housh_eissa/cmap4',
 '/content/drive/MyDrive/Labels/kafr_eldawar/cmap1',
 '/content/drive/MyDrive/Labels/kafr_eldawar/cmap2',
 '/content/drive/MyDrive/Labels/kafr_eldawar/cmap3',
 '/content/drive/MyDrive/Labels/kafr_eldawar/cmap4',
 '/content/drive/MyDrive/Labels/kafr_elsheikh/cmap1',
 '/content/drive/MyDrive/Labels/kafr_elsheikh/cmap2',
 '/content/drive/MyDrive/Labels/kafr_elsheikh/cmap3',
 '/content/drive/MyDrive/Labels/kafr_elsheikh/cmap4',
 '/content/drive/MyDrive/Labels/mansoura/cmap1',
 '/content/drive/MyDrive/Labels/mansoura/cmap2',
 '/content/drive/MyDrive/Labels/mansoura/cmap3',
 '/content/drive/MyDrive/Labels/mansoura/cmap4',
 '/content/drive/MyDrive/Labels/mutubas/cmap1',
 '/content/drive/MyDrive/Labels/mutubas/cmap2',
 '/content/drive/MyDrive/Labels/mutubas/cmap3',
 '/content/drive/MyDrive/Labels/mutubas/cmap4',
 '/content/drive/MyDrive/Labels/north_cairo/cmap1',
 '/content/drive/MyDrive/Labels/north_cairo/cmap2',
 '/content/drive/MyDrive/Labels/north_cairo/cmap3',
 '/content/drive/MyDrive/Labels/north_cairo/cmap4',
 '/content/drive/MyDrive/Labels/portsaid/cmap1',
 '/content/drive/MyDrive/Labels/portsaid/cmap2',
 '/content/drive/MyDrive/Labels/portsaid/cmap3',
 '/content/drive/MyDrive/Labels/portsaid/cmap4',
 '/content/drive/MyDrive/Labels/sadat_city/cmap1',
 '/content/drive/MyDrive/Labels/sadat_city/cmap2',
 '/content/drive/MyDrive/Labels/sadat_city/cmap3',
 '/content/drive/MyDrive/Labels/sadat_city/cmap4',
 '/content/drive/MyDrive/Labels/sharqia/cmap1',
 '/content/drive/MyDrive/Labels/sharqia/cmap2',
 '/content/drive/MyDrive/Labels/sharqia/cmap3',
 '/content/drive/MyDrive/Labels/sharqia/cmap4',
 '/content/drive/MyDrive/Labels/tanta/cmap1',
 '/content/drive/MyDrive/Labels/tanta/cmap2',
 '/content/drive/MyDrive/Labels/tanta/cmap3',
 '/content/drive/MyDrive/Labels/tanta/cmap4']

path[55]

def convert_to_png(path=path):
  for p in paths:
    for file in os.listdir(p): 
      print(file)
      if file.endswith(".tif"): 
          img = gdal.Open(file)
          file_name, file_ext = os.path.splitext(file)
          print(file_name)
          x=gdal.Translate('{}/{}.png'.format(p,file_name), '{}/{}.tif'.format(p,file_name), format='PNG', outputType=np.uint8(), scaleParams=[[0,3000]])
          os.remove(os.path.join(p,'{}.tif'.format(file_name)))

def otsu(img):
  img = cv2.imread(img,cv2.IMREAD_COLOR)
  img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
  blur = cv2.GaussianBlur(img,(5,5),0)
  _,th = cv2.threshold(blur,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
  return th

len(path) == len(labels)

len(path)

def diff(path=path):
    for i in range(0,len(path)):
      files=os.listdir(path[i])
      img1 = otsu(img=path[i]+'/'+files[0])
      img2=otsu(img=path[i]+'/'+files[1])
      cmap=cv2.subtract(img2,img1)
      tmp=cv2.imwrite(labels[i]+'/cmap.png',cmap)
      print(i)

diff()