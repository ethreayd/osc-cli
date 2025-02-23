# Outscale CLI

Official Outscale CLI providing connectors to Outscale API.

[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

## Getting Started

### Prerequisites

You will need [Python 3.5+](https://www.python.org/) or later. Earlier versions including Python 2 are not supported.

### Installing from package

You can get the package from [pypi](https://pypi.org/project/osc-sdk/):
```
pip3 install osc-sdk
```

If you are using Microsoft Windows, see [how to setup osc-cli on Windows](windows-setup.md).

### Installing from sources

It is a good practice to create a [dedicated virtualenv](https://virtualenv.pypa.io/en/latest/) first. Even if it usually won't harm to install Python libraries directly on the system, better to contain dependencies in a virtual environment.

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Then install osc-cli in your virtual env:
```bash
pip install -e .
```

## Configure osc-cli

The CLI requires a configuration file in `~/.osc/config.json` The content must be a JSON whose contents look like this:
/!\ the old configuration path using `.osc_sdk` folder is **deprecated**. Please use the new one with `.osc`.
```json
{"default":
    {"access_key": "MYACCESSKEY",
     "secret_key": "MYSECRETKEY",
     "host": "outscale.com",
     "https": true,
     "method": "POST",
     "region_name": "eu-west-2"
    },
  "us":
    {"access_key": "MYACCESSKEY",
     "secret_key": "MYSECRETKEY",
     "host": "outscale.com",
     "https": true,
     "method": "POST",
     "region_name": "us-east-2"
    }
}
```
You can add several profiles for different regions or users.

Optional parameters can be applied to each profile :
* client_certificate: if you need additional security, your pem must include your private key and your certificate
* version: if you want to query another version of the API

```json
{"default":
    {"access_key": "MYACCESSKEY",
     "secret_key": "MYSECRETKEY",
     "client_certificate" : "path_to_your_pem",
     "host": "outscale.com",
     "https": true,
     "method": "POST",
     "region_name": "eu-west-2",
     "version": "2018-11-19"
    }
}
```

## Usage

```
osc-cli SERVICE CALL [PROFILE] [CALL-PARAMETERS]
```
or
```
osc-cli --service SERVICE --call CALL [PROFILE] [--CALL_PARAMS ...]
```
with
* SERVICE one of the services provided by Outscale (api, fcu, lbu, eim, directconnect, icu)
* CALL the call you request (ie ReadVms, DescribeInstances...)
* PROFILE the profile you want to connect to (optional)
* CALL_PARAMS call arguments which are case-sensitive (optional)

You can find the `fcu`, `lbu`, `icu`, `eim`, `directlink`, `okms`, `oos` and `api` descriptions on [docs.outscale.com](http://docs.outscale.com).


Here is an example of a simple volume creation:
```bash
osc-cli fcu CreateVolume --AvailabilityZone eu-west-2a --Size 10
{
    "CreateVolumeResponse": {
        "@xmlns": "http://ec2.amazonaws.com/doc/2014-06-15/",
        "requestId": "508f428a-9fd8-4a49-9fe6-d0bf311de3b4",
        "volumeId": "vol-6a2aa442",
        "size": "10",
        "snapshotId": null,
        "availabilityZone": "eu-west-2a",
        "status": "creating",
        "createTime": "2019-01-17T12:53:57.836Z",
        "volumeType": "standard"
    }
}
```

Be careful with your quotes ! If you want to pass the string `"12345678"` rather than the integer `12345678` you'll need to quote your quotes:
```bash
$ osc-cli icu CreateAccount --Email "example@email.com" \
			    --FirstName "Osc" \
			    --LastName "Cli" \
			    --Password "12345toto" \
			    --ZipCode '"92000"' \
			    --Country "France" \
			    --CustomerId '"12345678"'
```

Another example with an array of strings into args:
```bash
$ osc-cli api CreateDhcpOptions --DomainName="toot.toot" \
				--DomainNameServers="['1.1.1.1']" \
				--NtpServers="['1.1.1.1']"
```

Example with a complex structure:
```bash
osc-cli icu CreateListenerRule \
--Instances '[{"InstanceId": "i-12345678"}]' \
--ListenerDescription '{"LoadBalancerName": "osc", "LoadBalancerPort": 80}'
--ListenerRuleDescription '{"RuleName": "hello", "Priority": 100, "PathPattern": "/"}'
```

**Argument Parsing**
```bash
$ osc-cli api example --obj=[1,2]    	# list
$ osc-cli api example --obj=10		# int
$ osc-cli api example --obj="10"	# int
$ osc-cli api example --obj="'10'"	# str
$ osc-cli api example --obj=\"10\"	# str

$ osc-cli api example --obj="hello"	# str
$ osc-cli api example --obj=hello	# str
```
**Warning** if you're adding a list which contain strings with specifics characteres, there is a workaround:
```bash
$ osc-cli api example --obj="['vol-12345678', 'vol-87654322']"    	# list
```

## Authentication

You API crendentials are composed of an Access Key and a Secret Key located in `.osc_sdk/config.json`.
You can list you access keys using your user and password:
```bash
osc-cli icu ListAccessKeys --authentication-method=password --login youremail@company.com --password=Y0URpAssOrd
```
## Contributing
OSC-CLI is an **open source software** licensed under **BSD-3-Clause.**

Patches and discussions are welcome about bugs you've found or features you think are missing. If you would like to help making **osc-cli** better, take a look to [CONTRIBUTING.md](https://github.com/outscale/osc-cli/blob/master/CONTRIBUTING.md) file.
