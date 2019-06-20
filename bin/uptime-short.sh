#!/bin/bash
awk '{d=int($1/60/60/24);h=int($1/60/60%24);m=($1/60%60);if (d==0){if (h==0){ printf "%dm",m } else {printf "%dh",h}} else {printf "%dd",d} }' /proc/uptime
