import cv2
import pandas as pd
import os
import numpy as np
from vgg16 import VGG16
from keras.preprocessing import image
from imagenet_utils import preprocess_input
from sklearn.decomposition import PCA


model = VGG16(weights='imagenet', include_top=True)

def extract_features(im_file, bb):

    img = image.load_img(im_file)
    img = img.crop((bb['tl']['x'], bb['tl']['y'], bb['br']['x'], bb['br']['y']))
    #print("type cropped img: ", type(img))
    #print("size cropped img: ", img.size)
    img = img.resize((224, 224))
    #print("type resized img: ", type(img))
    #print("size resized img: ", img.size)

    x = image.img_to_array(img)
    #x = np.array(img)
    #print("array of image: ",type(img))
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)

    print('\nInput filename:', os.path.basename(im_file))
    # print('Input image shape:', x.shape)

    feature = model.predict(x)
    feature = feature.reshape(1, -1)

    # print("Type of features: ", type(feature))
    print("Size of features: ", feature.size)

    return feature


def process_features(df, index=None):
    im_path="../Dataset/PETS09/S2/L1/View_001"
    df_img = pd.DataFrame()
    lImg = []
    size_list = []


    if index==None:
        df_id=df.id.unique()
    else:
        df_id=[index]

    result=list()
    for j in df_id:
        df_person = df[df['id'] == j]


        for i in df_person.index.values:
            im_file="frame_{0:04d}.jpg".format(df_person.loc[i, "frame_id"])
            im_file=os.path.join(im_path, im_file)

            bb = { 'tl':{'x':df_person.loc[i, "tl_x"], 'y':df_person.loc[i, "tl_y"]},
              'br':{'x':df_person.loc[i, "br_x"], 'y':df_person.loc[i, "br_y"]} }

            feat_vgg = extract_features(im_file, bb)
            feat_vgg = feat_vgg.flatten()

            result.append(feat_vgg)
        size_list.append(len(result))

    result = np.array(result)
    print(size_list)
    return result
            #lImg.append(crop_img)

            # cv2.imshow("Person 9 - Frame_id "+str(df_person.loc[i, "frame_id"]), crop_img)
            # cv2.waitKey(0)
    #   break
    #return lImg
