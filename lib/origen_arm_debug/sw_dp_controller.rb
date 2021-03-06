module OrigenARMDebug
  class SW_DPController
    include Origen::Controller
    include Helpers
    include DPController

    def write_register(reg, options = {})
      unless reg.writable?
        fail "The :#{reg.name} register is not writeable!"
      end

      if reg.owner == model
        log "Write SW-DP register #{reg.name.to_s.upcase}: #{reg.data.to_hex}" do
          dut.swd.write_dp(reg)
        end
      else
        unless reg.owner.is_a?(AP)
          fail 'The SW-DP can only write to DP or AP registers!'
        end

        select_ap_reg(reg)
        dut.swd.write_ap(reg, options)
      end
    end

    def read_register(reg, options = {})
      unless reg.readable?
        fail "The :#{reg.name} register is not readable!"
      end

      if reg.owner == model
        log "Read SW-DP register #{reg.name.to_s.upcase}: #{Origen::Utility.read_hex(reg)}" do
          dut.swd.read_dp(reg)
        end
      else
        unless reg.owner.is_a?(AP)
          fail 'The SW-DP can only write to DP or AP registers!'
        end

        select_ap_reg(reg)
        dut.swd.read_ap(address: reg.address)

        # Add any extra delay needed in between selecting the AP state, initiating and completing a dummy read, and
        # starting the actual read.
        if options[:apacc_wait_states]
          options[:apacc_wait_states].cycles
        end

        dut.swd.read_dp(reg, options.merge(address: rdbuff.address))
      end
    end
  end
end
