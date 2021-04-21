function BuildMotor(rso, rsi, dm, dc, ds, fm, fp, ft, fb, go, hh, Jpk)

	% rso = Stator outer radius 
	% rsi = Stator inner radius 
	% dm = Magnet thickness 
	% dc = Can thickness 
	% ds = depth of slot opening 
	% fm = Pole fraction spanned by the magnet 
	% fp = Pole fraction spanned by the iron 
	% ft = Width of tooth as a fraction of pole pitch at stator ID 
	% fb = Backiron thickness as a fraction of tooth thickness 
	% go = stator to magnet mechanical clearance 
	% hh = axial length of the machine
	% Jpk= peak current density in the winding 

	newdocument(0);
	I=1i;
	j = 0;

	mi_probdef(0, 'millimeters', 'planar', 10.^(-8), hh, 30);
	mi_getmaterial('NdFeB 37 MGOe');
	mi_getmaterial('Air');
	mi_getmaterial('M-19 Steel');
	mi_getmaterial('1018 Steel');
	Jmap = ['A+';'A+';'A-';'B+';'B-';'B-';'B+';'C-';'C+';'C+';'C-';'A+';'A-';'A-';'A+';'B-';'B+';'B+';'B-';'C+';'C-';'C-';'C+';'A-'];
	mi_addmaterial('A+', 1, 1, 0, 0);
	mi_addmaterial('A-', 1, 1, 0, 0);
	mi_addmaterial('B+', 1, 1, 0, -Jpk);
	mi_addmaterial('B-', 1, 1, 0, Jpk);
	mi_addmaterial('C+', 1, 1, 0, Jpk);
	mi_addmaterial('C-', 1, 1, 0, -Jpk);
	mi_addboundprop('A=0',0,0,0,0,0,0,0,0,0);
	nr = 14;
	ns = 12;
	deg = pi/180.;
	rri = rso + go + dm;
	rro = rri + dc;
	ttam = fm*360/nr;
    %% 
    
	MyMiDrawArc(rro, -rro, 180, 1);
	MyMiDrawArc(-rro, rro, 180, 1);
	mi_selectarcsegment(0, rro);
	mi_selectarcsegment(0, -rro);
	mi_setarcsegmentprop(1, 'A=0', 0, 1);
	mi_drawarc(rri, 0, -rri, 0, 180, 1);
	mi_drawarc(-rri, 0, rri, 0, 180, 1);
	rm = rso + go;
    %% 
    
    
	for k = 0:(nr-1)
		t0 = k*360*deg/nr - ttam/2*deg ;
		t1 = k*360*deg/nr + ttam/2*deg ;
		mi_drawarc(rm*cos(t0), rm*sin(t0), rm*cos(t1), rm*sin(t1), ttam, 1);
		mi_drawline(rm*cos(t0), rm*sin(t0), rri*cos(t0), rri*sin(t0));
		mi_drawline(rm*cos(t1), rm*sin(t1), rri*cos(t1), rri*sin(t1));
		mi_addblocklabel(cos((t0 + t1)/2)*(rm + rri)/2,sin((t0 + t1)/2)*(rm + rri)/2);
		mi_selectlabel(cos((t0 + t1)/2)*(rm + rri)/2,sin((t0 + t1)/2)*(rm + rri)/2);
		MagDir = 360/nr*k + 180*(cos(pi*k) - 1)/2;
		mi_setblockprop('NdFeB 37 MGOe', 1, 0, '<None>', MagDir, 1, 1);
		mi_clearselected();
    end
    
    %%
	mi_addblocklabel(0, -(rri + rro)/2);
	mi_selectlabel(0, -(rri + rro)/2);
	mi_setblockprop('1018 Steel', 1, 0, '<None>', 0, 1, 1);
	mi_clearselected();
	mi_selectgroup(0);
	mi_setgroup(1);
	mi_addblocklabel(0, (rm + rso)/2);
	mi_selectlabel(0, (rm + rso)/2);
	mi_setblockprop('Air', 1, 0, '<None>', 0, 2, 0);
	mi_clearselected();
	ttap = fp*360/ns;
	rss = rso - ds;
	wt = 2*rsi*sin(ft*180*deg/ns);
	rsr = rsi + fb*wt; % tooth 'root' radius 
	newrsr = rsr;
	
    %%
	for k = 0:(ns-1)
		t0 = k*360*deg/ns - ttap/2*deg ;
		t1 = k*360*deg/ns + ttap/2*deg ;
		MyMiDrawArc(rso*exp(I*t0), rso*exp(I*t1), ttap, 1);
		MyMIDrawLine(rso*exp(I*t0), rss*exp(I*t0));
		MyMIDrawLine(rso*exp(I*t1), rss*exp(I*t1));
		p0 = rss*exp(I*t0);
		p1 = rss*exp(I*t1);
		p2 = (p0 + p1)/2;
		n = (p0 - p1)/abs(p0 - p1);
		p3 = p2 + n*wt/2;
		p4 = p2 - n*wt/2;
		MyMIDrawLine(p0, p3);
		MyMIDrawLine(p1, p4);
		p5 = p0*exp(I*360*deg/ns);
		MyMIDrawLine(p1, p5);
		ttat = ft*360/ns;
		t2 = k*360*deg/ns - ttat/2*deg ;
		t3 = k*360*deg/ns + ttat/2*deg ;
		% Intersection with tooth root 
		q0 = sqrt(rsr^2 - (1/4)*wt^2) + I*wt/2;
		q1 = sqrt(rsr^2 - (1/4)*wt^2) - I*wt/2;
		q0 = q0 * exp(I*k*360*deg/ns);
		q1 = q1 * exp(I*k*360*deg/ns);
		q2 = q1 * exp(I*360*deg/ns);
		MyMIDrawLine(q0, p4);
		MyMIDrawLine(q1, p3);
		MyMiDrawArc(q0, q2, arg(q2/q0)*180/pi, 1);
		MyMIDrawLine(rsr*exp(I*arg((q0 + q2))), (p1 + p5)/2);
		
		j=j+1;
		q3 = (rss + rsr)*exp(I*(k + 1/2 - 1/8)*360*deg/ns)/2;
		MyMiAddBlockLabel(q3);
		MyMISelectLabel(q3);
		mi_setblockprop(Jmap(j,:), 1, 0, '<None>', 0, 3, 0);
		mi_clearselected();
		
		j=j+1;
		q3 = (rss + rsr)*exp(I*(k + 1/2 + 1/8)*360*deg/ns)/2;
		MyMiAddBlockLabel(q3);
		MyMISelectLabel(q3);
		mi_setblockprop(Jmap(j,:), 1, 0, '<None>', 0, 3, 0);
		mi_clearselected();	
	end
	%%
	mi_drawarc(rsi, 0, -rsi, 0, 180, 5);
	mi_drawarc(-rsi, 0, rsi, 0, 180, 5);
	MyMiAddBlockLabel(0);
	MyMISelectLabel(0);
	mi_setblockprop('Air', 1, 0, '<None>', 0, 2, 0);
	mi_clearselected();
	MyMiAddBlockLabel((rss + rsr)/2);
	MyMISelectLabel((rss + rsr)/2);
	mi_setblockprop('M-19 Steel', 1, 0, '<None>', 0, 0, 0);
	mi_clearselected();
	mi_selectgroup(1);
	mi_moverotate(0, 0, 360/24-360/28);
	mi_clearselected();
	mi_zoomnatural();
	
end

function MyMIDrawLine(a,b)
	mi_drawline(real(a),imag(a),real(b),imag(b));
end

function MyMiDrawArc(a,b,c,d) 
	mi_drawarc(real(a),imag(a),real(b),imag(b),c,d);
end

function MyMiAddBlockLabel(a)
	mi_addblocklabel(real(a),imag(a));
end

function MyMISelectLabel(a)
	mi_selectlabel(real(a),imag(a));
end

function y=arg(x)
	y = atan2(imag(x),real(x));
end