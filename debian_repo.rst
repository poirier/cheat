Private Repository
==================

I want to experiment with creating my own, private, Debian repository,
holding only packages I've created, and accessible only by me.

The idea is to move some system administration from Ansible roles into
Debian packages. There will hopefully be some advantages:

* Performance. Determining if the latest version of a package is installed is one quick comparison. An Ansible role, on the other hand, requires checking every individual change on the system to see if it's up-to-date.

* Simplicity.  Debian comes with all the machinery for installing packages, whereas I always have to do some bootstrapping on new systems before I can really manage them with Ansible.

* Reversibility. With a properly designed Debian package, you can just uninstall/purge it and (almost) all its effects will be gone from the system. Ansible is pretty much a one-way proposition - once you've applied a role, undoing it would require either manually reversing all its steps, or writing a new role (or heavily modifying the existing one) to do so.

Do I really want to do a *Debian* repository?
---------------------------------------------

Debian repos are very complicated, both to manage the repo and to create the packages.

It might be worth looking for a simpler, alternative package manager that could co-exist on a Debian system. For example, could I use `opkg <https://openwrt.org/docs/guide-user/additional-software/opkg>`_ (sometimes known as `Entware <https://github.com/Entware/Entware/wiki>`_).

`Here's a list <https://en.wikipedia.org/wiki/List_of_software_package_management_systems>`_ of packaging systems.

Some that might be interesting:

* **opkg** looks like it's really Debian packages under the covers. Would be nice to find something simpler...

* **stow** isn't really a package manager... and yet?

* **pkgsrc** (`home page for pkgsrc <https://www.pkgsrc.org>`_) is used by e.g. NetBSD.

* `**homebrew**? <https://docs.brew.sh/Homebrew-on-Linux>`_  - sounds like a pretty complicated infrastructure would be needed to have my own "repository".

How to create and manage the repository
---------------------------------------

Creating and managing valid Debian repositories is notoriously difficult. Take a look at `this Debian wiki page about it <https://wiki.debian.org/DebianRepository/Setup>`_ and `the repository format <https://wiki.debian.org/DebianRepository/Format>`_.

I'm going to try `Aptly <https://www.aptly.info>`_, which from its web pages, looks like it'll handle a lot of the heavy lifting. I haven't yet tried it, though, so we'll see.

If Aptly is too heavy, I might try `dpkg-scanpackages and dpkg-scansources`, as mentioned on the above Debian wiki page. These are part of the `dpkg` package.


Hosting the repository
----------------------

I'd like the repository hosted somewhere it's readily accessible, and nothing else on the system to complicate things. A small VM on the internet would seem to work. E.g. a small DigitalOcean droplet, but anything along those lines should work.

For testing, we can set up an unprivileged user on the development system and put a copy of the repository there.

Keeping the repository private
------------------------------

This is not intended to be a public repository, which is what most of the on-line tutorials show you how to create.

Some tutorials mention that you can just apply auth to your web server if you want your repository to be private. That concerns me a little, though, as any mistake could easily leave the repository wide open.

From `this old Debian doc <https://web.archive.org/web/20180304192912/https://debian-administration.org/article/513/Restrict_Access_To_Your_Private_Debian_Repository>`_, though, it looks like you can use ssh access instead, with no web server at all. Ssh is secure by default.

I would need to manage ssh keys, though. Luckily, I'm happy to let any user on my managed systems access the repository; I just don't want the general public getting to it. So I should be able to put the key somewhere generally accessible on each system, and configure the host in /etc/ssh/ssh_config.d/something.conf to use that key.  Then (per the Debian doc above) I'd just use something like this in my apt sources list::

    deb ssh://repo-owner@repo.server.com:/home/repo-owner/debian/ ./

Package versions
----------------

As suggested above, I want my package versions to indicate whether a package needs to be updated on a system. That means anytime I change a package, I want its version to be higher than the previously highest version of the package.

