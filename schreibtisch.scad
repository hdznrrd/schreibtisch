thinkness_box = 16;
thickness_top = 19;
router_depth = 7;
router_stop = 20;

router_width = 10;

offset_edge = 10;



base_height = 800;
base_width = 300+2*thinkness_box;
base_depth = 500;
top_width = 1600;
top_depth = base_depth+2*offset_edge;

width_box_element = base_width;//300;
height_box_element = 330;


tray_positions_z = [0,height_box_element+thinkness_box,2*(thinkness_box+height_box_element)];

module side() {
	color([1,0,0]) cube([thinkness_box,width_box_element,base_height]);
}

module routerbit() {
	polygon([[-12.7/2,0],[12.7/2,0],[6/2,12.5],[-6/2,12.5]]);
}

module tray() {
	difference() {
		translate([-base_width/2,0,0]) color([0,1,0]) cube([base_width,base_depth,thinkness_box]);
// beauty cut for clean end left
		translate([-base_width/2,width_box_element-router_width/2,0]) cube([thinkness_box,router_width,thinkness_box]);
// beauty cut for clean end right
		translate([base_width/2-thinkness_box,width_box_element-router_width/2,0]) cube([thinkness_box,router_width,thinkness_box]);
	}
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

// render_mode =
//	 1 : render trays
//	 2 : render boxes
//	 3 : render boxes and trays
//	 4 : render mixed
module desk(draw_box_left, draw_box_right, draw_tray_left, draw_tray_right) {
	if(draw_top==1) top();
	positioned_box(draw_box=draw_box_left, draw_tray=draw_tray_left);
	mirror([1,0,0]) positioned_box(draw_box=draw_box_right, draw_tray=draw_tray_right);

}

module 2d_front_mixed() {
	projection(cut=true)
	translate([0,0,100]) rotate([-90,0,0])
	desk(draw_tray_right=1, draw_box_left=1, draw_top=1);
}

module 2d_tray_top() {
	projection(cut=true)
	translate([top_width/2-base_width/2-offset_edge,0,-offset_edge-thinkness_box/2]) //rotate([-90,0,0])
	desk(draw_tray_left=1);
}

module 2d_wall() {
	translate([0,-width_box_element,0])
	rotate([0,0,90])
	projection(cut=true)
	translate([-width_box_element/2,0,top_width/2+offset_edge-router_depth-base_width]) rotate([0,-90,-90])
	desk(draw_tray_left=0, draw_tray_right=0, draw_box_left=1, draw_box_right=0);
}

module draw_2d() {
	2d_tray_top();
	2d_front_mixed();
	2d_wall();
}

module draw_3d() {
	desk(draw_tray_left=1, draw_tray_right=1, draw_box_left=1, draw_box_right=1, draw_top=1);
	% chair();
}

//draw_2d();
draw_3d();