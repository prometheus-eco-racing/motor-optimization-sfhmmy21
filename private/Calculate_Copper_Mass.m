function Copper_Mass =Calculate_Copper_Mass(newhh)

mo_groupselectblock(3);
Copper_Mass = 0.5*mo_blockintegral(5)*newhh*8960/1000;
mo_clearblock;
end