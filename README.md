# homebus-active-mac-addresses

This is a simple HomeBus data source which publishes weather conditions from AirNow

## Usage

On its first run, `homebus-active-mac-addresses` needs to know how to find the HomeBus provisioning server.

```
bundle exec homebus-active-mac-addresses -z zipcode -b homebus-server-IP-or-domain-name -P homebus-server-port
```

The port will usually be 80 (its default value).

Once it's provisioned it stores its provisioning information in `.env.provisioning`.

`homebus-active-mac-addresses` also needs to know:

- the SNMP agent to be monitored
- the SNMP agent's community string

