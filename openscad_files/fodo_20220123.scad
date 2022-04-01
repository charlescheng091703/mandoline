
delta = 0.05;

module define_bounding_box(x_min,x_max,y_min,y_max,z_min,z_max) {

xsize = x_max - x_min;
ysize = y_max - y_min;
zsize = z_max - z_min;

translate([xsize/2+x_min,ysize/2+y_min,zsize/2+z_min]) cube([xsize,ysize,zsize],center=true);
}


module bounding_shape() {

top_box_min_z = 18;
top_box_max_z = 4525;
top_box_min_x = -125;
top_box_max_x = 125;
top_box_min_y = -100;
top_box_max_y = 100;

bottom_box_min_z = 9;
bottom_box_max_z = 4699;
bottom_box_min_x = -700;
bottom_box_max_x = -124;
bottom_box_min_y = -100;
bottom_box_max_y = 100;

define_bounding_box(top_box_min_x,top_box_max_x,top_box_min_y,top_box_max_y,top_box_min_z,top_box_max_z);
define_bounding_box(bottom_box_min_x,bottom_box_max_x,bottom_box_min_y,bottom_box_max_y,bottom_box_min_z,bottom_box_max_z);

}

model_min_z = 6.05;
model_max_z = 5807;
lengthofbox = model_max_z - model_min_z - delta;


/* Create a bounding_shape to simulate the "air" side of the vacuum system.
    Translate the cube 1/2 the distance along Y to see the impression of the chamber
    in the box */
out_box_size = 200;
Y_offset = 0 ;  // Set to 0 or out_box_size/2 to "see" the chamber.

// module_translation_distance = 0;
module_translation_distance = 450*25.4;


translate([0,0,module_translation_distance]) difference() {
    translate([0, Y_offset,0]) bounding_shape() ;
    // Now subtract the vacuum chamber
    vacuum_chamber();
};


// vacuum_chamber();

/* dlmb_chamber is a bent section with
   a leading in round vacuum section */

module vacuum_chamber () {
    fodo_top_chamber();
    fodo_bottom_chamber();
};

module fodo_top_chamber () {
    resolution = 60;
    translate([29-58/2,0,17.860149383544922+(1847.6592407226562-3)/2]) rotate([0,0,0]) cube([58,20,1847.6592407226562-3],center=true);
    translate([0,0,1866.4705810546875-3.95117188-0.02]) rotate([0,0,0]) cylinder(h= 87.8597412109375+3.95117188+0.02, r=85.5979995727539/2,  $fn=resolution);
    translate([0,0,1954.330322265625-0.02]) rotate([0,0,0]) cylinder(h=2571.3996582 , r=96.6758804321289/2+0.4-0.045,  $fn=resolution);
};

