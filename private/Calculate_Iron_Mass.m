function Iron_Mass =Calculate_Iron_Mass(newrsi, newrso, go, newdm, newdc, newhh)

    mo_selectblock((newrsi+newrso)/2,0)
    mo_selectblock(newrso+go+newdm+newdc/2,0)
    Iron_Mass = mo_blockintegral(5)*newhh*7870/1000;
    mo_clearblock;

end
