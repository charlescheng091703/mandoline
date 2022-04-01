# mandoline
Scripts to support creating geometry files for Elegant.

Three scripts are used to generate the files.
1) prepareMeshCut.py - reads the input stl file and outputs numpy
                    files for the faces and vertices
2) prepare_tris.py - Prepares an sqlite file which prebins the triangles
                     into various "slices" in X, Y and Z.  So, for each of the
		     X,Y,Z directions, if a plane cuts the triangle, it is grouped
		     together.
		     
                     This way when cutMesh.py calculates the lines where
		     the triangle intersects the plane, it does not need to
		     consider irrelevant triangles.  - This also prints
		     out the X,Y,Z extents of the data.

                     This essentially cuts up the volume into X,Y,Z slices
		     that we will do further calculations on.

                     The command line parameters allow different slicing in
		     difference directions.

		     Program includes the triangles into one more layer to provide
		     coverage if the offset value of cutMesh.py is used.  As long
		     as the offset is small, all triangles will be covered.

		     Creates an <stlfile>.db file


3) cutMesh.py --axis <AXIS> --interval <INTERVAL> --offsetfile <OFFSETFILE> <FILEPREFIX>
                     This performs the actual slicing and outputs an sqlite3
		     file that contains the line segments of all of the
		     intersections.  See the help text by runnig
		     ./cutMesh.py --help

                     Interval is a little counterintuitive.   If the STL is in mm, then
		     an Interval of 10 will create 0.1 mm slices.   If it is 0.1, then it
		     will create 10 mm slices.   If it is 1, then it will create 1 mm slices.
 

                     One feature of this routine is the offserfile.  As the intent of this
		     entire analysis is to create closed polygons, slices that include singularities
		     or whole planes are difficult to manage.  The offset file allows you to
		     offset particular slice values by (hopefully) small amounts to avoid
		     these issues in downstream applications.

		     This is just a csv file with lines of
		     <slice value>,<offset value>

		     e.g.
		     11,0.001
		     -11,-0.001

		     The above will shift layers 11 and -11 by about a micron for a file that is in mm.

                     Creates an <stlfile>_intersectons,db file


4) X_explore_slices.ipynb - jupyter lab script to example the intersections file in the X plane.
   Y_explore_slices.ipynb - jupyter lab script to examine the intersections file in the Y plane.
   Z_explore_slices.ipynb - jupyter lab script to example the intersections file in the Z plane.


5) scad2db - Script that uses the command line version of OpenScad on Mac to generate the STL files.

6) getPolygons.py - Reads in the intersections file and attempts to stitch together all of the triangle
                    intersections from the slicing into various polygons for elegant.   The program
		    will print out an ascii file that can be used with the SDDS routine
		    plaindata2sdds using the following command:

		    plaindata2sdds dlma.input dlma.sdds -parameter=interior
		        -input=ascii -col=x,double -col=y,double -col=z,double
		    
                    The normal ascii format prints out the polylines separated by a space
		    so they can be plotted in gnuplot.   The sdds option prints out an
		    ascii file which has for each polygon
		    <Interior or Exterior 0 or 1>
		    # points in Polygon
		    x1,y1,z1
		    x2,y2,z2
		    etc...

   The routine uses Shapley to determine if a polygon is completely enclosed by another.   If it is, then
   the <Interior or Exterior> line is 1 otherwise it is 0.  Options for --interior and --exterior are used
   to just print out interior or exterior polygons.


## Conda

It is best to set up a separate conda environment to run
these scripts.

- conda create --name mandoline python=3.9
- conda activate mandoline
- conda install jupyter
- conda install jupyterlab
- conda install numpy
- conda install scipy
- conda install matplotlib
- conda install ipympl
- conda install shapely
- conda install rich
- pip install numpy-stl
- pip install sqlite-utils