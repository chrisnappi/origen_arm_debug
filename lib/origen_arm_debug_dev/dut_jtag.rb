module OrigenARMDebugDev
  # Simple JTAG-specific dut model that inherits from protocol-agnostic DUT model
  class JTAG_DUT < DUT
    include OrigenJTAG

    # Adds jtag-required pins to the simple dut model
    # Returns nothing.
    def initialize(options = {})
      super
      add_pin :tclk
      add_pin :tdi
      add_pin :tdo
      add_pin :tms
      add_pin :trst
      add_pin :swd_clk
      add_pin :swd_dio

      options[:class_name] = 'OrigenARMDebug::DAP'
      options[:mem_aps] = {
        mem_ap: {
          base_address:      0x00000000,
          latency:           16,
          apreg_access_wait: 8,
          apmem_access_wait: 8,
          csw_reset:         0x23000040
        },
        mdm_ap: 0x01000000
      }
      # Specify (customize) ARM Debug implementation details
      sub_block :arm_debug, options
    end
  end
end
