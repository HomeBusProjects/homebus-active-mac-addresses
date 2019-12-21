require 'homebus_app_options'

class ActiveMACHomeBusAppOptions < HomeBusAppOptions
  def app_options(op)
    agent_help     = 'the SNMP agent IP address or name'
    community_help = 'the SNMP community string'

    op.separator 'SNMP options:'
    op.on('-a', '--agent SNMP_AGENT', agent_help) { |value| options[:agent] = value }
    op.on('-c', '--community SNMP_COMMUNITY_STRING', community_help) { |value| options[:community] = value }
    op.separator ''
  end

  def banner
    'Homebus Active MAC Addresses Publisher'
  end

  def version
    '0.0.1'
  end

  def name
    'homebus-active-mac-addresses'
  end
end
