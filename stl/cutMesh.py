#!/usr/bin/env python
"""
Script takes the procressed triangles from an STL file and determines intersections
along different axes
"""
##
import os
import numpy as np
import numpy.linalg as la
import itertools
import pickle
import click
import sqlite3
import csv
from sqlite_utils import Database
from datetime import datetime

import meshcut

def get_all_intersections(mesh,plane,plane_orig):
    # simple function to return all of triangle intersections
    # Output is a list of dictionaries.  Target for this output is
    # an sqlite3 dtabase.
    intersections = []
    x_coords = []
    y_coords = []
    z_coords = []
    for tid, triangle in enumerate(mesh.tris):
         intersection = meshcut.compute_triangle_plane_intersections(mesh,tid,plane)
         if len(intersection) > 1:
            intersection_dict = {}
            pt1 = intersection[0][1][0]
            pt2 = intersection[1][1][0]
#            print(pt1,'| ',pt2)
            intersection_dict['x1'] = float(pt1[0])
            intersection_dict['y1'] = float(pt1[1])
            intersection_dict['z1'] = float(pt1[2])
            intersection_dict['x2'] = float(pt2[0])
            intersection_dict['y2'] = float(pt2[1])
            intersection_dict['z2'] = float(pt2[2])
            intersection_dict['plane_origin'] = plane_orig
            intersections.append(intersection_dict)
            x_coords.append(float(pt1[0]))
            x_coords.append(float(pt2[0]))
            y_coords.append(float(pt1[1]))
            y_coords.append(float(pt2[1]))
            z_coords.append(float(pt1[2]))
            z_coords.append(float(pt2[2]))                            
    return(x_coords,y_coords,z_coords,intersections)
            
def limit_faces (index,vert,faces,cut_bins_db,query):
    """ Returns an nparray of the faces that are needed to determine
        the intersections for this index """
    print("Reading Starting Limit_Faces: ",datetime.now())
    # calculate the minimum and maximum coordinates for each
    # face on the sortaxis
    # Now, bin the coordinates
    currentSlice = []
    for row in cut_bins_db.query(query):
        face_index = row['triangle_index']
        face = faces[face_index]
        pt1 = face[0]
        pt2 = face[1]
        pt3 = face[2]                
        currentSlice.append([pt1,pt2,pt3])
    limitfaces = np.array(currentSlice)
    print("i Length"," ", len(currentSlice))
    return limitfaces

@click.command()
@click.argument("fileprefix")
@click.option("--axis",type=click.Choice(['X','Y','Z']))
@click.option("--interval",type=click.INT,default=1)
@click.option("--offsetfile",default="")

def perform_mesh(fileprefix,axis,interval,offsetfile):
    """ 
    Performs the cutting of the triangles derived from the STL file along a 3D mesh 
    defined by variables in the db file as well as the command line.   The index limits 
    of the grid are given in the variables table within the db file and the interval 
    :param fileprefix: The file prefix for this calculation.  Used to calculate standard names.
    :type fileprefix: string
    :param axis: The axis to perform the slicing (X,Y,Z)
    :type axis: string
    :param interval: Determines the interval at which the mesh is sampled (normally this will be 1) 
    :type interval: int
    :param offsetfile: The name of an optional offset file to shift the slicing coordinate to help manage singularities.
    :type offsetfile: string
    """
  
    ##
    print("Reading Start: ",datetime.now())
# Read in the original vertice and face data
    verts = np.load(fileprefix + ".vert.npy")
    faces = np.load(fileprefix + ".face.npy")
# Set up filename and databases
    cutbin_db_filename = fileprefix + ".db"
    output_db_filename = fileprefix + "_intersections.db"
    cut_bins_db = Database(sqlite3.connect(cutbin_db_filename))
    output_db = Database(sqlite3.connect(output_db_filename))
# Initialize variables.
    minFace = []
    maxFace = []
    indices = []
    # Initialize the max and min for the x,y,z ooordinates to huge values
    x_min = 1.0e10
    x_max = -1.0e10
    y_min = 1.0e10
    y_max = -1.0e10
    z_min = 1.0e10
    z_max = -1.0e10
