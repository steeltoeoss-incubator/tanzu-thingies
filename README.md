# Tanzu Toolkit

Help with the install and setup of Tanzu thingies.

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

## See Available Thingies

Run `./setup.sh -l` to see available thingies.

```
$ ./setup.sh -l
application-platform-configure   Tanzu Application Platform (Configure
...
```

## Setup a Thingy

Run `./setup.sh <THINGY>`.

```
$ ./setup.sh application-platform
```
