use <path_extrude.scad>;

// model_translation_distance = 0;
model_translation_distance = 338*25.4;

translate([0,0,model_translation_distance]) difference() {
bounding_box();
vacuum_system();
}


module bounding_box () {
x_length = 200 - (-300);
y_length = 50 - (-50);
z_length = 2851 - 32.5;
translate([-50,0,32.5+z_length/2])cube([x_length,y_length,z_length],center=true);
}

module vacuum_system () {
section_1();
section_3();
//translate([0,0,316]) linear_extrude(height=1000) qmqa_crosssection();
//crotch_absorber();
curved_vaccum_chamber();
}

module curved_vaccum_chamber() {
    myPoints = [
    [33.0,-0.6736544677688516], 
    [32.59229674415663,12.149727026309742], 
    [31.38533812958322,16.20372620934299], 
    [30.341213923144284,18.42051300404647], 
    [27.978600353625197,21.93100892528291], 
    [26.55634880065918,23.49797034980033], 
    [26.55634880065918,23.49797034980033], 
    [10.486737287006417,39.573022079517685], 
    [6.928932189941406,43.1320308804998], 
    [4.3241199108462,47.68352322982801], 
    [4.0,60.949123582991874], 
    [4.0,105.13392564872149], 
    [5.335939116316142,108.52570858890584], 
    [7.104857948945272,109.99346290730328], 
    [9.364928681414105,112.59501146636157], 
    [10.080096825535028,113.9626619452582], 
    [10.67819852345025,115.7859017045321], 
    [10.876058627551622,120.00785571721595], 
    [9.99540676347938,122.95765269541461], 
    [9.254855024685575,124.31115356402121], 
    [6.94933270307405,126.88646570579168], 
    [4.317595877009795,128.48049233371583], 
    [2.860641421092922,128.985940225516], 
    [-0.1926337626208841,129.36424656143788], 
    [-4.317595877009795,128.48049233371583], 
    [-6.017136946853554,127.57506447107], 
    [-9.03627117497735,124.62524903202912], 
    [-10.876058627551622,120.00785571721595], 
    [-10.59687588130279,115.41692984582662], 
    [-8.68648685780843,111.64443797444864], 
    [-7.659418004899543,110.49488649884569], 
    [-6.1875,109.26930511094463], 
    [-4.016154356600405,105.33270310051596], 
    [-4.0,50.20550306887068], 
    [-5.2757493474527974,45.32498105683694], 
    [-6.928932189941406,43.1320308804998], 
    [-10.486737287006417,39.573022079517685], 
    [-26.55634880065918,23.49797034980033], 
    [-30.341221805629285,18.42050039207047], 
    [-32.086903704377995,14.204949309937316], 
    [-32.8552454219573,10.375930538624187], 
    [-33.0,6.481003825540791], 
    [-33.49918907383696,-0.6736544677688516], 
    [-36.0,-0.09029732600463924], 
    [-35.52524561980925,-22.68111053345372], 
    [-33.0,-24.039249654489897], 
    [-32.895890643015576,-33.429865291416185], 
    [-32.48888463231418,-35.93416062002107], 
    [-32.068965911865234,-37.626131362758755], 
    [-29.28399706659799,-46.89487865314369], 
    [-13.407524108886719,-99.73686537380283], 
    [-9.99070925726787,-105.51608215743603], 
    [-5.850889720743571,-108.42760521388973], 
    [-4.078238527592678,-109.09889857669424], 
    [5.6618582259799775,-108.50910391004187], 
    [9.839630490248453,-105.6584792092285], 
    [12.823933189230962,-101.32416110181846], 
    [13.407524108886719,-99.73686537380283], 
    [13.407524108886719,-99.73686537380283], 
    [32.584538961369944,-35.547797969392775], 
    [33.0,-22.68111053345372], 
    [36.0,-23.234449852525582], 
    [36.0,-0.6736544677688516]
    ];
    myPath = [
    [110.81168831168831,0,317.85483870967744], 
    [110.74175262451172,0,320.0029296875], 
    [110.11946105957031,0,344.20379638671875], 
    [109.9138412475586,0,351.2010498046875], 
    [108.12353515625,0,420.979736328125], 
    [106.26549530029297,0,490.8266296386719], 
    [104.36724853515625,0,560.6727294921875], 
    [102.40869140625,0,630.3072509765625], 
    [100.40020751953125,0,702.0277099609375], 
    [98.31700134277344,0,773.8170776367188], 
    [96.18702697753906,0,845.605712890625], 
    [94.01026916503906,0,917.392822265625], 
    [91.769775390625,0,988.8908081054688], 
    [89.86701965332031,0,1049.8839111328125], 
    [87.8968276977539,0,1110.93603515625], 
    [83.83772277832031,0,1233.0355224609375], 
    [81.74880981445312,0,1294.083740234375], 
    [77.4522476196289,0,1416.175537109375], 
    [75.23426055908203,0,1476.791259765625], 
    [72.9838638305664,0,1538.5269775390625], 
    [68.28290557861328,0,1662.11474609375], 
    [65.86054229736328,0,1723.9056396484375], 
    [61.001625061035156,0,1844.1734619140625], 
    [58.54436111450195,0,1902.9559326171875], 
    [56.03081512451172,0,1961.736083984375], 
    [50.83456076277761,0,2079.152547604311],
    [46.42884729949634,0,2175.0517578125], 
    [42.61881637573242,0,2255.5986328125], 
    [39.76491165161133,0,2313.89208984375], 
    [39.44774627685547,0,2320.884765625], 
    [38.8011360168457,0,2334.069091796875], 
    [38.261940002441406,0,2345.064697265625], 
    [38.18019480519481,0,2347.086693548387]
    ];
    difference() {
        translate([-109.9814178+1.18318473-0.7633151377884531/2,0,-3.27308056]) rotate([0,0,0]) path_extrude(exShape=myPoints, exPath=myPath);
        crotch_absorber();
    };
};

