# Compiling Debian Package
If you want to make a Debian package of pbskids-dl, follow this guide.
1. Run `git clone --recurse-submodules https://github.com/NexusSfan/pbskids-dl.git`
2. Go into the directory you cloned pbskids-dl and run `chmod +x ./.debian/setup*.sh`
3. Now you are ready to compile. Run `./.debian/setupcli.sh`
4. If you want to compile the GUI version, run `./.debian/setupgui.sh`
5. Now you should see pbskids-dl_deb.deb and/or pbskids-dl_gui_deb.deb. Those are your debian packages!
