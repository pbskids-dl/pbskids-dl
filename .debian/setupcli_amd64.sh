cd $GITHUB_WORKSPACE
pwd
chmod +x *
mkdir pbskids-dl_deb
cd ./pbskids-dl_deb
mkdir -p opt/pbskids-dl.amd64
cd ./opt/pbskids-dl.amd64
cp $GITHUB_WORKSPACE/pbskids-dl.py .
pyinstaller pbskids-dl.py
chmod +x ./dist/pbskids-dl/pbskids-dl
cd ../..
mkdir -p usr/bin
cd ./usr/bin
ln -s /opt/pbskids-dl.amd64/dist/pbskids-dl/pbskids-dl pbskids-dl.amd64
cp $GITHUB_WORKSPACE/pbskids-dl.sh .
cp $GITHUB_WORKSPACE/pbskids-dl.py .
cd ../../
mkdir DEBIAN
cd ./DEBIAN
cp $GITHUB_WORKSPACE/.debian/control_amd64 ./control
cd $GITHUB_WORKSPACE
dpkg --build ./pbskids-dl_deb
sha256sum pbskids-dl_deb.deb > pbskids-dl.sha256sum
sha512sum pbskids-dl_deb.deb > pbskids-dl.sha512sum