use <path_extrude.scad>;
module fodo_bottom_chamber () {
    resolution = 30;
    radius = 11+0.0625;
    offset = -radius;
    myPoints = [ for(t = [0:12:359]) [radius*cos(t),radius*sin(t)] ];
    myPath = [
    [-203.9278106689453+offset,0,8.59637451171875], 
    [-204.0243682861328+offset,0,10.793914794921875], 
    [-204.68704223632812+offset,0,24.077600479125977], 
    [-206.02178955078125+offset,0,51.295318603515625], 
    [-206.47486877441406+offset,0,60.533512115478516], 
    [-207.15112054479624+offset,0,73.8187093042118], 
    [-207.28097534179688+offset,0,76.01319122314453], 
    [-207.35411071777344+offset,0,78.46265411376953], 
    [-207.91494750976562+offset,0,89.89838409423828], 
    [-209.8102569580078+offset,0,128.54641723632812], 
    [-212.6742706298828+offset,0,185.9545440673828], 
    [-215.63528442382812+offset,0,243.35877990722656], 
    [-218.69332885742188+offset,0,300.7575988769531], 
    [-221.8483428955078+offset,0,358.1510009765625], 
    [-225.10037231445312+offset,0,415.5389709472656], 
    [-226.49850463867188+offset,0,439.6979675292969], 
    [-228.44940185546875+offset,0,472.9215087890625], 
    [-230.17893981933594+offset,0,501.9212951660156], 
    [-231.8953857421875+offset,0,530.2978515625], 
    [-233.97340393066406+offset,0,564.138427734375], 
    [-235.43833923339844+offset,0,587.6687622070312], 
    [-237.88189697265625+offset,0,626.3477783203125], 
    [-239.07826232910156+offset,0,645.0335083007812], 
    [-241.90438842773438+offset,0,688.5502319335938], 
    [-246.0408935546875+offset,0,750.7456665039062], 
    [-250.29135131835938+offset,0,812.9325561523438], 
    [-254.60720825195312+offset,0,874.4287719726562], 
    [-255.71536796536796+offset,0,890.3971774193549], 
    [-257.474025974026+offset,0,914.9112903225807], 
    [-257.7402597402598+offset,0,919.445564516129], 
    [-258.0892857142857+offset,0,924.4153225806452], 
    [-318.01739501953125+offset,0,1766.3790283203125]
    ];
    translate([0.003+0.07,0,-0.475-0.006]) path_extrude(exShape=myPoints, exPath=myPath);
    translate([-329+0.00912013,0,1764+1.61289929]) rotate([0,-4.0663467747715805,0]) cylinder(h=  29.085720910824687,  r1=radius-0.04, r2=15.9/2,  $fn=resolution);
    translate([-331-0.05340576,0,1797-2.37463379]) rotate([0,-4.0663467747715805,0]) cylinder(h= 18.112882436788126-0.2,  r1=15.9/2, r2=radius-0.04,  $fn=resolution);
    myPath2 = [
    [-321.56915283203125+offset,0,1813.2576904296875], 
    [-330.94301288798255+offset,0,1950.0468172823337], 
    [-339.1169738769531+offset,0,2064.855224609375], 
    [-347.7167663574219+offset,0,2182.756591796875], 
    [-356.6648864746094+offset,0,2300.631591796875], 
    [-365.96124267578125+offset,0,2418.478759765625], 
    [-380.10321044921875+offset,0,2589.827880859375], 
    [-396.24675324675326+offset,0,2777.6935483870966], 
    [-411.5633116883117+offset,0,2954.4677419354834], 
    [-426.5795454545455+offset,0,3129.032258064516], 
    [-439.19318181818187+offset,0,3274.870967741935], 
    [-454.20941558441564+offset,0,3449.4354838709673], 
    [-466.2911071777344+offset,0,3588.34375],
    [-466.7171325683594+offset,0,3593.8271484375]
    ];
    translate([0.32659912-0.18-0.04,0,-0.73510742-0.07]) path_extrude(exShape=myPoints, exPath=myPath2);
    translate([-477-0.75+0.09,0,3593-0.07]) rotate([0,-4.7556688713651205-0.27,0]) cylinder(h=  29.085720910824687+0.2,  r1=21.95342007742888/2, r2=15.899984010400516/2,  $fn=resolution);
    translate([-477-0.75+0.09-5.53271484+3.04800415-0.015,0,3593-0.07+28.62915039+0.2]) rotate([0,-4.7556688713651205-0.27,0]) cylinder(h= 18.112882436788126-0.2,  r1=15.899984010400516/2, r2=21.999969707357753/2,  $fn=resolution);
    radius2 = 11+0.0625+0.45;
    offset2 = -radius2;
    myPath3 = [
    [-470.7712097167969+offset2,0,3640.56689453125], 
    [-472.34796142578125+offset2,0,3658.3984375], 
    [-475.3739318847656+offset2,0,3694.771240234375], 
    [-477.9617614746094+offset2,0,3724.092041015625], 
    [-483.8636363636364+offset2,0,3792.322580645162], 
    [-488.97727272727275+offset2,0,3851.314516129033], 
    [-494.40259740259734+offset2,0,3913.314516129032], 
    [-500.93398268398266+offset2,0,3987.209677419355], 
    [-506.88906926406924+offset2,0,4052.411290322581], 
    [-512.4599567099567+offset2,0,4111.403225806452], 
    [-515.549560546875+offset2,0,4143.28173828125], 
    [-521.6477661132812+offset2,0,4206.537109375],
    [-558.8162231445312+offset2+radius2*2-0.83,0,4357.6826171875], 
    [-576.0560302734375+offset2+radius2*2-0.83,0,4522.82470703125], 
    [-588.1893441206946+offset2+radius2*2-0.83,0,4634.495174905166], 
    [-595.0691223191285+offset2+radius2*2-0.83,0,4698.93017578125],
    [-595.0691223191285+offset2+radius2*2-0.21445966-0.83,0,4698.93017578125+2.19058172]
    ];
    translate([0.12399292+0.45,0,-0.98291016-0.03]) path_extrude(exShape=myPoints, exPath=myPath3);
    translate([-558+35.88267063-1.7,0,4167+39.7864204]) rotate([-90,-5.913128280229397,0]) wedge(35,428,0,6);
    radius3 = 3; 
    offset3 = -radius3;
    myPoints2 = [ for(t = [0:12:359]) [radius3*cos(t),radius3*sin(t)] ];
    myPath4 = [
    [-521.6322021484375+offset3,0,4206.54931640625], 
    [-522.3229370117188+offset3,0,4248.41357421875], 
    [-523.045654296875+offset3,0,4290.29443359375], 
    [-524.6436767578125+offset3,0,4374.06494140625], 
    [-525.9870129870129+offset3,0,4436.201612903226], 
    [-527.2857142857142+offset3,0,4492.310483870968], 
    [-528.7467532467532+offset3,0,4553.520161290323], 
    [-530.2097778320312+offset3,0,4609.349609375], 
    [-530.9084630045015+offset3,0,4635.4604587492695]
    ];
    translate([0,0,0]) path_extrude(exShape=myPoints2, exPath=myPath4);
    translate([-554,0,4669]) rotate([0,-6.192258414238989,0]) cube([33,6,70], center=true);
    myPath5 = [
    [-530.875+offset3,0,4634.508064516129],
    [-530.9084630045015+offset3,0,4635.4604587492695], 
    [-531.2257692018383+offset3,0,4638.484374977733], 
    [-531.727294921875+offset3,0,4642.68408203125], 
    [-532.8416137695312+offset3,0,4653.37646484375], 
    [-536.7787475585938+offset3,0,4689.6640625], 
    [-537.9837036132812+offset3,0,4700.345703125], 
    [-538.3946518786056+offset3,0,4704.556137572518]
    ];
    translate([0,0,0]) path_extrude(exShape=myPoints2, exPath=myPath5);
};

module fodo_crotch_absorber () {
    difference() {
        translate([-1414.2-4.3,0,4568.8-1.7]) rotate([0,80.99989888241113,0]) cube([72.00157774979853-2.9,13,206.9231949816403+10], center=true);
        translate([-1518+35.9675293,0,4535-12.88232422-0.1]) rotate([-90,80.99989888241113+180,0]) wedge(34.4,38.674472008789394,0,13);
        translate([-1523-0.66906738,0,4580+5.38183594+0.05]) rotate([90,80.99989888241113,0]) wedge(12.73+0.1*12.73/7.447419965071629,7.447419965071629+0.1,0,13);
        translate([-1520+5.71362305,0,4555-12.17333984]) rotate([-90,80.99989888241113+180,0]) wedge(56,18.5,0,13);
    }
};

/********************************************************************/
/*
module dlmb_chamber () {
    // Round beam pipe to get up to the bent chamber
    translate([0,0, 6.0])  cylinder(h=  72,  r=31.0,    $fn=60);
    translate([0,0, 77.8]) cylinder(h=   4,  r=11.4,    $fn=60);
    translate([0,0, 80.5]) cylinder(h= 413,  r=10.9676, $fn=60);
    translate([0,0,493.5]) cylinder(h= 492,  r1=10.9676, r2 = 10.0, $fn=60);
    translate([0,0,985.5]) cylinder(h=  59,  r=11.1,    $fn=60);
    // Below is the curved chamber section.
    difference () {
        translate([10.897,0,1044]) rotate([0,0,90]) scale([25.4,25.4,25.4]) curved_chamber_description();
        translate([61+25,0,3275+50])cube([50,2000,100],center=true);
    }
};
*/

