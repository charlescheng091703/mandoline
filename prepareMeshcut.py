#!/usr/bin/env python
"""
This demonstrates cutting on a .stl mesh, which requires some pre-processing
because STL stores 3 vertices for each face (so vertices are duplicated).

The merge_close_vertices is a naive implementation of this pre-processing
that will probably take a long time on large meshes. libigl provides
a remove_duplicates function that should be better :
  https://github.com/libigl/libigl/blob/master/include/igl/remove_duplicates.h

Thanks to @superzanti for providing the model
"""
##
import os
import numpy as np
import numpy.linalg as la
import itertools
import math
from datetime import datetime
import csv

import meshcut
import click

##


def load_stl(stl_fname,scale_factor,displacement_list,rotfile):
    import stl
    m = stl.mesh.Mesh.from_file(stl_fname, mode=stl.Mode.BINARY)
    displacement_vector = np.array(displacement_list)
    m.translate(np.array(displacement_list))
    if rotfile != "":
        with open(rotfile,"r") as rotationfile:
            csvreader = csv.reader(rotationfile)
            for row in csvreader:
                m.rotate([float(row[0]),
                          float(row[1]),
                          float(row[2])],
                          math.radians(float(row[3])))

    
    # Flatten our vert array to Nx3 and generate corresponding faces array
    verts = m.vectors.reshape(-1, 3)
    faces = np.arange(len(verts)).reshape(-1, 3)

    verts, faces = meshcut.merge_close_vertices_big(verts, faces, close_epsilon=0.0)
    scaled_verts = scale_factor * verts
    return scaled_verts, faces

##


@click.command()
@click.argument("filename")
@click.option("--s",default=1.0)
@click.option("--dx",default=0.0)
@click.option("--dy",default=0.0)
@click.option("--dz",default=0.0)
@click.option("--rotfile",default="")
def convert(filename,s,dx,dy,dz,rotfile):
    """ Converts the stl file to numpy files that contain vertices
    and a faces index,  The faces can be arbitrarily scaled with the
    s option and translated before scaling with the dx,dy, and dz options."""
    print("Start: ",datetime.now())
    scale_factor = s
    verts, faces = load_stl(filename,scale_factor,[dx,dy,dz],rotfile)
    print("STL Loading done"," ",len(verts)," ",datetime.now())
    vertname = filename + ".vert"
    facename = filename + ".face"
    np.save(vertname,verts)
    np.save(facename,faces)
    print("End: ",datetime.now())


if __name__ == '__main__':
    ##
    convert()
