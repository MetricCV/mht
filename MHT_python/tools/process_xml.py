import pandas as pd
import xmltodict as xd
#import extract_features as ef

def process_xml():

  df = pd.DataFrame()
  with open('PETS2009-S2L1.xml') as fd:
      doc = xd.parse(fd.read())

  c = 0

  frame_list = doc['dataset']['frame']
  for frame in frame_list:
      frame_id = int(frame['@number'])
      frame_obj_list = frame['objectlist']['object']

      result = list()
      for frame_obj in frame_obj_list:
          result.append({'frame_id': frame_id,
                         'id': int(frame_obj['@id']),
                         'x': float(frame_obj['box']['@xc']),
                         'y': float(frame_obj['box']['@yc']),
                         'w': float(frame_obj['box']['@w']),
                         'h': float(frame_obj['box']['@h'])})

      if len(df) == 0:
          df = pd.DataFrame(result,
                            columns=['frame_id', 'id', 'x', 'y', 'w', 'h'])
      else:
          df = df.append(result)

  df['tl_x'] = (df['x']-df['w']/2).astype(int)
  df['br_x'] = (df['x']+df['w']/2).astype(int)

  df['tl_y'] = (df['y']-df['h']/2).astype(int)
  df['br_y'] = (df['y']+df['h']/2).astype(int)

  df.reset_index(inplace=True)
  print(df.head())
  print("Number of elements: ", len(df))

  df.to_csv("pets09_groundtruth.csv", index=False )

  return df