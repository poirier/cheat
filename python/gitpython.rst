Gitpython
=========

More to come...

Example::


    @contextmanager
    def temporary_git_repo(url, branchname):
        """
        Context manager that clones the repo with that url
        to a temporary directory somewhere,
        checks out the branch, and returns a git.Repo object.
        Once the context is exited, it's all cleaned up.
        """
        with tempfile.TemporaryDirectory() as temp_dir_path:
            # Will be cleaned up when the context exits
            # Clone to it
            subprocess.run(["/usr/bin/env"])
            command = [
                    "git",
                    "clone",
                    "--single-branch",
                    "--branch",
                    branchname,
                    "--depth",
                    "2",
                    url,
                    temp_dir_path,
                ]
            print(" ".join(command))
            subprocess.run(
                command,
                check=True,
            )
            with git.Repo(temp_dir_path) as repo:
                yield repo
