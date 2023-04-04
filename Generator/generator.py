import random as rnd
import math
import tf.transformations as tft
file1 = open("ARM_NOSTRO.txt","r+")
file2 = open("ARM_GEN.txt","w+")
lines = file1.readlines()
out_lines = []
pref = "" 
prefixes = ["##SC##", "##SPCO##", "##IWC##", "##FIX##"]
skip_next = False
### SC stuffs
sc_names = ["bBottle2", "bBottle3", "yBottle3", "gCan2"]
sc_sure = ['blueBottle','blueBottle']
sc_positions = ['0.2191 -0.0220 0.5548  1.57  -1.55  0.01', '0.0734 0.2300 0.6338  0.00  -0.00  0.00', '0.2630 -0.2251 0.5554  1.61  1.56  1.61', '0.3064 0.1509 0.6339  0.00  0.00  -0.01']
rnd.shuffle(sc_positions)
sc_possible = ['greenCan','yellowBottle', 'blueBottle','greenCan']
rnd.shuffle(sc_possible)
sc_items = sc_sure + sc_possible[0:2]
rnd.shuffle(sc_items)

### IWC stuffs
iwc_names = ["gCan4 greenCan", "yCan2 yellowCan", "yCan3 yellowCan", "yCan4 yellowCan", "yBottle4 yellowBottle"]
iwc_poses =  ["0.3690 -0.5296 0.6768  0.00  -0.00  -2.99", "0.55 -0.4821 0.5718  -1.57  0.10  -0.83", "0.36 -0.45 0.61  0.00  -0.00  -2.95", "0.26 -0.42 0.61  -1.57  -1.09  2.18", "0.2430 -0.6251 0.7558  1.57  1.47  1.58"]

rnd.shuffle(iwc_names)
rnd.shuffle(iwc_poses)

for line in lines:
    if skip_next:
        out_lines.append(line)
        skip_next = False
        continue
    for pr in prefixes:
        if line.startswith(pr):
            pref = pr
            out_lines.append(line)
            skip_next = True
            break
    if skip_next:
        continue
    if pref == "##FIX##":
        out_lines.append(line)
        continue
    elif pref == "##SC##":
        line_ = f"{sc_names.pop()} {sc_items.pop()} {sc_positions.pop()}\n"
        out_lines.append(line_)
    elif pref == "##SPCO##":
        line_ = line.split()
        r,p,y = tft.euler_from_matrix(tft.random_rotation_matrix(), 'rxyz')
        line_[-3] = "{:.4f}".format(r) if rnd.randint(0, 1) == 1 else "0.0000"
        line_[-2] = "{:.4f}".format(p) if rnd.randint(0, 1) == 1 else "0.0000"
        line_[-1] = "{:.4f}".format(y) if rnd.randint(0, 1) == 1 else "0.0000"
        line_ = " ".join(line_) + "\n"
        out_lines.append(line_)
    elif pref == "##IWC##":
        #! NOTE: not perfect, should also slightly change the position
        name_ = iwc_names.pop()
        pose_ = iwc_poses.pop().strip().split()
        # R = tft.euler_matrix(float(pose_[-3]), float(pose_[-2]), float(pose_[-1]), 'rxyz')
        # r,p,y = tft.euler_from_matrix(R*tft.random_rotation_matrix(), 'rxyz')
        angles = [math.pi/2, 0, -math.pi/2, math.pi]
        rnd.shuffle(angles)
        pose_[-3] = "{:.4f}".format(angles[rnd.randint(0, 3)])
        pose_[-2] = "{:.4f}".format(angles[rnd.randint(0, 3)]) 
        pose_[-1] = "{:.4f}".format(angles[rnd.randint(0, 3)])
        line_ = f"{name_} {' '.join(pose_)}\n"
        out_lines.append(line_)
    else:
        out_lines.append(line)

file2.writelines(out_lines)
file1.close()
file2.close()