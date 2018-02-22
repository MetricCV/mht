import pandas as pd


def create_dres():
    di = {'x': [1, 1, 1], "y": [2, 2, 2], "bx": [3, 3, 3], "by": [4, 4, 4],
          "w": [45, 45, 45], "h": [50, 50, 50], "r": [0.3, 0.4, -1],
          "fr": [8, 9, 10], "chist": [10, 10, 10], "hog": [11, 11, 11],
          "cnn": [12, 12, 12]}

    dres = pd.DataFrame(di)
    return dres
