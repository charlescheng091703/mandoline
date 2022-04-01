#!/usr/bin/env python

import os
import numpy as np
import numpy.linalg as la
import itertools
import pickle
import json
import sqlite3
from sqlite_utils import Database
from datetime import datetime

import meshcut
import click


def get_bounding_box(index,verts,faces):
    """ Returns the corner vertices of the 3D bounding box that encloses the triangle """
    points_in_triangle = faces[index]
    list_of_points = []
    list_of_points.append(verts[points_in_triangle[0]].tolist())
    list_of_points.append(verts[points_in_triangle[1]].tolist())
    list_of_points.append(verts[points_in_triangle[2]].tolist())
    point_array = np.array(list_of_points)
    max_point = np.amax(point_array,axis=0)
    min_point = np.amin(point_array,axis=0)
    difference = max_point - min_point
    return(min_point,max_point,difference)

def get_set_of_bounding_boxes(faces,verts):
    bounding_boxes = []
    for i in range(faces.shape[0]):
        if (i % 50000 == 0):
            percent = str(100*i/faces.shape[0])[0:4]
            print("Currently at :",i,"/",faces.shape[0]," ",percent,"% ",datetime.now())
        bounding_boxes.append(get_bounding_box(i,verts,faces))
    print("Bounding boxes completed ... returning")
    return(bounding_boxes)

@click.command()

@click.argument('root_name')
@click.option('--xn', default=10.0, show_default=True)
@click.option('--yn', default=10.0, show_default=True)
@click.option('--zn', default=10.0, show_default=True)

def bin_triangles(root_name,xn,yn,zn):
    """ Program bins the triangles into planes of interest parallel to the
        x,y,z, axes  The planes of interest are determined by the scale factor
        n which creates the number of slices in the x,y and z directions """
    vertname = root_name + ".vert.npy"
    facename = root_name + ".face.npy"
    cutbin_db_filename = root_name + ".db"
    
    verts = np.load(vertname)
    faces = np.load(facename)
    vertshape = verts.shape
    vert_reshaped = verts.reshape(vertshape[0],vertshape[2])

    print("Determining the bins to presort triangles for calculations")
    bin_multiplier = (xn,yn,zn)
    # min_index and max_index are the min and max indicies in all 3 directions.
    min_index = np.floor((bin_multiplier*np.amin(vert_reshaped,axis=0)))
    max_index = np.ceil((bin_multiplier*np.amax(vert_reshaped,axis=0)))
    print("Lower Right Hand Corner of Box", min_index)
    print("Upper Left Hand Corner of Box",  max_index)    
    cut_bins_db = Database(sqlite3.connect(cutbin_db_filename))
    cut_bins_vars = cut_bins_db['variables']
    cut_bins_data = []
    cut_bins_vars.insert({"name": "xn",
                               "value" : bin_multiplier[0],})
    cut_bins_vars.insert({"name": "yn",
                               "value" : bin_multiplier[1],})
    cut_bins_vars.insert({"name": "zn",
                               "value" : bin_multiplier[2],})    
    cut_bins_data.append(cut_bins_db['X'])
    cut_bins_data.append(cut_bins_db['Y'])
    cut_bins_data.append(cut_bins_db['Z'])

#    cut_bins_data.append(open(root_name + "_x.dat", "w"))
#    cut_bins_data.append(open(root_name + "_y.dat", "w"))
#    cut_bins_data.append(open(root_name + "_z.dat", "w"))                         


    slice_index_dict = {}
    triangle_index_dict = {}
    for axis in range(3):
        slice_index_dict[axis] = []
        triangle_index_dict[axis] = []

    
# Init the cut_bin dictionary which will contain a list of all of the triangles that
# are part of the list.
#    for axis in range(3):
#        cut_bin = {}
#        for i in range(int(min_index[axis]),int(max_index[axis])+1):
#            cut_bin[i] = []
#        cut_bins.append(cut_bin)
#    Get the bounding box of each triangle and sort into 

    for triangle_index in range(faces.shape[0]):
# Output a status every 50000 calculations
       if (triangle_index % 50000 == 0):
           percent = str(100*triangle_index/faces.shape[0])[0:4]
           print("Currently at :",triangle_index,"/",faces.shape[0]," ",percent,"% ",datetime.now())
# Get the bounding box of the triangle and then calculate minimum and maximum indices for
# the slices that the triangle intersects.
       bounding_box = get_bounding_box(triangle_index,vert_reshaped,faces)
       box_minimum_indices = np.floor(bin_multiplier*bounding_box[0])
       box_maximum_indices = np.ceil(bin_multiplier*bounding_box[1])
# For each of the triangles, record all of the slice bins that are appropriate.
# Lets over specify where the triangles can be by one bin on each side.  That way
# we build in a little buffer in terms of how we need to do the slicing.
# Specify this with the "bin_safety_margin"
       bin_safety_margin = 1
       for axis in range(3):
           for bin_index in range(int(box_minimum_indices[axis])-bin_safety_margin,int(box_maximum_indices[axis])+1+bin_safety_margin):
#               result_string = str(bin_index) + "," + str(triangle_index) + "\n"
#               cut_bins_data[axis].write(result_string)
               slice_index_dict[axis].append(bin_index)
               triangle_index_dict[axis].append(triangle_index)

#    print("Writing db")
    for axis in range(3):
#        cut_bins_data[axis].close()
       cut_bins_data[axis].insert_all(({"slice_index" : slice_index_dict[axis][i],
                                        "triangle_index" : triangle_index_dict[axis][i] ,
                                        } for i in range(len(slice_index_dict[axis]))) ,batch_size=10000) 
    
    print("Lower Right Hand Corner of Box", min_index)
    print("Upper Left Hand Corner of Box",  max_index)
# Add the ranges of the binned variables
# This is just done as a convenience to downstream applications.
    cut_bins_vars.insert({"name": "Xmin",
                               "value" : min_index[0],})
    cut_bins_vars.insert({"name": "Ymin",
                               "value" : min_index[1],})
    cut_bins_vars.insert({"name": "Zmin",
                               "value" : min_index[2],})
    cut_bins_vars.insert({"name": "Xmax",
                               "value" : max_index[0],})
    cut_bins_vars.insert({"name": "Ymax",
                               "value" : max_index[1],})
    cut_bins_vars.insert({"name": "Zmax",
                               "value" : max_index[2],})        
    
if __name__ == '__main__':
    bin_triangles()
