#!/bin/bash


command time -v \
stringtie "$BAM" \
          -o "$OUT_DIR/StringTie_assembly.gtf" \
          -p 4 \
          2>&1 | tee "$OUT_DIR/StringTie_tee.log"
