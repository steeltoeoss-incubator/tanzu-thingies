# Tanzu Toolkit

Tools to help with the install and setup of Tanzu products.

## Credential Setup

Create a credentials file and edit with your credentials.

```
$ cp share/examples/credentials.sh etc/credentials.sh
$ $EDITOR etc/credentials.sh
```

Alternatively, you can define the credential environment variables in your shell.

```
export TANZUNET_CREDENTIALS=<USERNAME>:<PASSWORD>
...
```

## See Available Tools

Run `bin/setup.sh -l` to see available tools.

```
$ bin/setup.sh -l
application-platform-configure   Tanzu Application Platform (Configure
...
```

## Setup a Tool

Run `bin/setup.sh <TOOL>`.

```
$ bin/setup.sh application-platform
```
