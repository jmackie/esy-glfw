
TARGET=$(cygpath -u ${cur__target_dir})

echo "Target dir: $TARGET"
        
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$TARGET -DGLFW_BUILD_EXAMPLES=NO -DGLFW_BUILD_TESTS=NO -DGLFW_BUILD_DOCS=NO -DCMAKE_C_COMPILER=/usr/bin/x86_64-w64-mingw32-gcc -DCMAKE_C_LINK_EXECUTABLE=/usr/bin/x86_64-w64-mingw32-ld -DCMAKE_RC_COMPILER=/usr/bin/x86_64-w64-mingw32-windres.exe  -DUNIX=NO -DWIN32=YES .

#cmake -G "Unix Makefiles" ../ -DCMAKE_INSTALL_PREFIX=$cur__install -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DCMAKE_DISABLE_FIND_PACKAGE_HarfBuzz=TRUE

