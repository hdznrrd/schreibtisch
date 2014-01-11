thinkness_box = 16;
thickness_top = 19;
router_depth = 7;
router_stop = 20;
offset_edge = 10;



base_height = 800;
base_width = 300+2*thinkness_box;
base_depth = 500;
top_width = 1600;
top_depth = base_depth+2*offset_edge;

width_box_element = 300;
height_box_element = 330;


tray_positions_z = [0,height_box_element+thinkness_box,2*(thinkness_box+height_box_element)];

module side() {
	color([1,0,0]) cube([thinkness_box,base_width,base_height]);
}

module routerbit() {
	polygon([[-12.7/2,0],[12.7/2,0],[6/2,12.5],[-6/2,12.5]]);
}

module tray() {
	translate([-base_width/2,0,0]) color([0,1,0]) cube([base_width,base_depth,thinkness_box]);
}


module routed_side() {
	router_center =  thinkness_box/2;
	translate([-base_width/2,0,0])
		difference() {
			side();
			for(z=tray_positions_z) {
				translate([thinkness_box-router_depth,base_depth+router_stop,z+router_center+offset_edge]) rotate([90,90,0]) linear_extrude(height=base_depth-router_stop)  { routerbit(); }
			}
		}
}

module box_walls() {
	routed_side();
	mirror([1,0,0]) routed_side();
	translate([-base_width/2,base_depth-(thinkness_box-router_depth),0]) translate([0,-width_box_element/2,0]) rotate([0,0,-90]) routed_side();
}

module box_trays() {
	difference() {
		for(z=tray_positions_z) {
			translate([0,0,z+offset_edge]) tray();
		}
		box_walls();
	}
}

module top() {
	translate([-top_width/2,0,base_height]) color([0,0,1]) cube([top_width,top_depth,thickness_top ]);
}

module chair() {
	chair_width = 800;
chair_height = 750;
	translate([-chair_width/2,-chair_width/2,0]) cube([chair_width,chair_width,700]);
}

module positioned_box(draw_box, draw_tray) {
	translate([-(top_width)/2+base_width/2+offset_edge,0,0]) {
		if(draw_box==1) box_walls();
		if(draw_tray==1) box_trays();
	}
}

module desk(full) {
	top();
	positioned_box(draw_box=1, draw_tray=full);
	mirror([1,0,0]) positioned_box(draw_box=full, draw_tray=1);

}

//projection(cut=true)
	//translate([0,0,100]) rotate([-90,0,0]) // front + routed
	//translate([0,0,100]) rotate([-90,0,0]) // front + routedS
desk(full=1);
% chair();
