#!/bin/bash

curl -X POST https://10.202.0.174:9200/api/fleet/package_policies -H "Content-Type: application/json" -d '{
  "policy_id": "0abeb500-9457-11ee-b865-cd9e175926f0",
  "package": {
    "name": "windows",
    "version": "1.43.0"
  },
  "name": "windows-1",
  "description": "",
  "namespace": "default",
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
            "tags": ["forwarded"]
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
            "perfmon.queries": "- object: 'Processn  instance: \"\"n  countersn   - name: '% Processor Timen     field: cpu_pern     format:\"floan   - name:\"Working Sen",
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
        "ssl": "#certificate_authoritiesn#  - n#    -----BEGIN CERTIFICATE----n#    MIIDCjCCAfKgAwIBAgITJ706Mu2wJlKckpIvkWxEHvEyijANBgkqhkiG9w0BAQsn#    ADAUMRIwEAYDVQQDDAlsb2NhbGhvc3QwIBcNMTkwNzIyMTkyOTA0WhgPMjExOTAn#    MjgxOTI5MDRaMBQxEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEn#    BQADggEPADCCAQoCggEBANce58Y/JykI58iyOXpxGfw0/gMvF0hUQAcUrSMxEO6n#    fZRA49b4OV4SwWmA3395uL2eB2NB8y8qdQ9muXUdPBWE4l9rMZ6gmfu90N5B5uEn#    94NcfBfYOKi1fJQ9i7WKhTjlRkMCgBkWPkUokvBZFRt8RtF7zI77BSEorHGQCk9n#    /D7BS0GJyfVEhftbWcFEAG3VRcoMhF7kUzYwp+qESoriFRYLeDWv68ZOvG7eoWnn#    PsvZStEVEimjvK5NSESEQa9xWyJOmlOKXhkdymtcUd/nXnx6UTCFgnkgzSdTWV4n#    CI6B6aJ9svCTI2QuoIq2HxX/ix7OvW1huVmcyHVxyUECAwEAAaNTMFEwHQYDVR0n#    BBYEFPwN1OceFGm9v6ux8G+DZ3TUDYxqMB8GA1UdIwQYMBaAFPwN1OceFGm9v6un#    8G+DZ3TUDYxqMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAG5n#    874A4YI7YUwOVsVAdbWtgp1d0zKcPRR+r2OdSbTAV5/gcS3jgBJ3i1BN34JuDVFn#    3DeJSYT3nxy2Y56lLnxDeF8CUTUtVQx3CuGkRg1ouGAHpO/6OqOhwLLorEmxi7tn#    H2O8mtT0poX5AnOAhzVy7QW0D/k4WaoLyckM5hUa6RtvgvLxOwA0U+VGurCDoctn#    8F4QOgTAWyh8EZIwaKCliFRSynDpv3JTUwtfZkxo6K6nce1RhCWFAsMvDZL8Dgcn#    yvgJ38BRsFOtkRuAGSf6ZUwTO8JJRRIFnpUzXflAnGivK9M13D5GEQMmIl6U9Pvn#    sxSmbIUfc2SGJGCJD4In#    -----END CERTIFICATE----n"
      },
      "streams": {
        "windows.applocker_exe_and_dll": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/EXE and DL\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.applocker_msi_and_script": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/MSI and Scrip\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.applocker_packaged_app_deployment": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/Packaged app-Deploymen\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.applocker_packaged_app_execution": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-AppLocker/Packaged app-Executio\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.forwarded": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:ForwardedEvent\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.powershell": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Windows PowerShell\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.powershell_operational": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-Powershell/Operationa\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        },
        "windows.sysmon_operational": {
          "enabled": false,
          "vars": {
            "interval": "10s",
            "search": "search sourcetype=\"XmlWinEventLog:Microsoft-Windows-Sysmon/Operationa\"",
            "tags": ["forwarded"],
            "preserve_original_event": false
          }
        }
      }
    }
  }
}'


# Set Fleet-Server :


{
  "item" : {
    "host_urls" : ["https://@IP:8220"],
    "is_preconfigured" : true,
    "name" : "Fleet-server",
    "is_default" : true
  }
}

# Set Output : 



# Get enrollement token : 

/api/fleet/enrollment_api_keys