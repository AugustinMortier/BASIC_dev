#!/bin/bash
unset LANG
scilab_dir='/Applications/scilab-5.3.3.app/Contents/MacOS/lib/'

export DYLD_LIBRARY_PATH=$scilab_dir/scilab:$scilab_dir/thirdparty:$DYLD_LIBRARY_PATH
scilab -nw -f sci_netcdf_builder.sce

