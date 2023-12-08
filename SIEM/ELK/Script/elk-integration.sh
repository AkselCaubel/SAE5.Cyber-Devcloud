#!/bin/bash

# Intégration Windows

curl --cacert ./ca.crt -k -u elastic:kWN9-srZt1fiYERiOJVk -X POST \
  --url 'https://10.202.0.174:5601/api/fleet/package_policies' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'kbn-version: 8.9.0' \
  -d '
{
  "package": {
    "name": "windows",
    "version": "1.43.0"
  },
  "name": "windows-1",
  "namespace": "default",
  "description": "",
  "policy_id": "0abeb500-9457-11ee-b865-cd9e175926f0",
  "vars": {},
  "inputs": {
    "windows-winlog": {
      "enabled": true,
      "streams": {
        "windows.applocker_exe_and_dll": {
          "enabled": false,
          "vars": {
            "preserve_original_event": false,
            "event_id": null,
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        },
        "windows.applocker_msi_and_script": {
          "enabled": false,
          "vars": {
            "preserve_original_event": false,
            "event_id": null,
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        },
        "windows.applocker_packaged_app_deployment": {
          "enabled": false,
          "vars": {
            "preserve_original_event": false,
            "event_id": null,
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        },
        "windows.applocker_packaged_app_execution": {
          "enabled": false,
          "vars": {
            "preserve_original_event": false,
            "event_id": null,
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        },
        "windows.forwarded": {
          "enabled": true,
          "vars": {
            "preserve_original_event": false,
            "ignore_older": "72h",
            "language": 0,
            "tags": [
              "forwarded"
            ]
          }
        },
        "windows.powershell": {
          "enabled": true,
          "vars": {
            "preserve_original_event": false,
            "event_id": "400, 403, 600, 800",
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        },
        "windows.powershell_operational": {
          "enabled": true,
          "vars": {
            "preserve_original_event": false,
            "event_id": "4103, 4104, 4105, 4106",
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        },
        "windows.sysmon_operational": {
          "enabled": true,
          "vars": {
            "preserve_original_event": false,
            "ignore_older": "72h",
            "language": 0,
            "tags": []
          }
        }
      }
    },
    "windows-windows/metrics": {
      "enabled": true,
      "streams": {
        "windows.perfmon": {
          "enabled": true,
          "vars": {
            "perfmon.group_measurements_by_instance": false,
            "perfmon.ignore_non_existent_counters": false,
            "perfmon.refresh_wildcard_counters": false,
            "period": "10s"
          }
        },
        "windows.service": {
          "enabled": true,
          "vars": {
            "period": "60s"
          }
        }
      }
    },
    "windows-httpjson": {
      "enabled": false,
      "vars": {
        "url": "https://server.example.com:8089",
        "ssl": "#certificate_authorities:\n#  - |\n#    -----BEGIN CERTIFICATE-----\n#    MIIDCjCCAfKgAwIBAgITJ706Mu2wJlKckpIvkWxEHvEyijANBgkqhkiG9w0BAQsF\n#    ADAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwIBcNMTkwNzIyMTkyOTA0WhgPMjExOTA2\n#    MjgxOTI5MDRaMBQxEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEB\n#    BQADggEPADCCAQoCggEBANce58Y/JykI58iyOXpxGfw0/gMvF0hUQAcUrSMxEO6n\n#    fZRA49b4OV4SwWmA3395uL2eB2NB8y8qdQ9muXUdPBWE4l9rMZ6gmfu90N5B5uEl\n#    94NcfBfYOKi1fJQ9i7WKhTjlRkMCgBkWPkUokvBZFRt8RtF7zI77BSEorHGQCk9t\n#    /D7BS0GJyfVEhftbWcFEAG3VRcoMhF7kUzYwp+qESoriFRYLeDWv68ZOvG7eoWnP\n#    PsvZStEVEimjvK5NSESEQa9xWyJOmlOKXhkdymtcUd/nXnx6UTCFgnkgzSdTWV41\n#    CI6B6aJ9svCTI2QuoIq2HxX/ix7OvW1huVmcyHVxyUECAwEAAaNTMFEwHQYDVR0O\n#    BBYEFPwN1OceFGm9v6ux8G+DZ3TUDYxqMB8GA1UdIwQYMBaAFPwN1OceFGm9v6ux\n#    8G+DZ3TUDYxqMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAG5D\n#    874A4YI7YUwOVsVAdbWtgp1d0zKcPRR+r2OdSbTAV5/gcS3jgBJ3i1BN34JuDVFw\n#    3DeJSYT3nxy2Y56lLnxDeF8CUTUtVQx3CuGkRg1ouGAHpO/6OqOhwLLorEmxi7tA\n#    H2O8mtT0poX5AnOAhzVy7QW0D/k4WaoLyckM5hUa6RtvgvLxOwA0U+VGurCDoctu\n#    8F4QOgTAWyh8EZIwaKCliFRSynDpv3JTUwtfZkxo6K6nce1RhCWFAsMvDZL8Dgc0\n#    yvgJ38BRsFOtkRuAGSf6ZUwTO8JJRRIFnpUzXflAnGivK9M13D5GEQMmIl6U9Pvk\n#    sxSmbIUfc2SGJGCJD4I=\n#    -----END CERTIFICATE-----\n"
      },
      "streams": {
        "windows.applocker_exe_and_dll": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/EXE and DLL\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.applocker_msi_and_script": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/MSI and Script\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.applocker_packaged_app_deployment": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/Packaged app-Deployment\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.applocker_packaged_app_execution": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/Packaged app-Execution\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.forwarded": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:ForwardedEvents\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.powershell": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Windows PowerShell\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.powershell_operational": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-Powershell/Operational\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        },
        "windows.sysmon_operational": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-Sysmon/Operational\"",
            "tags": [
              "forwarded"
            ],
            "preserve_original_event": false
          }
        }
      }
    }
  }
}'


# Intégration Elastic-Defend

curl --cacert ./ca.crt -k -u elastic:kWN9-srZt1fiYERiOJVk -X POST \
  --url 'https://10.202.0.174:5601/api/fleet/package_policies' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'kbn-version: 8.9.0' \
  -d \
'
{
  "name": "Protect",
  "description": "",
  "namespace": "default",
  "policy_id": "0abeb500-9457-11ee-b865-cd9e175926f0", 
  "enabled": true,
  "inputs": [
    {
      "enabled": true,
      "streams": [],
      "type": "ENDPOINT_INTEGRATION_CONFIG",
      "config": {
        "_config": {
          "value": {
            "type": "endpoint",
            "endpointConfig": {
              "preset": "EDRComplete",
              "tls": {
                "verify_peer": false,
                "verify_hostname": false,
                "ca_cert": false
              }
            }
          }
        }
      }
    }
  ],
  "package": {
    "name": "endpoint",
    "title": "Elastic Defend",
    "version": "8.11.0" 
  }
}'

# Set Fleet-Server :


# {
#   "item" : {
#     "host_urls" : ["https://@IP:8220"],
#     "is_preconfigured" : true,
#     "name" : "Fleet-server",
#     "is_default" : true
#   }
# }

# Set Output : 



# Get enrollement token : 

#/api/fleet/enrollment_api_keys