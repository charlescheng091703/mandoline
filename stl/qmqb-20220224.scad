use <path_extrude.scad>;

delta = 2;
model_min_z = 35;
model_max_z = 2844;

lengthofbox = model_max_z - model_min_z - delta;

// Note:  In the original modeling, we translated the model -110 inches
// along Z, so we need to translate it back in order to fit the
// modeling for Michael

model_translation_distance = 634*25.4;
// model_translation_distance = 0;

// vacuum_chamber();
translate([0,0,model_translation_distance]) render_negative();

module render_negative () {

// Create a Cube to simulate the "air" side of the vacuum system.
// Translate the cube 1/2 the distance along Y to see the impression of the chamber
// in the box
out_box_size = 600;
Y_offset = 0 ;  // Set to 0 or out_box_size/2 to "see" the chamber.
// Y_offset = out_box_size/2 ;  // Set to 0 or out_box_size/2 to "see" the chamber.
difference() {
translate([-700, Y_offset,lengthofbox/2 + model_min_z]) cube([out_box_size,out_box_size,lengthofbox],center=true);
// Now subtract the vacuum chamber
vacuum_chamber();
};

};

//vacuum_chamber();

/* dlmb_chamber is a bent section with
   a leading in round vacuum section */

module vacuum_chamber () {
    section_1();
    section_3();
    curved_vaccum_chamber();
};

