

function pose = get_obj_pose(centroid, basis, Rtilt)

   pose = eye(4, 4);
   pose(1:3, 1:3) = Rtilt * basis;
   pose(1:3, 4) = centroid;

end