NVM and NPM
===========

NPM
---

Install exact packages & versions from package.json and package-log.json
cleanly::

    $ npm ci

Just note that `npm ci` deletes node_modules before starting.
But it's *fast*!

Back-level your npm::

    $ which npm

to make sure you're running npm from an nvm version, then::

    $ npm install -g npm@5.10.0
    $ npm version
    ...

Make `npm install` less noisy::

     npm config set loglevel warn

or add this to ~/.npmrc::

    loglevel=warn

`source <http://eclips3.net/2014/07/02/how-to-make-npm-less-noisy/>`_.

NVM
---

Use another node version::

    $ nvm use 8
    $ nvm use 10

etc.

