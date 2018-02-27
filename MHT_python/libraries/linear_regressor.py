import numpy as np
import pandas as pd

my_data = np.array([[5, 4, 1],
                    [3, 4, 3],
                    [1, 5, 2],
                    [4, 4, 2],
                    [7, 8, 1]])

df = pd.DataFrame(data=my_data, columns=['x', 'y', 'z'])


def linear_regressor_data(input):
    print("function")

    size = input.shape
    print(input.head())
    print(size)


print("main")
linear_regressor_data(df)
