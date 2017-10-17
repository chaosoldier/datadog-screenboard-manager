# datadog-screenboard-manager
It is limited untill datadog screenboard function for Terraform is released

I assume the following flow.
```
show -> pull -> edit screenboard on local -> diff -> push
```

- diff screenboard before update.
- create logging current remote status before update.

note

- NOT support Template variables.
- NOT support S3 upload yet.

## set up

```
pip install datadog
```

create ./config/.dogrc_YOUR_ENV file

```
[Connection]
apikey = XXXX
appkey = XXXXXXXX
```
... and fix .gitignore file, if you needs.

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


```
├── README.md
├── config
│   └── .dogrc_YOUR_ENV 
├── log # create json log when you update sreenboard.
│   └── YOUR_ENV
│       └── 230405
│           ├── update-20171015_15-55-12.json
│           └── update-20171015_16-53-25.json
├── screenboard-manager.sh
└── status
    └── YOUR_ENV
        └── 230405.json
```
