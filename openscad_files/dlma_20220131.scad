
delta = 0.05;
model_min_z = 6.05;
model_max_z = 5807;

lengthofbox = model_max_z - model_min_z - delta;

// Note:  In the original modeling, we translated the model -110 inches
// along Z, so we need to translate it back in order to fit the
// modeling for Michael

model_translation_distance = 110*25.4;
// model_translation_distance = 0;

// vacuum_chamber();
translate([0,0,model_translation_distance]) render_negative();

module render_negative () {

// Create a Cube to simulate the "air" side of the vacuum system.
// Translate the cube 1/2 the distance along Y to see the impression of the chamber
// in the box
out_box_size = 350;
Y_offset = 0 ;  // Set to 0 or out_box_size/2 to "see" the chamber.
// Y_offset = out_box_size/2 ;  // Set to 0 or out_box_size/2 to "see" the chamber.
difference() {
translate([0, Y_offset,lengthofbox/2 + model_min_z]) cube([out_box_size,out_box_size,lengthofbox],center=true);
// Now subtract the vacuum chamber
vacuum_chamber();
};

};


// dlma_chamber is a bent section with
// a leading in round vacuum section


module vacuum_chamber () {
dlma_chamber();
pre_crotch_absorber();
crotch_absorber();
chamber_upper();
chamber_lower();
}


//**********************************************************************************************
/*
Generic routine that extrudes the child shape and then
rotates and translates the shape so that the origin of the
polygon is at P0(x0,y0,z0) and it points along the line from
P0 to P1(x1,y1,z1)

Note: Since we are extruding along the Z axis, we will only
rotate with the X and Y angles.  This is good enough for to
deetermine the vacuum cross section

*/
module place_polygon(x0,y0,z0,x1,y1,z1,rotation_fraction,extrusion_fraction) {
linedistance = sqrt((z1-z0)^2 + (y1-y0)^2 + (x1-x0)^2);
extrudelength = extrusion_fraction*linedistance;
rotationoffset = rotation_fraction * extrudelength;
x_rot = asin((x1-x0)/extrudelength);
y_rot = asin((y1-y0)/extrudelength);
z_rot = asin((z1-z0)/extrudelength);
translate([x0,y0,z0+rotationoffset]) rotate([y_rot,x_rot,0]) translate([0,0,-rotationoffset])linear_extrude(height=extrudelength) children(0);
};




/*
Generic Routine for extruding a round pipe and placing it at the end points
determined from the jupyter lab cross sections
*/

module place_round_pipe(pipeUSface_x_1,pipeUSface_x_2,pipeUS_z,pipeDSface_x_1,pipeDSface_x_2,pipeDS_z) {

pipeUSface_x = (pipeUSface_x_1 + pipeUSface_x_2) / 2;
pipe_diameter = abs(pipeUSface_x_2 - pipeUSface_x_1);
pipeDSface_x = (pipeDSface_x_1  + pipeDSface_x_2) / 2;
place_polygon(pipeUSface_x,0,pipeUS_z,pipeDSface_x,0,pipeDS_z,0,1) circle(d=pipe_diameter, $fn=64);

};


//**********************************************************************************************


//****************************************
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

//****************************************
// This is a constant cross section section
// Transition section to split between chambers
module pre_crotch_absorber () {

// When attempting to execute the weird sections inthe crotch, Zend was 4065.
// Make it 4067 so it runs into the front face of the crotch by a small amount.
// Zend = 4065;
Zend = 4067;
Zstart = 3299;
ZLength = Zend-Zstart;
y_axis_rotation = ((41.3-62.69)/(4050-3299))*180.0/PI;
translate([-41.33,0,Zstart]) rotate([0,y_axis_rotation,0]) split_transition_section(ZLength);


// NOTE:  The weird shape inside the crotch is causing issues with the rendering.
// We will remove the weird section below and just extend the pre crotch absorber
// into the crotch.

// Now, there is an odd rectangular cutout at 4063 and 4064, so lets make sure that
// is covered

//x_cutout_1_start = -52.03;
//x_cutout_1_stop = -44.59;
//x_coord_1 = (x_cutout_1_start + x_cutout_1_stop)/2;
//x_length_1 = x_cutout_1_stop - x_cutout_1_start;
//x_height_1 = 30;
//translate([x_coord_1,0,4063.5]) cube([x_length_1,x_height_1,1],center=true);

//x_cutout_2_start = -53.16;
//x_cutout_2_stop = -8.83;
//x_coord_2 = (x_cutout_1_start + x_cutout_1_stop)/2;
//x_length_2 = x_cutout_2_stop - x_cutout_2_start;
//x_height_2 = 32;;
//translate([x_coord_2,0,4064.5]) cube([x_length_2,x_height_2,1],center=true);

};
//****************************************