module wedge(xdim,ydim,box,zlength) {
    // Creates a triangular wedge of sides xdim and ydim extruded zlength
    // box adds a box on the end of the wedge.
    translate([0,-ydim,-zlength/2]) linear_extrude(height=zlength) polygon(points=[[0,0],[xdim,0],[0,ydim],[-box,ydim],[-box,0]]);
};

module z_boundary_plane (x_angle,y_angle,z_displacement) {
    boxsize = 200;
    translate([0,0,z_displacement])
    rotate([x_angle,y_angle,0])
    translate([0,0,-boxsize/2])
    cube([boxsize,boxsize,boxsize],center=true);
};

/* This is a constant cross section section
   Transition section to split between chambers */
module pre_crotch_absorber () {
    Zend = 4065;
    Zstart = 3299;
    ZLength = Zend-Zstart;
    y_axis_rotation = ((41.3-62.69)/(4050-3299))*180.0/PI;
    translate([-41.33,0,Zstart]) rotate([0,y_axis_rotation,0]) split_transition_section(ZLength);

    /* Now, there is an odd rectangular cutout at 4063 and 4064, so lets make sure that
       is covered */
    x_cutout_1_start = -52.03;
    x_cutout_1_stop = -44.59;
    x_coord_1 = (x_cutout_1_start + x_cutout_1_stop)/2;
    x_length_1 = x_cutout_1_stop - x_cutout_1_start;
    x_height_1 = 30;
    translate([x_coord_1,0,4063.5]) cube([x_length_1,x_height_1,1],center=true);

    x_cutout_2_start = -53.16;
    x_cutout_2_stop = -8.83;
    x_coord_2 = (x_cutout_1_start + x_cutout_1_stop)/2;
    x_length_2 = x_cutout_2_stop - x_cutout_2_start;
    x_height_2 = 32;;
    translate([x_coord_2,0,4064.5]) cube([x_length_2,x_height_2,1],center=true);
};

/* This is the upper half of the spit section after the
   crotch absorber */
module chamber_upper () {
    Z_box_end = 4920;
    Z_box_start = 4138;
    Z_box_length = Z_box_end-Z_box_start;

    translate([0,0,Z_box_start+Z_box_length/2]) cube([36.4,12,Z_box_length],center=true);

    Z_pipe_1_end = 5739.0;
    Z_pipe_1_start = Z_box_end - 0.1;
    Z_pipe_1_length = Z_pipe_1_end - Z_pipe_1_start;
    translate([0,0,Z_pipe_1_start]) cylinder(h = Z_pipe_1_length, r=22,$fn=60);

    Z_pipe_2_end = 5822.0;
    Z_pipe_2_start = Z_pipe_1_end - 0.1;
    Z_pipe_2_length = Z_pipe_2_end - Z_pipe_2_start;
    translate([0,0,Z_pipe_2_start]) cylinder(h = Z_pipe_2_length, r=25,$fn=60);
};

module crotch_absorber () {
    Z_end = 4137;
    Z_start = 4064-0.1;
    x_box_edge = 23.17;