# Read in the bin dat 
    if axis == "X":
        sortaxis = 0
        for row in cut_bins_db.query("select value from variables where name = 'xn';"):
            bin_multiplier = row['value']
        for row in cut_bins_db.query("select value from variables where name = 'Xmin';"):
            start = row['value']
        for row in cut_bins_db.query("select value from variables where name = 'Xmax';"):
            stop = row['value']            
        db_table = output_db["X"]
        db_var_table = output_db["X_variables"]
        db_offset_table = output_db["X_offsets"]
    if axis == "Y":
        sortaxis = 1
        for row in cut_bins_db.query("select value from variables where name = 'yn';"):
            bin_multiplier = row['value']
        for row in cut_bins_db.query("select value from variables where name = 'Ymin';"):
            start = row['value']
        for row in cut_bins_db.query("select value from variables where name = 'Ymax';"):
            stop = row['value']                        
        db_table = output_db["Y"]
        db_var_table = output_db["Y_variables"]
        db_offset_table = output_db["Y_offsets"]        
    if axis == "Z":
        sortaxis = 2
        for row in cut_bins_db.query("select value from variables where name = 'zn';"):
            bin_multiplier = row['value']
        for row in cut_bins_db.query("select value from variables where name = 'Zmin';"):
            start = row['value']            
        for row in cut_bins_db.query("select value from variables where name = 'Zmax';"):
            stop = row['value']                                    
        db_table = output_db["Z"]
        db_var_table = output_db["Z_variables"]
        db_offset_table = output_db["Z_offsets"]                
# Now, that we have the bin multiplier, read in the csv file of the offsets if it exists
    offset_dictionary = {}
    if offsetfile != "":
        with open(offsetfile, 'r') as csvfile:
            offsetreader = csv.reader(csvfile)
            for row in offsetreader:
                index = int(round(float(row[0])/bin_multiplier))
                offset_dictionary[index] = float(row[1])

    for i in range(int(start),int(stop)+1,interval):
        indices.append(i)
    for index in indices:
         print("Processing ",index," started at:",datetime.now())
         print("Getting limited faces")
         if sortaxis == 0:
             query = "select triangle_index from X where slice_index = " + str(index) + ";"
         if sortaxis == 1:
             query = "select triangle_index from Y where slice_index = " + str(index) + ";"
         if sortaxis == 2:
             query = "select triangle_index from Z where slice_index = " + str(index) + ";"             
             
         limited_faces = limit_faces(index,verts,faces,cut_bins_db,query)
         print("Limited Faces Obtained")
         print("Calculating Mesh")
         mesh = meshcut.TriangleMesh(verts, limited_faces)
         print("Mesh Calculated")
         slice_value = index/bin_multiplier
         if index in offset_dictionary.keys():
             slice_offset = offset_dictionary[index]
         else:
             slice_offset = 0
         if sortaxis == 0:
             plane_orig = (slice_value + slice_offset , 0, 0)
             plane_norm = (1, 0, 0)
         if sortaxis == 1:
             plane_orig = (0, slice_value + slice_offset, 0)
             plane_norm = (0, 1, 0)
         if sortaxis == 2:
             plane_orig = (0, 0, slice_value + slice_offset)
             plane_norm = (0, 0, 1)
         plane = meshcut.Plane(plane_orig, plane_norm)
         print("Determining Intersections")
         xcoords,ycoords,zcoords,intersections = get_all_intersections(mesh,plane,index/bin_multiplier)
         print("Output Intersections")
         db_table.insert_all(intersections)
         db_offset_table.insert({"slice_value":slice_value,
                                 "slice_offset":slice_offset})
         print("Intersections Output")
         # Keep track of the global min amd max of the coordinates
         xc = xcoords.copy()
         yc = ycoords.copy()
         zc = zcoords.copy()
         xc.append(x_min)
         yc.append(y_min)
         zc.append(z_min)
         x_min = min(xc)
         y_min = min(yc)
         z_min = min(zc)
         xc = xcoords.copy()
         yc = ycoords.copy()
         zc = zcoords.copy()
         xc.append(x_max)
         yc.append(y_max)
         zc.append(z_max)
         x_max = max(xc)
         y_max = max(yc)
         z_max = max(zc)         
    db_var_table.insert({"name": "x_min",
                         "value": x_min,})
    db_var_table.insert({"name": "x_max",
                         "value": x_max,})
    db_var_table.insert({"name": "y_min",
                         "value": y_min,})
    db_var_table.insert({"name": "y_max",
                         "value": y_max,})
    db_var_table.insert({"name": "z_min",
                         "value": z_min,})
    db_var_table.insert({"name": "z_max",
                         "value": z_max,})        
#         if index >= 0:
#             filename = "intersections."+filelabel+"p"+str(index)+".p"
#         else:
#             filename = "intersections."+filelabel+"m"+str(index)+".p"
#         print("Dumping File")
#         pickle.dump(intersections,open(filename,"wb"))
#         print("File Dumped")

if __name__ == '__main__':
    perform_mesh()
