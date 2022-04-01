#!/usr/bin/env python

import pickle
import numpy as np
import click
import scipy.spatial.distance as spdist
import math

import sqlite3
from sqlite_utils import Database
from shapely.geometry import Polygon, Point, MultiPoint




def is_close(pt1,pt2,tol=1.0e-12):
    dist = (pt1 - pt2)**2
    dist = np.sum(dist, axis=0)
    dist = np.sqrt(dist)
    if dist <= tol:
        is_close = True
    else:
        dist=False
    
@click.command()
@click.option("--sdds/--nosdds",default=False)
@click.option("--interior/--no-interior",default=True)
@click.option("--exterior/--no-exterior",default=True)
@click.argument("filename")
@click.argument("minlevel")
@click.argument("maxlevel")


def generate_polygons(filename,minlevel,maxlevel,sdds,interior,exterior):
    intersection_db = Database(sqlite3.connect(filename))
    level_set = set()
    for level_value in intersection_db.query("select plane_origin from Y order by plane_origin asc"):
        level_set.add(level_value['plane_origin'])
    for level in level_set:
        if level <= float(maxlevel) and level >= float(minlevel): 
            polygons = generate_polygon(intersection_db,level)
# Now, generate the 2D poygons
            shapely_polygon_list = []
            shapely_multipoint_list = []
            polygon_list = []
            for gon in polygons:
                point_list = []
                for pt in gon:
                    x_coord = float(pt[0])
                    y_coord = float(pt[2])
                    point_list.append([x_coord,y_coord])
                if len(point_list) >= 3:
                    polygon_list.append(point_list)
                    shapely_polygon_list.append(Polygon(point_list))
                    shapely_multipoint_list.append(MultiPoint(point_list))

            inside_polygon_test = []

            for shapely_multipoint in shapely_multipoint_list:
                polygon_inside = False
                for shapely_polygon in shapely_polygon_list:
                    polygon_inside = polygon_inside or shapely_polygon.contains(shapely_multipoint)
                inside_polygon_test.append(polygon_inside)

            for listnum,gon in enumerate(polygon_list):
                if (inside_polygon_test[listnum] and interior) or (not inside_polygon_test[listnum] and exterior):
                    if sdds:
                        if inside_polygon_test[listnum]:
                            print("1")
                        else:
                            print("0")
                        print(len(gon))
                    for pt in gon:
                        print(pt[0],level,pt[1])
                    if not sdds:
                        print(" ")
            

def generate_polygon(intersection_db,level):
    """ Determine the set of polygons represented by the unordered set of line segments that are the
        result of intersections between triangles and infinite planes.  Each polyline is determined
        to be a series of points where the line segments are followed in sequence.   The list of
        unordered line segments might express multiple polylines """

# Now, lets read in the data for the corresponding level
    intersections = []
    intersections_mirrored = set()
# Read in the data and ensure that only one line segment is represented.   If a
# segment goes from point A to point B and another from Point B to Point A,  only include
# one of the segments.
    for r in intersection_db.query("select * from Y where plane_origin = "+str(level) ):
        # Lists are unhashable, so calculate some number that can be hashed.
        point_1 = r['x1']*1000000+r['y1']*10000+r['z1']
        point_2 = r['x2']*1000000+r['y2']*10000+r['z2']
        current_mirror_length = len(intersections_mirrored)
        intersections_mirrored.add(point_1*1000+point_2)
        intersections_mirrored.add(point_2*1000+point_1)
        if len(intersections_mirrored) > current_mirror_length:
            intersections.append([np.array([r['x1'],r['y1'],r['z1']]),
                                  np.array([r['x2'],r['y2'],r['z2']])])

    polygons = []
    all_points = []
    for inum,intersection in enumerate(intersections):
        all_points.append(intersection[0])
        all_points.append(intersection[1])

        
# all_points represents the list of all points in the data set
# We will take points off of the list as we allocate them to
# different Polygons.  We are done when there are no more points
# in the list.

    while len(all_points) > 0:
        current_polygon = []
        starting_point_in_polygon = all_points.pop(0)
        current_test_point = all_points.pop(0)
        distance_to_starting_point = 1e10
        min_distance_to_starting_point = 1e10        
# Signal the end of the polygon when the distance between the "current point"
# and the starting point is the minimum in the file
        minimum_distance = 10e6;
        for i,pt in enumerate(all_points):
            dist = (pt - starting_point_in_polygon)**2
            dist = np.sum(dist,axis=0)
            dist = np.sqrt(dist)
            if dist < minimum_distance:
                minimum_distance = dist
                final_point = pt
                final_i = i
# DEBUG
#        print("> Polygon Start")
#        print("> Starting point (popped):",starting_point_in_polygon)
#        print("> Starting test point (popped) :",current_test_point)
#        print("> Final point i ands:",final_i,final_point)
#        if final_i % 2 == 1:
#            print("> Final Companion Point:",all_points[final_i-1])
#        else:
#            print("> Final Companion Point:",all_points[final_i+1])
        current_polygon.append(starting_point_in_polygon)
        current_polygon.append(current_test_point)
        try:
            while np.array_equal(final_point,current_test_point) == False:
# Find the second occurance of the current_test_point in the table
#DEBUG
#            print(" ")
#            print("Current Test Point:", current_test_point ," compared to Final Point:",final_point)
                minimum_distance = 10e6;
                new_point_index = -1
                for i,pt in enumerate(all_points):
#               if np.array_equal(final_point,pt):
#                   print("Array Check: Final Point at:",i)
                   dist = (pt - current_test_point)**2
                   dist = np.sum(dist,axis=0)
                   dist = np.sqrt(dist)
                   if dist < minimum_distance:
                      minimum_distance = dist
                      new_point_index = i
                      new_point = pt
# Select the companion point as the new current test point. How we do this
# depends on if the new_point_index is even or odd. Throw away the current
# test point and replace it with the companion point.  Remove both
# points from all_points.
#DEBUG
#            print(">>>>>>> pt = Test Point Found:",new_point,current_test_point,
#                  "New_Point_Index:",new_point_index,
#                  "Minimum Distance ",minimum_distance)
                if new_point_index % 2 == 1:
#DEBUG
#               print("Odd:",i," ",new_point_index," ",len(all_points))
                   companion_point = all_points.pop(new_point_index-1);
                   all_points.pop(new_point_index-1)
                else:
#DEBUG
#               print("Even:",i," ",new_point_index," ",len(all_points))             
                   companion_point = all_points.pop(new_point_index+1);
                   all_points.pop(new_point_index)
#DEBUG
#            print("current / companion point :",current_test_point,companion_point)
                current_polygon.append(companion_point)
                current_test_point = companion_point
#DEBUG
#        print("new polygon")
        except:
            pass
        polygons.append(current_polygon)
    return polygons


if __name__ == "__main__":
    generate_polygons()