//****************************************
// This is the upper half of the split section after the
// crotch absorber
module chamber_upper () {
Z_box_1_end = 4935;
Z_box_1_start = 4138;
Z_box_1_length = Z_box_1_end-Z_box_1_start;

translate([0,0,Z_box_1_start+Z_box_1_length/2]) cube([36.4,12,Z_box_1_length],center=true);

Z_box_2_end = 5736;
Z_box_2_start = 4138.9;
Z_box_2_length = Z_box_2_end-Z_box_2_start;

translate([0,0,Z_box_2_start+Z_box_2_length/2]) cube([44,12.5,Z_box_2_length],center=true);

Z_pipe_1_end = 5736.0;
Z_pipe_1_start = Z_box_2_end - 0.1;
Z_pipe_1_length = Z_pipe_1_end - Z_pipe_1_start;
translate([0,0,Z_pipe_1_start]) cylinder(h = Z_pipe_1_length, r=22,$fn=64);

Z_pipe_2_end = 5822.0;
Z_pipe_2_start = Z_pipe_1_end - 0.1;
Z_pipe_2_length = Z_pipe_2_end - Z_pipe_2_start;
translate([0,0,Z_pipe_2_start]) cylinder(h = Z_pipe_2_length, r=25,$fn=64);
};
//****************************************

module crotch_absorber () {
Z_end = 4137.1;
Z_start = 4064-0.5;
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
rotate([92.5+0.48,180,90]) difference() {
wedge(9,(4133-4062),5,(54.09-12.56+overlap));
translate([0,0,14.21]) z_boundary_plane(rotation_angle-180,0.0,0.0);
// Line below is for the most inboard edge.
translate([0,0,-27]) z_boundary_plane(rotation_angle,0.0,0.0);
translate([0,0,-19]) z_boundary_plane(0.0,0.0,0.0);
// translate([0,-72,24.21]) rotate([180,90,0]) wedge(10,72,70,30);
// translate([0,-72,-24.21]) rotate([180,-90.0]) wedge(10,72,70,30);
// translate([0,0,-27]) rotate([180,270,180]) wedge(10,72,50,30);
};

};


module crotch_absorber_volume (x_box_edge,Z_pipe_1_start,Z_pipe_1_end) {
//Z_pipe_1_end = 4137;
//Z_pipe_1_start = 4064 - 0.1;
Z_pipe_1_length = Z_pipe_1_end - Z_pipe_1_start;
y_axis_rotation = ((-64.5+62.5)/Z_pipe_1_length)*180.0/PI;
// # DEBUG 11 mm Cylinder
//translate([-62.5,0,Z_pipe_1_start]) rotate([0,y_axis_rotation,0]) cylinder(h = Z_pipe_1_length, r=11,$fn=64);

x_box_start = -53.2;
x_box_end = x_box_edge;
x_overshoot = 10;
x_box_length = x_box_end - x_box_start + x_overshoot;;
x_box_coord = (x_box_start + x_box_end)/2;
translate([x_box_end-x_box_length/2,0,Z_pipe_1_start+Z_pipe_1_length/2+1]) rotate([0,y_axis_rotation,0]) cube([x_box_length,11,Z_pipe_1_length+1],center=true);

};

//****************************************



//****************************************
// This is the lower half of the split section after the
// crotch absorber

module chamber_lower() {
Z_pipe_1_end = 5808.0;
Z_pipe_1_start = 4137 - 0.1;
Z_pipe_1_length = Z_pipe_1_end - Z_pipe_1_start;
y_axis_rotation = ((-109.57+64.8)/Z_pipe_1_length)*180.0/PI;
// # DEBUG 11 mm Cylinder
//translate([-64.8,0,Z_pipe_1_start]) rotate([0,y_axis_rotation,0]) cylinder(h = Z_pipe_1_length, r=11,$fn=64);


};


