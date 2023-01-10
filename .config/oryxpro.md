- having an existing arch-linux installation we can install
  $ sudo pacman -S archiso

- to adapt the profile for image creation, e.g. add packages
  $ cp /usr/share/archiso/configs/releng ~/oryxpro/iso
  
- to add packages to the created iso edit
  $ vim ~/oryxpor/iso/packages.x86_64
  add one package per line e.g. vifm

- building system76 packages beforehand the following problems were faced
  and fixed

- ERROR: makepkg: One or more PGP signatures could not be verified

  FIX add --skippgpcheck arg to 'makepkg'
  see: https://bbs.archlinux.org/viewtopic.php?id=152337


- ERROR:
    error: failed to get `ecflash` as a dependency of package
    `system76-firmware v1.0.43
    (/home/goedel/oryxpro/pkgs/system76-firmware/src/system76-firmware)`
    
    Caused by:
      failed to load source for dependency `ecflash`
    
    Caused by:
      Unable to update
    https://github.com/system76/ecflash.git?branch=stable#ee9d69d4
    
    Caused by:
      failed to clone into:
    /home/goedel/.cargo/git/db/ecflash-90320af7ef020fdf
    
    Caused by:
      failed to authenticate when downloading repository:
    ssh://git@github.com/system76/ecflash.git
    
      * attempted ssh-agent authentication, but no usernames succeeded:
      * `git`
    
      if the git CLI succeeds then `net.git-fetch-with-cli` may help here
      https://doc.rust-lang.org/cargo/reference/config.html#netgit-fetch-with-cli
    
    Caused by:
      error authenticating: no auth sock variable; class=Ssh (23)
    ==> ERROR: A failure occurred in prepare().
        Aborting...

  FIX: export CARGO_NET_GIT_FETCH_WITH_CLI=true (see link of error msg)


- ERROR:
    ERROR Missing dependencies:
    	setuptools>=40.8.0
    	jaraco.text -> inflect -> pydantic>=1.9.1 ->
    typing-extensions>=4.1.0

  FIX: pip install --upgrade setuptools==60.10.0
  see: https://github.com/pypa/setuptools/issues/3198
 
- adding build oryxpro packages to the above copied iso-image:
  $ cd ~/oryxpor/iso/airottfs/root 
  $ mkdir pkgs
  $ cd pkgs
  copy allo *.zst files of the made packages to the created pkgs 
  dir in root
  $ repo-add \
      /home/goedel/oryxpro/iso/airootfs/root/pkgs/oryxpro.db.tar.gz \
      /home/goedel/oryxpro/iso/airootfs/root/pkgs/*.zst
  $ cd ../..
  in the iso-profile directory the pkgs repo needs to be added 
  to pacman.conf with the absolute path to the oryxpro packages since
  theses packages are integrated into the iso

    [pkgs]
    SigLevel = Optional TrustAll
    Server = file:///home/goedel/oryxpro/iso/airootfs/root/pkgs

  that means we need to set theses packages also up for for our
  installation to harddisk.  Hence the packages database along with
  the packages is put in the iso-profiles airootfs/root directory to
  have them available in the booted system.

 - build the image:
   $ sudo mkarchiso -v -w /tmp/archiso-tmp ./iso
   the iso can be found then in ~/oryxpro/out

- to test the image the packages qemu-desktop and edk2-ovmf must be 
  installed and virtualization must be turned on in the BIOS.
  $ sudo modprobe kvm
  to ensur the kvm modul loaded
  $ LC_ALL=C lscpu | grep Virtualization
  to check if virtualization is available
  $ chown goedel out/archlinux*.iso
  since the iso image is owned by root and can't be accessed by qemu
  $ qemu-system-x86_64 -m 4G -accel kvm \
      out/archlinux-2023.01.01-x86_64.iso
  then should run the emulation.  NOTE the name of the iso file needs
  to be adapted.

- install the image on a usb-stick
  $ cat out/archlinux-2023.01.02-x86_64.iso > /dev/sdb

- boot the image and follow 
  https://wiki.archlinux.org/title/installation_guide

- for WIFI netework to work after the reboot iwd and dhcpcd must be 
  installed and enabled:
  $ systemctl enable iwd.service
  $ systemctl enable dhcpcd.service
  we should also ensure that
  $ pacman -S git
  is installed as well as
  $ pacman -S vim vifm base-devel
  the later we need to compile AUR-packages like trash-d

- add a non root user with sudo-privelidges
  # pacman -S sudo
  # useradd -m -G wheel goedel
  # passwd goedel
  # export EDIT=vim
  # visudo
  shows the sudoer configuration file in which the line
    %wheel ALL=(ALL) ALL
  needs to be uncommented.
  Now we should be able to log out and login as goedel and running
  $ sudo pacman -Syu

- exchange of dot-files from a existing installation
  - create a bare repository on the existing installation
    $ git init --bare $HOME/.cnf
  - add an alias to ~/.bashrc to work with the repository
      alias cnf='/usr/bin/git --git-dir=$HOME/.cnf/ --work-tree=$HOME'
    make git status not show all untracked files
      cnf config --local status.showUntrackedFiles no 
    the later actually needs to be donw only once.  But I'm not clear 
    yet how to integrate this.
  - now we can add to our .cnf repository
    $ cnf add .bashrc
    $ cnf commit -m 'add: .bashrc'
    assuming we have .cnf-github repository (and git init created 
        a local default-branch called main):
    $ cnf remote add origin https://github.com/slukits/.cnf.git
  - now we can do on our new installation
    $ git clone --bare https://github.com/slukits/.cnf $HOME/.cnf
    $ alias cnf='/usr/bin/git --git-dir=$HOME/.cnf/ --work-tree=$HOME'
    $ cnf checkout HEAD .bashrc
    the later will overwrite the existing .bashrc with the .bashrc in 
    the repository

- to make as quickly as possible use from the capabilities of our 
  graphic card add xorg
  sudo pacman -S xorg
  sudo pacman -S xorg-xinit
  sudo pacman -S i3-gap i3blocks i3status
  sudo pacman -S alacritty

- add google chrome to our installation:
  $ cd Download/arch
  $ git clone https://aur.archlinux.org/google-chrome.git
  $ cd google-chrome
  $ makepkg -sri
  

- add fonts manager:
  $ sudo pacman -S font-manager
  the font-manager didn't work then until as root the following
  commands where executed.
  $ update-mime-database /usr/share/mime
  $ chmod 644 /usr/share/applications/mimeinfo.cache
  $ gtk-pixbuf-query-loaders --update-cache

- add Go-fonts globally as root:
  # git clone https://go.googlesource.comj/image ./gofonts
  # cp -r ./gofonts/font/gofont/ttfs /usr/share/fonts/go
  
- copy ~/.ssh/keys and ~/.ssh/known_hosts ~/.ssh/config to the new
  system and set access-modes properly:
  $ chmod 600 ~/.ssh/keys/*

- install Arc-Gruvbox gtk-theme and setup/transfair
  ~/.gtkrc-2.0
  ~/.config/gtk-3.0/
  ~/.config/gtk-2.0/

- for "auto"-mounting usb drives install
  $ sudo pacman -S udisks2
  and 
  $ cd ~/Downloads/arch/
  $ git clone https://aur.archlinux.org/bashmount.git
  $ cd bashmount && makepkg -sri

- for backuping we use kopia-ui:
  $ cd ~/Downloads/arch/
  $ git clone https://aur.archlinux.org/kopia-ui-bin.git
  $ cd bashmount && makepkg -sri
  