module curved_vaccum_chamber() {
    myPoints = [[4.10762951874969, 629.2857537721125], [4.107093663911854, 633.1126430801248], [4.478354978354982, 634.9737903225806], [5.254870129870138, 636.296370967742], [6.807900432900436, 637.5362903225806], [8.250000000000004, 638.9415322580645], [9.581168831168835, 640.7600806451613], [10.35768398268399, 642.4959677419355], [10.912337662337666, 644.3145161290323], [11.13419913419914, 646.0504032258065], [11.023268398268403, 647.5383064516129], [10.80140692640693, 648.9435483870968], [10.246753246753254, 650.5141129032259], [9.692099567099572, 651.8366935483871], [8.915584415584423, 652.9939516129033], [8.02813852813853, 654.1512096774194], [6.807900432900436, 655.1431451612904], [5.365800865800868, 656.1350806451613], [3.590909090909097, 656.8790322580645], [1.7050865800865829, 657.375], [-0.0698051948051912, 657.5403225806451], [-1.6228354978354922, 657.375], [-3.39772727272727, 656.9616935483871], [-4.950757575757571, 656.3004032258065], [-6.614718614718612, 655.2258064516129], [-7.72402597402597, 654.233870967742], [-8.944264069264065, 652.828629032258], [-9.720779220779217, 651.4233870967741], [-10.275432900432897, 650.1834677419355], [-10.83008658008658, 648.8608870967741], [-10.941017316017312, 647.4556451612904], [-11.051948051948049, 645.9677419354839], [-10.83008658008658, 644.6451612903226], [-10.49729437229437, 643.1572580645161], [-10.053571428571427, 641.9173387096774], [-9.387987012987011, 640.5947580645161], [-8.611471861471859, 639.4375], [-7.502164502164501, 638.3629032258065], [-6.170995670995669, 637.1229838709678], [-5.061688311688307, 636.3790322580645], [-4.507034632034628, 635.304435483871], [-4.174242424242422, 634.2298387096774], [-4.0633116883116855, 632.6592741935484], [-3.952380952380949, 631.171370967742], [-3.952380952380949, 623.5665322580645], [-3.9773403679653825, 614.06875], [-3.9848484848484826, 595.2237903225807], [-3.9848484848484826, 577.4233870967743], [-4.136363636363633, 575.7903225806452], [-4.818181818181815, 573.8306451612904], [-5.803030303030301, 571.8709677419356], [-13.15151515151515, 564.5221774193549], [-27.140151515151512, 550.375], [-28.939393939393938, 547.9375], [-30.73863636363636, 544.9375], [-32.15909090909091, 541.375], [-32.916666666666664, 537.625], [-33.01136363636363, 526.5625], [-35.946969696969695, 526.5625], [-35.946969696969695, 504.4375], [-32.916666666666664, 504.4375], [-32.916666666666664, 494.6875], [-32.72727272727273, 492.4375], [-32.06439393939394, 490.0], [-30.454545454545453, 484.375], [-13.386327903750253, 427.039263261763], [-12.604978354978353, 425.1532258064516], [-12.272186147186144, 424.5040322580645], [-12.050324675324674, 423.9112903225806], [-11.495670995670995, 423.1491935483871], [-10.941017316017312, 422.4153225806452], [-10.386363636363633, 421.7096774193548], [-9.60984848484848, 420.9193548387097], [-8.833333333333332, 420.18548387096774], [-7.72402597402597, 419.4516129032258], [-6.725649350649348, 418.8306451612903], [-5.727272727272723, 418.2943548387097], [-4.507034632034628, 417.84274193548384], [-3.1758658008657967, 417.4475806451613], [-1.8446969696969653, 417.19354838709677], [-0.6244588744588704, 417.0806451612903], [0.8176406926406976, 417.0524193548387], [2.148809523809529, 417.19354838709677], [3.2581168831168874, 417.4193548387097], [4.700216450216455, 417.81451612903226], [5.698593073593077, 418.2096774193548], [6.475108225108233, 418.60483870967744], [7.140692640692645, 419.0], [7.917207792207801, 419.5362903225806], [8.804653679653686, 420.1290322580645], [9.692099567099572, 420.86290322580646], [10.246753246753254, 421.4556451612903], [10.80140692640693, 422.0483870967742], [11.245129870129876, 422.72580645161287], [11.910714285714295, 423.5443548387097], [12.354437229437234, 424.25], [12.687229437229444, 424.9556451612903], [13.020021645021654, 425.60483870967744], [13.246723730814661, 426.4199999999999], [13.409388528138562, 426.90268987341784], [13.642857142857146, 427.6350806451613], [13.821428571428577, 428.4334677419355], [31.948051948051948, 489.02419354838713], [32.46753246753247, 491.491935483871], [32.81385281385282, 492.86290322580646], [32.98701298701299, 494.7137096774194], [32.98701298701299, 504.5161290322581], [36.01731601731602, 504.5161290322581], [35.9745670995671, 526.6209677419355], [33.07142857142857, 526.6209677419355], [32.99296536796537, 535.5927419354839], [32.91450216450217, 538.0120967741937], [32.365259740259745, 540.6330645161291], [31.89448051948052, 542.2459677419355], [30.717532467532468, 545.1693548387098], [29.77597402597403, 546.8830645161291], [29.1482683982684, 547.8911290322582], [27.68664603625541, 549.8675464320627], [6.396645021645023, 571.3145161290323], [5.176406926406928, 573.0362903225807], [4.510822510822512, 574.8810483870968], [4.1780303030303045, 576.233870967742], [4.067099567099568, 578.2016129032259], [4.026055194805201, 607.2074222647157], [4.004329004329007, 631.2943548387098]];
    myPath = [
    [-415.3939393939394,0,582.3387096774194], 
    [-416.96844482421875,0,598.84716796875], 
    [-423.3135986328125,0,657.2777099609375], 
    [-436.2357177734375,0,774.2333374023438], 
    [-442.78076171875,0,832.70263671875], 
    [-449.3818054199219,0,891.1641845703125], 
    [-462.7518310546875,0,1008.0702514648438], 
    [-469.52081298828125,0,1066.51318359375], 
    [-476.3167419433594,0,1124.4786376953125], 
    [-483.510009765625,0,1185.836181640625], 
    [-490.7838439941406,0,1247.2447509765625], 
    [-498.10528564453125,0,1308.6488037109375], 
    [-505.474365234375,0,1370.046630859375],
    [-512.8871459960938,0,1431.190185546875], 
    [-520.2232055664062,0,1491.7694091796875], 
    [-535.079345703125,0,1613.0301513671875], 
    [-542.56640625,0,1673.65283203125], 
    [-550.0927124023438,0,1734.2724609375], 
    [-565.2632446289062,0,1855.492919921875], 
    [-572.8795776367188,0,1915.670654296875], 
    [-581.8786010742188,0,1986.852294921875], 
    [-590.9588012695312,0,2058.095947265625], 
    [-600.0853881835938,0,2129.33349609375], 
    [-609.2584228515625,0,2200.56494140625], 
    [-622.1243053151146,0,2299.86486020342], 
    [-638.3361291594696,0,2425.938625356168], 
    [-645.5863647460938,0,2479.285888671875], 
    [-654.6711278976101,0,2548.3542450795303], 
    [-656.267316017316,0,2560.354838709677],
    [-658.3387445887446,0,2576.266129032258]
    ];
    difference() {
        translate([-660.06493506+1086-9.31459270526551-1.5,0,-59.01209677+98.82319779]) rotate([0,0,0]) path_extrude(exShape=myPoints, exPath=myPath);
        crotch_absorber();
    };
    resolution = 60;
    translate([-760.3515625,0,2545.48486328125]) rotate([0,-7.359979288834694,0]) cylinder(h=22.2,  r=112.19842390947878/2,  $fn=resolution);

};