//****************************************

//****************************************
module dlma_chamber () {
// Round beam pipe to get up to the bent chamber
translate([0,0, 6.0])  cylinder(h=  72,  r=31.0,    $fn=64);
translate([0,0, 77.8]) cylinder(h=   4,  r=11.4,    $fn=64);
translate([0,0, 80.5]) cylinder(h= 413,  r=10.9676, $fn=64);
translate([0,0,493.5]) cylinder(h= 492,  r1=10.9676, r2 = 10.0, $fn=64);
translate([0,0,985.5]) cylinder(h=  59,  r=11.1,    $fn=64);

// This is part of the lower chamber section but we need
// to put it higher up in the chain so we can do appropriate
// differences.
place_round_pipe(-52,-30,3299,-120.51,-98.51,5808.5);

// Below is the curved chamber section.
difference () {
translate([10.897,0,1044]) rotate([0,0,90]) scale([25.4,25.4,25.4]) curved_chamber_description();
translate([61+25,0,3275+50])cube([50,2000,100],center=true);
}

};
//****************************************


module split_transition_section (ZLength) {

// This is a section composed of of a cylinder
// and two rectangular sections
BoxWidth = 38.1+15.6;
// # DEBUG 11 mm Cylinder
//cylinder(h=ZLength,r=11,$fn=64);
translate([30,0,ZLength/2]) cube([60,4.34,ZLength],center=true);
translate([41.3-15.6+BoxWidth/2,0,ZLength/2]) cube([BoxWidth,11,ZLength],center=true);

}


module curved_chamber_description () {

chamber_segment( 0.429 , 151 ,2, 0.429 , 0.429 , 151);
chamber_segment( 0.4243 , 152 ,2, 0.429 , 0.4243 , 151);
chamber_segment( 0.4299 , 154 ,2, 0.4243 , 0.4299 , 151);
chamber_segment( 0.433 , 156 ,2, 0.4299 , 0.433 , 151);
chamber_segment( 0.447 , 158 ,2, 0.433 , 0.447 , 151);
chamber_segment( 0.450 , 160 ,2, 0.447 , 0.450 , 151);
chamber_segment( 0.468 , 162 ,2, 0.450 , 0.468 , 151);
chamber_segment( 0.488 , 164 ,2, 0.468 , 0.488 , 151);
chamber_segment( 0.509 , 166 ,2, 0.488 , 0.509 , 151);
chamber_segment( 0.522 , 168 ,2, 0.509 , 0.522 , 151);
chamber_segment( 0.551 , 170 ,2, 0.522 , 0.551 , 151);
chamber_segment( 0.575 , 172 ,2, 0.551 , 0.575 , 151);
chamber_segment( 0.598 , 174 ,2, 0.575 , 0.598 , 151);
chamber_segment( 0.623 , 176 ,2, 0.598 , 0.623 , 151);
chamber_segment( 0.655 , 178 ,2, 0.623 , 0.655 , 151);
chamber_segment( 0.681 , 180 ,2, 0.655 , 0.681 , 151);
chamber_segment( 0.716 , 182 ,2, 0.681 , 0.716 , 151);
chamber_segment( 0.749 , 184 ,2, 0.716 , 0.749 , 151);
chamber_segment( 0.777 , 186 ,2, 0.749 , 0.777 , 151);
chamber_segment( 0.812 , 188 ,2, 0.777 , 0.812 , 151);
chamber_segment( 0.849 , 190 ,2, 0.812 , 0.849 , 151);
chamber_segment( 0.889 , 192 ,2, 0.849 , 0.889 , 151);
chamber_segment( 0.928 , 194 ,2, 0.889 , 0.928 , 151);
chamber_segment( 0.961 , 196 ,2, 0.928 , 0.961 , 151);
chamber_segment( 1.005 , 198 ,2, 0.961 , 1.005 , 151);
chamber_segment( 1.050 , 200 ,2, 1.005 , 1.050 , 151);
chamber_segment( 1.088 , 202 ,2, 1.050 , 1.088 , 151);
chamber_segment( 1.123 , 204 ,2, 1.088 , 1.123 , 151);
chamber_segment( 1.175 , 206 ,2, 1.123 , 1.175 , 151);
chamber_segment( 1.215 , 208 ,2, 1.175 , 1.215 , 151);
chamber_segment( 1.268 , 210 ,2, 1.215 , 1.268 , 151);
chamber_segment( 1.309 , 212 ,2, 1.268 , 1.309 , 151);
chamber_segment( 1.359 , 214 ,2, 1.309 , 1.359 , 151);
chamber_segment( 1.409 , 216 ,2, 1.359 , 1.409 , 151);
chamber_segment( 1.456 , 218 ,2, 1.409 , 1.456 , 151);
chamber_segment( 1.508 , 220 ,2, 1.456 , 1.508 , 151);
chamber_segment( 1.557 , 222 ,2, 1.508 , 1.557 , 151);
chamber_segment( 1.614 , 224 ,2, 1.557 , 1.614 , 151);
chamber_segment( 1.661 , 226 ,2, 1.614 , 1.661 , 151);
chamber_segment( 1.716 , 228 ,2, 1.661 , 1.716 , 151);
chamber_segment( 1.770 , 230 ,2, 1.716 , 1.770 , 151);
chamber_segment( 1.825 , 232 ,2, 1.770 , 1.825 , 151);
chamber_segment( 1.876 , 234 ,2, 1.825 , 1.876 , 151);
chamber_segment( 1.935 , 236 ,2, 1.876 , 1.935 , 151);
chamber_segment( 1.990 , 238 ,2, 1.935 , 1.990 , 151);

};


