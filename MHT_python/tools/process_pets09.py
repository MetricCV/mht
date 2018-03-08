import os
from process_xml import process_xml
from process_features import process_features
from sklearn.decomposition import PCA
import numpy as np
import _pickle as pk
import pandas as pd
import code


def main():
	file = "vgg"
	file_obj = open(file, 'wb')
	df = process_xml()
	print("\nCounting of number of register per person")
	print(df.groupby("id").size())

	feat_vgg = process_features(df)
	print("feat_vgg shape: ", feat_vgg.shape)
	pk.dump(feat_vgg,file_obj)
	file_obj.close()

	pca_obj = PCA(n_components=256)
	pca_obj.fit(feat_vgg)
	print("features PCA type: ", type(pca_obj.components_))
	print("features PCA: ", pca_obj.components_)
	# np.savetxt("pca.csv", pca_obj, delimiter=",")




if __name__ == '__main__':
	main()