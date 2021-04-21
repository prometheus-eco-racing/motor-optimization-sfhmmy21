function Magnet_Mass =Calculate_Magnet_Mass(newrso, go, newdm, newhh)

    mo_selectblock(newrso+go+newdm/2,0)
    Magnet_Mass = 14*mo_blockintegral(5)*newhh*7650/1000;
    mo_clearblock;

end