module crotch_absorber() {
    translate([105.9-4.03035927,4.875,2130-2.62573242+2.355531897940368]) rotate([0,-2.8072885197114346,0]) cube([160,35.75,93.03971194201121],center=true);
    translate([-23+3.6574955+0.03-3.68792507/4,15.238620985246364,2092+31.78613281]) rotate([0,-2.8072885197114346,0]) cube([82.71556969+3.68792507,15,93.03971194201121],center=true);
    translate([-23+3.6574955+0.03-3.68792507/4,-11,2092+31.78613281]) rotate([0,-2.8072885197114346,0]) cube([82.71556969+3.68792507,4,93.03971194201121],center=true);
    translate([-30+10.84918695+0.23+0.007,-0.6306896209716797,2130+40.46613864-0.09]) rotate([90,-2.8072885197114346+90,0]) wedge(93.03971194201121,18.206510612851783+0.25,0,16.8);
    translate([-69.3+20.04756927+0.25,-0.6306896209716797,2118+4.3215332]) rotate([0,-2.8072885197114346,0]) cube([28.4,16.8,93.03971194201121],center=true);
    translate([-155-22.65451067+4.32503615-0.0185176,2.5,2116+25.03014438+1.6315593+1.62735469]) rotate([-90,-2.8072885197114346+90,0]) wedge(72.91479492+1.6,26.15959167-3.45,0,15);
    translate([-169-4.3,2.5,2171-27.2+0.2]) rotate([90,-2.8072885197114346-90,0]) wedge(18.72851562,5.102005+0.76,0,15);
    translate([-155-4.51397705,2.5,2160-5.80273438-0.02]) rotate([0,-2.8072885197114346,0]) cube([16.81381809031547,15,18.437409368749147],center=true);
    translate([-117-12.55174255-0.07+49.911988288138545/2,2.5,2120-1.59204102-0.025+1.2157124992685864+0.01]) rotate([0,-2.8072885197114346,0]) cube([39.533079730089625+49.911988288138545,15,93.03971194201121],center=true);
    translate([-90+25.92560595+0.01+0.8,25-2.74473534,2120.2582600911455+1.39089331]) rotate([180,2.8072885197114346,180]) wedge(46.5802003461415,12.855264644663567-0.55,0,93);
    translate([-94.1+29.51307232+1.35+0.051,-16.8+2.7069975+1.25-0.35,2120.2582600911455+1.39089331]) rotate([0,2.8072885197114346,180]) wedge(46.519273584612755,7.87459913+0.4,0,93);

};

