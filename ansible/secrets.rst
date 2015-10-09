Secrets
=======

Ansible handles secrets using a feature called
`Vault <https://docs.ansible.com/ansible/playbooks_vault.html>`_.

Vault lets you encrypt any of your ``.yml`` files, but typically
you'd apply it to files containing variable definitions, then
use the variables' values as needed elsewhere.

Vault provides subcommands that let you encrypt a file in place,
decrypt a file in place, edit a file that's encrypted in one step,
etc.

When ansible is running your playbook or whatever, any time it comes
across a .yml file that appears to be encrypted, it will decrypt it
(in memory) and use the decrypted contents, fairly transparently. You
can have as many of your files encrypted as you want.

However, all the encrypted files have to use the same password.

Providing the password to Ansible
---------------------------------

#) Have Ansible prompt for it by passing ``--ask-vault-pass``.  Most
   secure, but inconvenient.
#) Put it plaintext in a well-protected file, and pass
   ``--vault-password-file <filename>``.  Most insecure, but
   more convenient than the prompt.
#) Write a script or program that outputs the password on stdout, mark
   it executable, and pass that: ``--vault-password-file <path-to-program>``.
   This makes it possible to use a local system keychain or something, which
   might be more secure than the other options.  Or worse...

Ways to use it
--------------

One approach I've used is to have a single encrypted ``secrets.yml`` file in my
base directory containing all my secret variables, and another file with very
restrictive permissions (and outside of source control) containing my password,
then add these arguments when running ansible::

    --extra-vars @secrets.yml --vault-password-file path/to/passfile

The advantage of that is that if I don't need the secrets, I can leave all
that off and Ansible will run fine. (As opposed to having the encrypted file
automatically read by Ansible every time.)

I'm not sure if that will scale, though.

Limitations
-----------

* This is symmetric encryption. In other words, anyone with the password
  can encrypt and decrypt a file.
* All the encrypted files must be encrypted using the same password.
* That means you have to protect the decrypting password (the only password)
  very carefully, and makes providing it to Ansible awkward.

Links:

* `Vault <https://docs.ansible.com/ansible/playbooks_vault.html>`_
* `Not logging secrets <https://docs.ansible.com/ansible/faq.html#how-do-i-keep-secret-data-in-my-playbook>`_
* `How to upload encrypted file using ansible vault? <https://stackoverflow.com/questions/22773294/how-to-upload-encrypted-file-using-ansible-vault>`_
* `Managing Secrets with Ansible Vault – The Missing Guide (Part 1 of 2) <https://dantehranian.wordpress.com/2015/07/24/managing-secrets-with-ansible-vault-the-missing-guide-part-1-of-2/>`_
* `Managing Secrets with Ansible Vault – The Missing Guide (Part 2 of 2) <https://dantehranian.wordpress.com/2015/07/24/managing-secrets-with-ansible-vault-the-missing-guide-part-2-of-2/>`_
