#!/bin/sh
unison -repeat watch \
    -copyonconflict \
    -prefer newer \
    "/home/smissingham/.ProtonMount" \
    "/home/smissingham/Proton" \
#    &>./unison-log.log