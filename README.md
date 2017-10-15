# datadog-screenboard-manager
untill datadog screenboard function for Terraform release

following flow on multi datadog enviroments.
```
show -> pull -> edit screenboard on local -> diff -> push
```

- diff screenboard before update.
- create logging current remote status before update.

## set up

```
pip install datadog
```

... and fit .gitignore file.

## usage

```
Usage: ./screenboard-manager.sh -m \$MODE -e \$ENV -i \$ID

MODE:
    show   : show current remote screen status
    pull   : update local screen status file (./status/)
    diff   : diff for between local and remote
    update : update remote screen with local current screen status
ENV:
    test-prd or test-stg or ...
ID:
    screen board id : screen board id which you want to operate
    ex) 230368
    https://app.datadoghq.com/screen/230368/s-screenboard-xxxxxxxxxxxx
ex)
    ./screenboard-manager.sh show -e test-prd -i 230368
```