A simplistic approach would be to just use the time of the build as the version, either in YYYYMMDDhhmmss format, or just as the Unix seconds since the epoch (better, since time zones won't matter). We can get that with `date +%s` from the shell, for example. The problem with that is that every time we rebuild our packages, we'll create another version of each package, even if the contents have not changed.

How about if we make a checksum of all the files that are going to be used to build the package, and incorporate it into the version?  Then the next time we build, we can first checksum the files and see if the current latest version has the same checksum, and if so, skip building a new version.

Here's `the doc for Debian package versions <https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-version>`_.

I think this format for package versions will work for us: "<timestamp>+<checksum>", e.g.
"1711289395+66617e19b830f63f87d8f059228a9d7c". This assumes we'll never create differing versions of the package with the same timestamp, so the fact that checksums don't really sort won't matter. We can ensure this, since we're looking at previous versions anyway, by checking that the timestamp we're about to use doesn't already exist.

Installing Aptly
----------------

On the development system::

    sudo apt install aptly

First repo
----------

Let's try creating a repo::

    $ aptly repo create test-repo-1
    Config file not found, creating default config at /home/poirier/.aptly.conf


    Local repo [test-repo-1] successfully added.
    You can run 'aptly repo add test-repo-1 ...' to add packages to repository.

Looking at /home/poirier/.aptly.conf, we see::

    "rootDir": "/home/poirier/.aptly",

and looking there::

    $ tree ~/.aptly
    /home/poirier/.aptly
    └── db
        ├── 000001.log
        ├── CURRENT
        ├── LOCK
        ├── LOG
        └── MANIFEST-000000

It looks like aptly keeps the data about the repository there, but we don't see anything that looks like a published repository.  The doc on "aptly publish repo" says we really ought to create a snapshot first, so::

    $ aptly snapshot create test-repo-1.1 from repo test-repo-1

    Snapshot test-repo-1.1 successfully created.
    You can run 'aptly publish snapshot test-repo-1.1' to publish snapshot as Debian repository.

Now we can try publishing::

      $ aptly publish snapshot test-repo-1.1
      Warning: publishing from empty source, architectures list should be complete, it can't be changed after publishing (use -architectures flag)
      ERROR: unable to publish: unable to guess distribution name, please specify explicitly

I guess we're getting ahead of ourselves.  Let's try a new repo with a distribution::

    $ aptly repo create -distribution=stable test-repo-2

    Local repo [test-repo-2] successfully added.
    You can run 'aptly repo add test-repo-2 ...' to add packages to repository.

Make a snapshot::

    $ aptly snapshot create test-repo-2.1 from repo test-repo-2

    Snapshot test-repo-2.1 successfully created.
    You can run 'aptly publish snapshot test-repo-2.1' to publish snapshot as Debian repository.

Try publishing again::

    $ aptly publish snapshot test-repo-2.1
    Warning: publishing from empty source, architectures list should be complete, it can't be changed after publishing (use -architectures flag)
    ERROR: unable to initialize GPG signer: looks like there are no keys in gpg, please create one (official manual: http://www.gnupg.org/gph/en/manual.html)

I need keys! The aptly tutorial didn't mention that, did they?... Okay, the first tutorial did (about mirroring existing repos using aptly), and the tutorial for making a private repo came later, so I guess they assumed we had already done that. Time to make keys - and first, I had to figure out on current Ubuntu where to find GnuPG v1::

    $ sudo apt install gnupg1
    ...
    $ gpg1 --gen-key
    gpg (GnuPG) 1.4.23; Copyright (C) 2015 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    Please select what kind of key you want:
       (1) RSA and RSA (default)
       (2) DSA and Elgamal
       (3) DSA (sign only)
       (4) RSA (sign only)
    Your selection?
    RSA keys may be between 1024 and 4096 bits long.
    What keysize do you want? (2048)
    Requested keysize is 2048 bits
    Please specify how long the key should be valid.
             0 = key does not expire
          <n>  = key expires in n days
          <n>w = key expires in n weeks
          <n>m = key expires in n months
          <n>y = key expires in n years
    Key is valid for? (0)
    Key does not expire at all
    Is this correct? (y/N) y

    You need a user ID to identify your key; the software constructs the user ID
    from the Real Name, Comment and Email Address in this form:
        "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

    Real name: Poirier Repositories
    Email address: repositories@poirier.us
    Comment: Signing repos
    You selected this USER-ID:
        "Poirier Repositories (Signing repos) <repositories@poirier.us>"

    Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
    You need a Passphrase to protect your secret key.

    You don't want a passphrase - this is probably a *bad* idea!
    I will do it anyway.  You can change your passphrase at any time,
    using this program with the option "--edit-key".

    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    ..+++++
    .........+++++
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    ...+++++
    ................+++++
    gpg: key 189A641A marked as ultimately trusted
    public and secret key created and signed.

    gpg: checking the trustdb
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
    pub   2048R/189A641A 2024-03-24
          Key fingerprint = CCDA 1714 75D3 312A 5B52  92F2 822F B3BF 189A 641A
    uid                  Poirier Repositories (Signing repos) <repositories@poirier.us>
    sub   2048R/B04B01AE 2024-03-24

    [10:35:35]{g:main *+}{v:cheat}poirier@ada:~/src/cheat
    $
