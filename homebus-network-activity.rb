#!/usr/bin/env ruby

require './options'
require './app'

snmp_app_options = ActiveMACHomeBusAppOptions.new

snmp = ActiveMACHomeBusApp.new snmp_app_options.options
snmp.run!