module crotch_absorber() {
    translate([-615+5.13789683,0.9059999585151672,2365+0.32995008]) rotate([0,-7.527143399715887,0]) cube([279.33919407353613,5.35,124],center=true);
    translate([-760+20.0662624,0.9059999585151672,2371.3649193548385-85.53917225]) rotate([90,-7.527143399715887+180,0]) wedge(20.153239611131553,124,0,5.35);
    translate([-482-22.10278607,0,2383-2.77159525]) rotate([0,-7.527143399715887,0]) cube([65.71629105,27,124],center=true);
    translate([-801-2.84357115+5+0.75,2.581,2341-0.4]) rotate([0,-7.527143399715887,0]) cube([89.34756335273096+10+1.5,1.96199977,124],center=true);

    translate([-806.8571428571429+2.52775147+0.73093389,-0.15,2379.7741935483873-54.20802712-3+0.09491332]) rotate([-90,-14.242813452418265,0]) wedge(28.529119777645555+1,77.1414793054433+1*77/29,0,3.5);
    translate([-832.9188311688312-5.71086874,-0.15,2387.3225806451615-1.3482062]) rotate([0,-14.079387015449136,0]) cube([34.587831676686456,3.5,20.130862271553053],center=true);
    translate([-833.6666666666667+7.85165552,-0.15,2374.939516129032-43.99342839]) rotate([-90,-10.253753686354731,0]) wedge(15.37878364174911-0.2,44.57823119092823+3.5,0,3.5);
    translate([-834.3228144514023+9.77452069,-0.15,2378.084343452091-54.12321942]) rotate([90,-10.164631992831087+180,0]) wedge(15.37878364174911+10,55.1331405686341,0,3.5);

};

module wedge(xdim,ydim,box,zlength) {
    // Creates a triangular wedge of sides xdim and ydim extruded zlength
    // box adds a box on the end of the wedge.
    translate([0,-ydim,-zlength/2]) linear_extrude(height=zlength) polygon(points=[[0,0],[xdim,0],[0,ydim],[-box,ydim],[-box,0]]);
};

module section_1 () {

    resolution = 60;
    translate([-589+4.42605398,0,32-3.10929736]) rotate([0,-6.192406206111134,0]) cylinder(h=532.4402139312318+3.04,  r=11,  $fn=resolution);
    translate([-561.5846326975739-32.628953626500476+8.140693642326035-0.5,0,296+1.52]) rotate([0,-6.192406206111134,0]) cube([32.628953626500476,6,532.4402139312318+3.04],center=true);
    translate([-545.4933825442248+3.65763967+0.138,0,32-3.10929736+4.68874716]) rotate([0,-6.192406206111134,0]) cylinder(h=532.4402139312318+3.04,  r=3,  $fn=resolution);
    
};

//###############################
module section_3 () {

    resolution = 60;
    translate([-882.1176628343987,0,2529.3343939012093]) rotate([0,-7.527086565902483,0]) cylinder(h=278.08240572615335,  r=11,  $fn=resolution);
    translate([-907.6610824699314-16.2/2-3.17269188+0.33264219,0,2806.303020114185-1.03815308-0.39121484]) rotate([0,-7.527086565902483,0]) cylinder(h=24.3,  r1=11, r2=16.2/2, $fn=resolution);
    translate([-921.7101745605469,0,2828.6558837890625]) rotate([0,-7.527086565902483,0]) cylinder(h=13.3-1.0265800208217948,  r1=16.2/2, r2=11, $fn=resolution);
    translate([-923.2537991522363-0.05,0,2840.762457319849]) rotate([0,-7.527086565902483,0]) cylinder(h=1.0265800208217948-0.23,  r=11, $fn=resolution);
    translate([-923.4131164550781,0,2841.5435791015625]) rotate([0,-7.527086565902483,0]) cylinder(h=2.4,  r=22.8/2, $fn=resolution);
    translate([-799.5622863769531-28.109574846221108/2-0.73263829+0.03,0,2564.9635009765625+333.30166779161874/2-0.72455538+0.07-2]) rotate([0,-5.062508229984608,0]) cube([28.109574846221108,11,333.30166779161874+4],center=true);

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
