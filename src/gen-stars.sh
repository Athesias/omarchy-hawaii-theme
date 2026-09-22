#!/bin/bash
# Deterministic scatter of faint stars across the upper sky.
seed=$1; count=$2; maxy=$3
awk -v seed="$seed" -v n="$count" -v maxy="$maxy" 'BEGIN{
  srand(seed);
  for(i=0;i<n;i++){
    x=int(rand()*2560); y=int(rand()*maxy);
    r=rand()*1.6+0.6;
    # fade stars out as they approach the bright horizon
    o=(1-(y/maxy))*0.75*(rand()*0.7+0.3);
    if(o<0.04) continue;
    printf "  <circle cx=\"%d\" cy=\"%d\" r=\"%.2f\" fill=\"#fff5ec\" opacity=\"%.3f\"/>\n", x,y,r,o;
  }
}'