module wedge(xdim,ydim,box,zlength) {
    // Creates a triangular wedge of sides xdim and ydim extruded zlength
    // box adds a box on the end of the wedge.
    translate([0,-ydim,-zlength/2]) linear_extrude(height=zlength) polygon(points=[[0,0],[xdim,0],[0,ydim],[-box,ydim],[-box,0]]);
};

module section_1 () {
/*

Note: US is Upstream,  DS is Downstream

Section 1 is comprised of the two straight sections of pipe from about z=0 to z=327.
Variables are cut and pasted from the jupyter lab analysis
*/

// Inspecting z=19 and z-330 , taking section across the cylinder

pipeUSface_x_1 = -120.996948467760;
pipeUSface_x_2 = -98.19016614693;
pipeUS_z = 19;
pipeDSface_x_1 = -128.594276891903;
pipeDSface_x_2 = -106.58699141472354;
pipeDS_z = 330;
place_round_pipe(pipeUSface_x_1,pipeUSface_x_2,pipeUS_z,pipeDSface_x_1,pipeDSface_x_2,pipeDS_z);

// Inspecting z = 32 and 314
cube_x = 2*24.7999992370605;
cube_y = 2*6.899999618530273;
cube_height = 314-32+2;
translate([0,0,cube_height/2+32]) cube([cube_x,cube_y,cube_height],center=true);

};

//###############################
module section_3 () {



// Inspection z = 2323 and 2798
pipeUSface_x_1 = -177.68359375; 
pipeUSface_x_2 = -199.943165480554+(177.91669737358-177.68359375);
pipeUS_z = 2318.24609375;
pipeDSface_x_1 = -223.23756266922706-(201.51055908203125-201.21117696015426);
pipeDSface_x_2 = -201.51055908203125; 
pipeDS_z = 2804.10546875;
place_round_pipe(pipeUSface_x_1,pipeUSface_x_2,pipeUS_z,pipeDSface_x_1,pipeDSface_x_2,pipeDS_z);

resolution = 30;
translate([-212.49735260009766,0,2803.5667724609375]) rotate([0,-2.8774509770947363,0]) cylinder(h= 29.2,  r1=22/2, r2=15.9/2,  $fn=resolution);
translate([-213.9178237915039,0,2832.5321044921875]) rotate([0,-2.8774509770947363,0]) cylinder(h= 20.6,  r1=15.9/2, r2=22.8/2,  $fn=resolution);

// Inspecting z = 2347 and z = 2858 
cube_x = 2*30.1;
cube_y = 2*11.1;
cube_height = 2858-2347+2;
translate([0,0,cube_height/2+2347-2]) cube([cube_x,cube_y,cube_height],center=true);


};

/*
Generic routine that extrudes the child shape and then
rotates and translates the shape so that the origin of the
polygon is at P0(x0,y0,z0) and it points along the line from
P0 to P1(x1,y1,z1)  

*/
module place_polygon(x0,y0,z0,x1,y1,z1) {
extrudelength = sqrt((z1-z0)^2 + (y1-y0)^2 + (x1-x0)^2);
x_rot = asin((x1-x0)/extrudelength);
y_rot = asin((y1-y0)/extrudelength);
z_rot = asin((z1-z0)/extrudelength);
translate([x0,y0,z0]) rotate([x_rot,y_rot,z_rot]) linear_extrude(height=extrudelength) children(0);
};

module place_round_pipe(pipeUSface_x_1,pipeUSface_x_2,pipeUS_z,pipeDSface_x_1,pipeDSface_x_2,pipeDS_z) {

pipeUSface_x = (pipeUSface_x_1 + pipeUSface_x_2) / 2;
pipe_diameter = abs(pipeUSface_x_2 - pipeUSface_x_1);
pipeDSface_x = (pipeDSface_x_1	+ pipeDSface_x_2) / 2;
place_polygon(pipeUSface_x,0,pipeUS_z,pipeDSface_x,0,pipeDS_z) circle(d=pipe_diameter, $fn=60);


};



