#!/bin/bash


# folder tree 
#  WORK_DIR/
#  ├── input/
#  │    └──<image files>
#  ├── result/
#  └── tmp/
 
WORK_DIR=~/mask_test
#LIB=<OpenMVG executable file directory>
#BUILD_DIR=<openMVS executable file directory>

rm -rf  $WORK_DIR/result/* 
rm -rf $WORK_DIR/tmp/*
mkdir -p $WORK_DIR/result/matches  $WORK_DIR/result/mvs  $WORK_DIR/result/reconstruction_sequential

$LIB/openMVG/bin/openMVG_main_SfMInit_ImageListing -i $WORK_DIR/input -o $WORK_DIR/result/matches -d /home/yabushita/psc/conf/sensor_width_camera_database.txt
$LIB/openMVG/bin/openMVG_main_ComputeFeatures -i $WORK_DIR/result/matches/sfm_data.json -o $WORK_DIR/result/matches  -f 1 
$LIB/openMVG/bin/openMVG_main_ComputeMatches -i $WORK_DIR/result/matches/sfm_data.json -o $WORK_DIR/result/matches -f 1
$LIB/openMVG/bin/openMVG_main_IncrementalSfM2 -i $WORK_DIR/result/matches/sfm_data.json -m $WORK_DIR/result/matches -o $WORK_DIR/result/reconstruction_sequential
$LIB/openMVG/bin/openMVG_main_openMVG2openMVS -d $WORK_DIR/tmp/undistorted_images -i $WORK_DIR/result/reconstruction_sequential/sfm_data.bin -o $WORK_DIR/result/mvs/scene.mvs
$BUILD_DIR/openMVS_with_eigin_latest/bin/DensifyPointCloud -w $WORK_DIR/tmp $WORK_DIR/result/mvs/scene.mvs 
$BUILD_DIR/openMVS_with_eigin_3.2/bin/ReconstructMesh -w $WORK_DIR/tmp $WORK_DIR/result/mvs/scene_dense.mvs 
$BUILD_DIR/openMVS_with_eigin_3.2/bin/TextureMesh -w $WORK_DIR/tmp  $WORK_DIR/result/mvs/scene_dense_mesh.mvs


