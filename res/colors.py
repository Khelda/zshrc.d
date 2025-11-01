#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
from math import *

if __name__ == "__main__":
    col: str = sys.argv[1].split(
        '#')[1] if sys.argv[1][0] == '#' else sys.argv[1]  # input color
    target: str = sys.argv[2].split(
        '#')[1] if sys.argv[2][0] == '#' else sys.argv[2]  # resource color
    # distance calculus
    dist: int = sqrt(
        pow(int(target[0:2], 16) - int(col[0:2], 16), 2) +
        pow(int(target[2:4], 16) - int(col[2:4], 16), 2) +
        pow(int(target[4:6], 16) - int(col[4:6], 16), 2))
    # sending back info to script
    print(dist)
