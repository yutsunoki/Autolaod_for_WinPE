@echo off &echo;[2J[H
del winpe_f.iso

oscdimg -bootdata:2#p0,e,bwinpe_c\fwfiles\etfsboot.com#pEF,e,bwinpe_c\fwfiles\efisys.bin -u1 -udfver102 winpe_c\media winpe_f.iso

echo;build cd [[38;5;41mdone[m]