module qmqa_crosssection () {
// Polygon Created .  Taken at 360
polygon ( points = [
[ 0.6736544677688516 , -33.0 ],
[ -12.149727026309742 , -32.59229674415663 ],
[ -16.20372620934299 , -31.38533812958322 ],
[ -18.42051300404647 , -30.341213923144284 ],
[ -21.93100892528291 , -27.978600353625197 ],
[ -23.49797034980033 , -26.55634880065918 ],
[ -23.49797034980033 , -26.55634880065918 ],
[ -39.573022079517685 , -10.486737287006417 ],
[ -43.1320308804998 , -6.928932189941406 ],
[ -47.68352322982801 , -4.3241199108462 ],
[ -60.949123582991874 , -4.0 ],
[ -105.13392564872149 , -4.0 ],
[ -108.52570858890584 , -5.335939116316142 ],
[ -109.99346290730328 , -7.104857948945272 ],
[ -112.59501146636157 , -9.364928681414105 ],
[ -113.9626619452582 , -10.080096825535028 ],
[ -115.7859017045321 , -10.67819852345025 ],
[ -120.00785571721595 , -10.876058627551622 ],
[ -122.95765269541461 , -9.99540676347938 ],
[ -124.31115356402121 , -9.254855024685575 ],
[ -126.88646570579168 , -6.94933270307405 ],
[ -128.48049233371583 , -4.317595877009795 ],
[ -128.985940225516 , -2.860641421092922 ],
[ -129.36424656143788 , 0.1926337626208841 ],
[ -128.48049233371583 , 4.317595877009795 ],
[ -127.57506447107 , 6.017136946853554 ],
[ -124.62524903202912 , 9.03627117497735 ],
[ -120.00785571721595 , 10.876058627551622 ],
[ -115.41692984582662 , 10.59687588130279 ],
[ -111.64443797444864 , 8.68648685780843 ],
[ -110.49488649884569 , 7.659418004899543 ],
[ -109.26930511094463 , 6.1875 ],
[ -105.33270310051596 , 4.016154356600405 ],
[ -50.20550306887068 , 4.0 ],
[ -45.32498105683694 , 5.2757493474527974 ],
[ -43.1320308804998 , 6.928932189941406 ],
[ -39.573022079517685 , 10.486737287006417 ],
[ -23.49797034980033 , 26.55634880065918 ],
[ -18.42050039207047 , 30.341221805629285 ],
[ -14.204949309937316 , 32.086903704377995 ],
[ -10.375930538624187 , 32.8552454219573 ],
[ -6.481003825540791 , 33.0 ],
[ 0.6736544677688516 , 33.49918907383696 ],
[ 0.09029732600463924 , 36.0 ],
[ 22.68111053345372 , 35.52524561980925 ],
[ 24.039249654489897 , 33.0 ],
[ 33.429865291416185 , 32.895890643015576 ],
[ 35.93416062002107 , 32.48888463231418 ],
[ 37.626131362758755 , 32.068965911865234 ],
[ 46.89487865314369 , 29.28399706659799 ],
[ 99.73686537380283 , 13.407524108886719 ],
[ 105.51608215743603 , 9.99070925726787 ],
[ 108.42760521388973 , 5.850889720743571 ],
[ 109.09889857669424 , 4.078238527592678 ],
[ 108.50910391004187 , -5.6618582259799775 ],
[ 105.6584792092285 , -9.839630490248453 ],
[ 101.32416110181846 , -12.823933189230962 ],
[ 99.73686537380283 , -13.407524108886719 ],
[ 99.73686537380283 , -13.407524108886719 ],
[ 35.547797969392775 , -32.584538961369944 ],
[ 22.68111053345372 , -33.0 ],
[ 23.234449852525582 , -36.0 ],
[ 0.6736544677688516 , -36.0 ]
]);

}