module chamber_segment(y,z,h,dy1,dy2,zoffset) {
 extrude_height = 1.1*h;
 translate([0,y,z-zoffset]) translate([0,0,extrude_height/2]) rotate([(180/PI)*(dy1-dy2)/h,0,0]) translate([0,0,-extrude_height/2])linear_extrude(extrude_height) dlma_bend_chamber_crosssection();
};

module dlma_bend_chamber_crosssection () {

polygon ( points = [
[ -0.8228347 , -4.5668187 ],
[ -0.8228347 , -4.5701227 ],
[ -0.8228347 , -4.5707564 ],
[ -0.8178569 , -4.6085663 ],
[ -0.8156289 , -4.625487 ],
[ -0.79479724 , -4.783718 ],
[ -0.7736944 , -4.8346653 ],
[ -0.7125957 , -4.9821706 ],
[ -0.67906004 , -5.025875 ],
[ -0.58183193 , -5.152585 ],
[ -0.53816175 , -5.1860943 ],
[ -0.41141734 , -5.2833486 ],
[ -0.36059287 , -5.304401 ],
[ -0.21296528 , -5.36555 ],
[ -0.15844148 , -5.3727283 ],
[ -8.942566e-15 , -5.3935876 ],
[ 0.054526374 , -5.3864093 ],
[ 0.21296528 , -5.36555 ],
[ 0.2637854 , -5.3445 ],
[ 0.41141734 , -5.2833486 ],
[ 0.45507985 , -5.2498455 ],
[ 0.58183193 , -5.152585 ],
[ 0.6153603 , -5.10889 ],
[ 0.7125957 , -4.9821706 ],
[ 0.73369306 , -4.9312367 ],
[ 0.79479724 , -4.783718 ],
[ 0.8020008 , -4.7290015 ],
[ 0.8228347 , -4.5707564 ],
[ 0.8228347 , -4.5675187 ],
[ 0.8228347 , -4.567452 ],
[ 0.8228347 , -4.5668187 ],
[ 0.9219439 , -4.5668187 ],
[ 0.9409449 , -4.5668187 ],
[ 0.9409449 , -4.6824627 ],
[ 0.9409449 , -4.7046146 ],
[ 0.94401026 , -4.712015 ],
[ 0.9453741 , -4.715304 ],
[ 0.9582417 , -4.7463694 ],
[ 0.96893275 , -4.7507977 ],
[ 1.0 , -4.7636666 ],
[ 1.0106901 , -4.7592382 ],
[ 1.0417583 , -4.7463694 ],
[ 1.046187 , -4.7356777 ],
[ 1.0470483 , -4.7336 ],
[ 1.0590551 , -4.704613 ],
[ 1.0590551 , -4.642349 ],
[ 1.0590551 , -4.561323 ],
[ 1.0590551 , -4.4522057 ],
[ 1.0590551 , -4.238901 ],
[ 1.0590551 , -4.1271014 ],
[ 1.0590551 , -3.9164789 ],
[ 1.0590551 , -3.7062378 ],
[ 1.0590551 , -3.5940568 ],
[ 1.0590551 , -3.578318 ],
[ 1.0590551 , -3.5761693 ],
[ 1.0590551 , -3.5628808 ],
[ 1.0546279 , -3.5521908 ],
[ 1.0417583 , -3.5211205 ],
[ 1.0310682 , -3.5166926 ],
[ 1.0 , -3.5038238 ],
[ 0.98930895 , -3.5082521 ],
[ 0.9582417 , -3.5211205 ],
[ 0.9538144 , -3.531809 ],
[ 0.9409449 , -3.562882 ],
[ 0.9409449 , -3.6761482 ],
[ 0.9409449 , -3.678382 ],
[ 0.9409449 , -3.7006767 ],
[ 0.8419399 , -3.7006767 ],
[ 0.8228347 , -3.7006767 ],
[ 0.8228347 , -3.676009 ],
[ 0.8228347 , -3.6713395 ],
[ 0.82044303 , -3.6470568 ],
[ 0.8077049 , -3.517725 ],
[ 0.80061275 , -3.4943452 ],
[ 0.76289725 , -3.370014 ],
[ 0.75136817 , -3.3484447 ],
[ 0.6901336 , -3.2338827 ],
[ 0.67459875 , -3.2149534 ],
[ 0.59221005 , -3.1145625 ],
[ 0.44028726 , -2.9626396 ],
[ 0.41172695 , -2.934083 ],
[ 0.39624363 , -2.9152129 ],
[ 0.31380346 , -2.814759 ],
[ 0.30228636 , -2.7932122 ],
[ 0.24103974 , -2.6786277 ],
[ 0.23394017 , -2.6552236 ],
[ 0.19623207 , -2.5309167 ],
[ 0.19383162 , -2.5065446 ],
[ 0.18110237 , -2.3773022 ],
[ 0.18110237 , -2.340788 ],
[ 0.18110237 , -2.1510584 ],
[ 0.18110237 , -1.8820388 ],
[ 0.18110237 , -1.8286364 ],
[ 0.18110237 , -1.5586582 ],
[ 0.18110237 , -1.5062143 ],
[ 0.18110237 , -1.2354674 ],
[ 0.18110237 , -1.1837921 ],
[ 0.18110237 , -0.9128903 ],
[ 0.18110237 , -0.86137 ],
[ 0.18110237 , -0.75999266 ],
[ 0.18110237 , -0.53894794 ],
[ 0.18110237 , -0.5260578 ],
[ 0.18110237 , -0.52497345 ],
[ 0.18110237 , -0.5038243 ],
[ 0.18599673 , -0.47240472 ],
[ 0.19043145 , -0.44393894 ],
[ 0.20465259 , -0.41549668 ],
[ 0.21753448 , -0.3897329 ],
[ 0.23973578 , -0.36696255 ],
[ 0.25984251 , -0.34634048 ],
[ 0.318068 , -0.28194648 ],
[ 0.37078494 , -0.2236446 ],
[ 0.4006267 , -0.1420985 ],
[ 0.427632 , -0.06830331 ],
[ 0.42472214 , 0.01850257 ],
[ 0.42209008 , 0.097019985 ],
[ 0.38683826 , 0.1764207 ],
[ 0.35496768 , 0.24820559 ],
[ 0.29250905 , 0.30860558 ],
[ 0.2360576 , 0.3631964 ],
[ 0.1555059 , 0.39577416 ],
[ 0.08270807 , 0.42521596 ],
[ -0.0041737705 , 0.42521596 ],
[ -0.08270807 , 0.42521596 ],
[ -0.16322964 , 0.39265043 ],
[ -0.2360576 , 0.36319643 ],
[ -0.29846948 , 0.3028416 ],
[ -0.35496768 , 0.24820559 ],
[ -0.39018026 , 0.16889325 ],
[ -0.42209008 , 0.09701999 ],
[ -0.42499566 , 0.010342754 ],
[ -0.427632 , -0.068303294 ],
[ -0.39784408 , -0.14970228 ],
[ -0.37078494 , -0.22364457 ],
[ -0.31268024 , -0.287905 ],
[ -0.25984251 , -0.34634048 ],
[ -0.23767763 , -0.36907345 ],
[ -0.21753448 , -0.38973287 ],
[ -0.20332758 , -0.4181467 ],
[ -0.19043145 , -0.44393894 ],
[ -0.18553862 , -0.4753452 ],
[ -0.1846925 , -0.48077977 ],
[ -0.18110237 , -0.5038243 ],
[ -0.18110237 , -0.6802919 ],
[ -0.18110237 , -0.7001238 ],
[ -0.18110237 , -0.7656186 ],
[ -0.18110237 , -0.8172006 ],
[ -0.18110237 , -1.0880407 ],
[ -0.18110237 , -1.3587515 ],
[ -0.18110237 , -1.4104627 ],
[ -0.18110237 , -1.4618771 ],
[ -0.18110237 , -1.7328849 ],
[ -0.18110237 , -1.7846155 ],
[ -0.18110237 , -2.055307 ],
[ -0.18110237 , -2.3258429 ],
[ -0.18110237 , -2.3773022 ],
[ -0.18350442 , -2.4016905 ],
[ -0.19623207 , -2.5309167 ],
[ -0.20333676 , -2.5543377 ],
[ -0.24103974 , -2.6786277 ],
[ -0.25256228 , -2.7001848 ],
[ -0.31380346 , -2.814759 ],
[ -0.3292948 , -2.8336353 ],
[ -0.41172695 , -2.9340792 ],
[ -0.44028726 , -2.9626396 ],
[ -0.59221005 , -3.1145625 ],
[ -0.60775286 , -3.1335015 ],
[ -0.6901336 , -3.2338827 ],
[ -0.70167094 , -3.2554677 ],
[ -0.76289725 , -3.370014 ],
[ -0.76999277 , -3.393405 ],
[ -0.8077049 , -3.517725 ],
[ -0.81009823 , -3.5420244 ],
[ -0.8228347 , -3.6713395 ],
[ -0.8228347 , -3.676009 ],
[ -0.8228347 , -3.7006767 ],
[ -0.92183965 , -3.7006767 ],
[ -0.9409449 , -3.7006767 ],
[ -0.9409449 , -3.684081 ],
[ -0.9409449 , -3.601252 ],
[ -0.9409449 , -3.5693204 ],
[ -0.9409449 , -3.562882 ],
[ -0.94402575 , -3.5554442 ],
[ -0.94537205 , -3.5521908 ],
[ -0.9582417 , -3.5211205 ],
[ -0.9689318 , -3.5166926 ],
[ -1.0 , -3.5038238 ],
[ -1.010691 , -3.5082521 ],
[ -1.0417583 , -3.5211205 ],
[ -1.0461856 , -3.531809 ],
[ -1.0470593 , -3.5339203 ],
[ -1.0590551 , -3.5628808 ],
[ -1.0590551 , -3.6806288 ],
[ -1.0590551 , -3.8391268 ],
[ -1.0590551 , -3.9511547 ],
[ -1.0590551 , -4.161549 ],
[ -1.0590551 , -4.372144 ],
[ -1.0590551 , -4.483971 ],
[ -1.0590551 , -4.5954056 ],
[ -1.0590551 , -4.610428 ],
[ -1.0590551 , -4.704613 ],
[ -1.0546259 , -4.715304 ],
[ -1.0417583 , -4.7463694 ],
[ -1.0310673 , -4.7507977 ],
[ -1.0 , -4.7636666 ],
[ -0.9893099 , -4.7592382 ],
[ -0.9582417 , -4.7463694 ],
[ -0.9538129 , -4.7356777 ],
[ -0.9409449 , -4.7046146 ],
[ -0.9409449 , -4.6237283 ],
[ -0.9409449 , -4.6047792 ],
[ -0.9409449 , -4.573127 ],
[ -0.9409449 , -4.5668187 ],
[ -0.8418357 , -4.5668187 ]]
);
}


