Reading YAML files with vault encrypted values
=================================================

If you're outside of Ansible and want to read an Ansible YAML
file that has some individually encrypted values, the default
YAML loader will fail because it doesn't know what to do with
"!vault".  You can add something like this to your code to
at least be able to use the unencrypted parts::

    import yaml

    # DUMMY implementation of !vault so we can read YAML files with
    # encrypted values. (Does NOT decrypt them, just makes YAML not
    # barf when it runs into them.)
    class EncryptedValue:
        def __init__(self, encrypted_value):
            self.encrypted_value = encrypted_value


    def vault_representer(dumper, data):
        return dumper.represent_scalar("!vault", str(data.encrypted_value))

    def vault_constructor(loader, node):
        value = loader.construct_scalar(node)
        return EncryptedValue(value)


    yaml.add_representer(EncryptedValue, vault_representer)
    yaml.add_constructor("!vault", vault_constructor)
