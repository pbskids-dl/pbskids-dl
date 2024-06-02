cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl_gui_deb
cd ./pbskids-dl_gui_deb
ls -al
mkdir -p opt/pbskids-dl_gui
cd ./opt/pbskids-dl_gui
cp $GITHUB_WORKSPACE/pbskids-dl_gui.py .
pyinstaller pbskids-dl_gui.py
ls -al
chmod +x ./dist/pbskids-dl_gui/pbskids-dl_gui
cd ../..
mkdir -p usr/bin
cd ./usr/bin
ln -s /opt/pbskids-dl_gui/dist/pbskids-dl_gui/pbskids-dl_gui pbskids-dl_gui
cp $GITHUB_WORKSPACE/pbskids-dl_gui.sh .
ls -al
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control .
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl_gui_deb