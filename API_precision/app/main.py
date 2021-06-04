import uvicorn
from fastapi import FastAPI,File,UploadFile
from fastapi.responses import StreamingResponse,FileResponse
import tensorflow as tf
from tensorflow import keras
import numpy as np
from PIL import Image
import io
import base64
import torch

#Plant village dataset class names

class_names_plv= ['Apple___Apple_scab',
 'Apple___Black_rot',
 'Apple___Cedar_apple_rust',
 'Apple___healthy',
 'Blueberry___healthy',
 'Cherry___healthy',
 'Cherry___Powdery_mildew',
 'Corn___Cercospora_leaf_spot Gray_leaf_spot',
 'Corn___Common_rust',
 'Corn___healthy',
 'Corn___Northern_Leaf_Blight',
 'Grape___Black_rot',
 'Grape___Esca_(Black_Measles)',
 'Grape___healthy',
 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
 'Orange___Haunglongbing_(Citrus_greening)',
 'Peach___Bacterial_spot',
 'Peach___healthy',
 'Pepper,_bell___Bacterial_spot',
 'Pepper,_bell___healthy',
 'Potato___Early_blight',
 'Potato___healthy',
 'Potato___Late_blight',
 'Raspberry___healthy',
 'Soybean___healthy',
 'Squash___Powdery_mildew',
 'Strawberry___healthy',
 'Strawberry___Leaf_scorch',
 'Tomato___Bacterial_spot',
 'Tomato___Early_blight',
 'Tomato___healthy',
 'Tomato___Late_blight',
 'Tomato___Leaf_Mold',
 'Tomato___Septoria_leaf_spot',
 'Tomato___Spider_mites Two-spotted_spider_mite',
 'Tomato___Target_Spot',
 'Tomato___Tomato_mosaic_virus',
 'Tomato___Tomato_Yellow_Leaf_Curl_Virus']
#deep weed dataset class names
class_names_weed=['Chinee Apple',
               'Lantana',
               'Parkinsonia',
               'Parthenium',
               'Prickly Acacia',
               'Rubber Vine',
               'Siam Weed',
               'Snake Weed',
               'Negatives']
#Reading models
def plant_village_model():
    model=keras.models.load_model('models/plantvillage.h5')
    return model

def weed_model():
    model=keras.models.load_model('models/deep_weed.h5')
    return model
#creare an app to post and get requests from the API
app=FastAPI()
@app.get("/")
def read_root():
    return {"API status": "Welcome to Agriola!"}
#Model 1 - Plant village diseases
@app.post("/predict/plant_village")
async def predict_plv(image:UploadFile=File(...)):
    contents=await image.read()
    im=Image.open(io.BytesIO(contents))
    im=im.convert('RGB')
    im=im.resize((299,299))
    im=np.array(im)/255.0
    im=np.expand_dims(im,0)
    model=plant_village_model()
    prediction=model.predict(im)[0]
    prediction = np.argmax(prediction)
    return {'prediction':class_names_plv[int(prediction)]}

#Model 2 - Deep Weed

@app.post("/predict/weed_detection")
async def predict_weed(image:UploadFile=File(...)):
    contents=await image.read()
    im=Image.open(io.BytesIO(contents))
    im=im.convert('RGB')
    im=im.resize((256,256))
    im=np.array(im)/255
    im=np.expand_dims(im,0)
    model=weed_model()
    prediction=model.predict(im)
    prediction = np.argmax(prediction)
    return {'prediction':class_names_weed[int(prediction)]}

#Model 3 - Wheat Counting

@app.post("/predict/wheat_count")
async def predict_wheat(image:UploadFile=File(...)):
    contents=await image.read()
    im=Image.open(io.BytesIO(contents))
    #im=im.resize((300,300))
    model=torch.hub.load('ultralytics/yolov5', 'custom','models/best.pt')
    results=model(im)
    results.render()
    for img in results.imgs:
        buf=io.BytesIO()
        img_base64=Image.fromarray(img)
        img_base64.save('./media/test.JPEG')
    return FileResponse('./media/test.JPEG',media_type='image/JPEG')

@app.get("/predict/media")
def return_img():
    return FileResponse('./media/test.JPEG',media_type='image/JPEG') 