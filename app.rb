require 'homebus'
require 'homebus_app'
require 'snmp'
require 'mqtt'
require 'json'

class ActiveMACHomeBusApp < HomeBusApp
  def initialize(options)
    @options = options

    @manager_hostname = @options[:agent]
    @old_arp_table = []

    super
  end

  def setup!
    @manager = SNMP::Manager.new(host: options[:agent], community: options[:community_string])

    response = @manager.get(['sysDescr.0', 'sysName.0', 'sysLocation.0', 'sysUpTime.0'])
    response.each_varbind do |vb|
      @sysName = vb.value.to_s if  vb.name.to_s == 'SNMPv2-MIB::sysName.0'
      @sysDescr = vb.value.to_s if  vb.name.to_s == 'SNMPv2-MIB::sysDescr.0'
      @sysLocation = vb.value.to_s if  vb.name.to_s == 'SNMPv2-MIB::sysLocation.0'
    end
  end

  def str_to_mac(str)
    result = ''

    str.split('').each do |char|
      result += '%02x' % char.ord
    end

    result
  end

  def get_arp_table
    entries = []
    begin
      response = @manager.walk( [ '1.3.6.1.2.1.4.22.1.2' ] ) do |row|
        row.each do |vb|
          entries.push str_to_mac(vb.value)
        end
      end

    rescue
      nil
    end

    entries.sort
  end

  def work!
    arp_table = get_arp_table

    results = { id: @uuid,
                timestamp: Time.now.to_i,
                arp_table: arp_table
                }

    if @options[:verbose]
      pp results
    end

    if arp_table && arp_table != @old_arp_table
      @mqtt.publish 'homebus/device/' + @uuid,
                    JSON.generate(results),
                    true
    end

    sleep update_interval
  end

  def update_interval
    60
  end

  def manufacturer
    'HomeBus'
  end

  def model
    @sysDescr
  end

  def friendly_name
    "Active MAC addresses for #{@manager_hostname}"
  end

  def friendly_location
    @sysLocation
  end

  def serial_number
    File.read('/etc/hostname') + ' - ' + @manager_hostname
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: 'Receive bandwidth',
        friendly_location: '',
        update_frequency: 60,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ 'org.homebus.active-mac-addresses' ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