    difference () {
        crotch_absorber_volume(x_box_edge,Z_start,Z_end);
        translate([x_box_edge,0,Z_start+1]) rotate([90,180,0]) wedge((23-16.1),(Z_end-Z_start)+2,20,50);
        translate([-33.325,5.2,Z_start]) crotch_absorber_piece();
    }
};

module crotch_absorber_piece () {
    overlap = 35;
    rotation_angle = -(10/72)*180/PI;
    rotate([92.5+0.48,180,90]) 
    difference() {
        wedge(9,(4133-4062),5,(54.09-12.56+overlap));
        translate([0,0,14.21]) z_boundary_plane(rotation_angle-180,0.0,0.0);
        // Line below is for the most inboard edge.
        translate([0,0,-27]) z_boundary_plane(rotation_angle,0.0,0.0);
        translate([0,0,-19]) z_boundary_plane(0.0,0.0,0.0);
        /*translate([0,-72,24.21]) rotate([180,90,0]) wedge(10,72,70,30);
        translate([0,-72,-24.21]) rotate([180,-90.0]) wedge(10,72,70,30);
        translate([0,0,-27]) rotate([180,270,180]) wedge(10,72,50,30);*/
    };
};

module crotch_absorber_volume (x_box_edge,Z_pipe_1_start,Z_pipe_1_end) {
    //Z_pipe_1_end = 4137;
    //Z_pipe_1_start = 4064 - 0.1;
    Z_pipe_1_length = Z_pipe_1_end - Z_pipe_1_start;
    y_axis_rotation = ((-64.5+62.5)/Z_pipe_1_length)*180.0/PI;
    translate([-62.5,0,Z_pipe_1_start]) rotate([0,y_axis_rotation,0]) cylinder(h = Z_pipe_1_length, r=11,$fn=60);

    x_box_start = -53.2;
    x_box_end = x_box_edge;
    x_overshoot = 10;
    x_box_length = x_box_end - x_box_start + x_overshoot;;
    x_box_coord = (x_box_start + x_box_end)/2;
    translate([x_box_end-x_box_length/2,0,Z_pipe_1_start+Z_pipe_1_length/2+1]) rotate([0,y_axis_rotation,0]) cube([x_box_length,11,Z_pipe_1_length+1],center=true);
};

/* This is the lower half of the split section after the
   crotch absorber */
module chamber_lower() {
    Z_pipe_1_end = 5808.0;
    Z_pipe_1_start = 4137 - 0.1;
    Z_pipe_1_length = Z_pipe_1_end - Z_pipe_1_start;
    y_axis_rotation = ((-109.57+64.8)/Z_pipe_1_length)*180.0/PI;
    translate([-64.8,0,Z_pipe_1_start]) rotate([0,y_axis_rotation,0]) cylinder(h = Z_pipe_1_length, r=11,$fn=60);
};

module split_transition_section (ZLength) {
    /* This is a section composed of of a cylinder
       and two rectangular sections */
    BoxWidth = 38.1+15.6;

    cylinder(h=ZLength,r=11);
    translate([30,0,ZLength/2]) cube([60,4.34,ZLength],center=true);
    translate([41.3-15.6+BoxWidth/2,0,ZLength/2]) cube([BoxWidth,11,ZLength],center=true);
}

module curved_chamber_description () {
    chamber_segment( 0.429 , 151 ,2, 0.429 , 0.429 , 151);
};

module chamber_segment(y,z,h,dy1,dy2,zoffset) {
    extrude_height = 1.1*h;
    translate([0,y,z-zoffset]) translate([0,0,extrude_height/2]) rotate([(180/PI)*(dy1-dy2)/h,0,0]) translate([0,0,-extrude_height/2])linear_extrude(extrude_height) dlmb_bend_chamber_crosssection();
};

module fodo_bend_chamber_crosssection () {
    circle(r=11);
}

