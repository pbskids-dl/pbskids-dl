cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl
cd ./pbskids-dl
mkdir -p opt/pbskids-dl_gui
cd ./opt/pbskids-dl_gui
cp $GITHUB_WORKSPACE/pbskids-dl_gui.py .
pyinstaller pbskids-dl_gui.py
chmod +x ./dist/pbskids-dl_gui/pbskids-dl_gui
cd ../..
mkdir -p usr/bin
cd ./usr/bin
ln -s /opt/pbskids-dl_gui/dist/pbskids-dl_gui/pbskids-dl_gui pbskids-dl_gui
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control.py ./control
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl