# local-dev

This repository contains everything needed to run or add local services.

## Setup guide

* Clone the github project
* Navigate to the project directory
* Run `bin/install-dependencies.sh` and follow the instructions, provide sudo password when asked.

## Usage guide

* Start/stop the desired services locally using the cage tool:
* View the logs for a service by running `cage logs service-name`

## Frequent issues

* Error `Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock:` is shown when running `cage` or `docker` after running `./bin/install-dependencies.sh`
    * logout and login to refresh group membership for your local user
* Be sure to take into account the dependencies between the services when starting them. For example *componentA* and *componentB* services won't start without the db container up and running.
* For more cage commands and options try using `cage -h`

## URL to your local-dev

If you want a public URL to your local-dev, you need to use tunneling. This allows testing your local-dev version from a different device.

First download and unzip [ngrok](https://ngrok.com/download) in your local-dev folder.

Next sign up and authenticate it:

```
./ngrok authtoken <YOUR_AUTH_TOKEN>
```

Then, edit and append to the config file (`~/.ngrok2/ngrok.yml` on linux, see output of `authtoken` command):

```yml
tunnels:
  front:
    proto: http
    addr: 3002
    bind_tls: true
  gateway:
    proto: http
    addr: 8095
    bind_tls: true
```

Next you can tunnel all 3 ports by running this in a separate terminal from your local-dev folder:
```
./ngrok start front gateway
```

Take URLs from ngrok for gateway (8095) and modify your `pods/front.yml` config to temporarily change `WEB_SOCKETS_URL`.

For example, if your ngrok output is this:

```
Forwarding                    https://16223fd6.ngrok.io -> localhost:3002
Forwarding                    https://4793bbd8.ngrok.io -> localhost:8095
Forwarding                    https://672e0e65.ngrok.io -> localhost:9101
```

You need to temporarily modify `pods/front.yml` like so:

```yml
    environment:
      WEB_SOCKETS_URL: https://4793bbd8.ngrok.io
```

Stop and start again the front component to load the new config:

```
cage stop front
cage up front
```

Now access the front URL from ngrok (3002), https://16223fd6.ngrok.io in our example.

Note: if you are running the front app locally, you should change `ngrok.yml` to use port 3000 instead of 3002.

## Future development

* In order to add a new service, a new .yml file needs to be added to the pods directory. The file should contain the configuration for the new service.
* To create a new database (possibly for a new service) one should edit the db creation script (*pods/scripts/create-db.sh*).
