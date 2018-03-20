# MySUNRGBDtoolbox(still underdeveloped)


this is a sunrgbd toolbox modified based on the official toolbox can  
1: crop rgb, depth image accroding to 2dbbox annotation  
2: extract rotation matrix and tranlsation vector from SUNRGBDMeta3DBB_v2.mat  
3: crop seg.mat according to 2dbbox extraced from SUNRGBDMeta2DBB_v2.mat, but SUNRGBD dont have a corresponding relationship   between seg.mat's objects and 2dbbox annotaion, so we cant get a accurate segmentation for every object in image  




#next goal:

1.find an elegant way to store the global variables
2.refactoring the whole project
3.divide into more modules