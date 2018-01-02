Running Ansible tasks in the background
=======================================

Example::

    - name: start collectstatic in the background
      command: "{{ install_root }}/env/bin/python manage.py collectstatic --noinput -v 0"
      args:
        chdir: "{{ install_root }}/webapp"
      async: 1000
      poll: 0
      register: collectstatic_bg

    ################################################################################
    #
    # PUT TASKS HERE THAT DON'T NEED TO BE RUN BEFORE COLLECTSTATIC CAN START,
    # AND THAT WON'T AFFECT THE BACKGROUND COLLECTSTATIC.
    #
    ################################################################################
    - name: clean up local tarball
      delegate_to: 127.0.0.1   # Run on localhost
      run_once: yes            # only once
      become: no               # Don't need sudo
      file:
        state: absent
        path: "{{ tarball }}"

    - name: migrate
      command: "{{ install_root }}/env/bin/python manage.py migrate --noinput"
      args:
        chdir: "{{ install_root }}/webapp"

    - name: install tasks
      command: "{{ install_root }}/env/bin/python manage.py installtasks --traceback"
      args:
        chdir: "{{ install_root }}/webapp"

    ################################################################################
    #
    # Check every 'delay' seconds, up to 'retries' times, until collectstatic is done
    #
    ################################################################################
    - name: wait for collectstatic to finish
      async_status: jid={{ collectstatic_bg.ansible_job_id }}
      register: job_result
      until: job_result.finished
      retries: 80
      delay: 15

    ################################################################################
    #
    # PUT TASKS AFTER THIS THAT CAN'T RUN UNTIL COLLECTSTATIC IS DONE
    #
    ################################################################################
