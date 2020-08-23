Systemd
=======

Unit search paths
-----------------

https://www.freedesktop.org/software/systemd/man/systemd.unit.html

System Unit Search Path::

        /etc/systemd/system.control/*
        /run/systemd/system.control/*
        /run/systemd/transient/*
        /run/systemd/generator.early/*
        /etc/systemd/system/*
        /etc/systemd/systemd.attached/*
        /run/systemd/system/*
        /run/systemd/systemd.attached/*
        /run/systemd/generator/*
        …
        /usr/lib/systemd/system/*
        /run/systemd/generator.late/*

User Unit Search Path::

        ~/.config/systemd/user.control/*
        $XDG_RUNTIME_DIR/systemd/user.control/*
        $XDG_RUNTIME_DIR/systemd/transient/*
        $XDG_RUNTIME_DIR/systemd/generator.early/*
        ~/.config/systemd/user/*
        /etc/systemd/user/*
        $XDG_RUNTIME_DIR/systemd/user/*
        /run/systemd/user/*
        $XDG_RUNTIME_DIR/systemd/generator/*
        ~/.local/share/systemd/user/*
        …
        /usr/lib/systemd/user/*
        $XDG_RUNTIME_DIR/systemd/generator.late/*

