import os
import numpy as np
from vgg16 import VGG16
from keras.preprocessing import image
from imagenet_utils import preprocess_input
import crop_images as ci


def extract():

    model = VGG16(weights='imagenet', include_top=True)

    im_file_list = ci.crop()

    for im_file in im_file_list:
        img = image.load_img(im_file, target_size=(224, 224))
        x = image.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)

        print('\nInput filename:', os.path.basename(im_file))
        print('Input image shape:', x.shape)

        features = model.predict(x)
        print("Type of features: ", type(features))
    print("Size of features: ", features.size)
    return features
