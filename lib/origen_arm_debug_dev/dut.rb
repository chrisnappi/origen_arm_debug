module OrigenARMDebugDev
  # This is a dummy DUT model which is used
  # to instantiate and test the ARMDebug locally
  # during development.
  #
  # It is not included when this library is imported.
  class DUT
    include Origen::TopLevel
    include OrigenARMDebug

    # Initializes simple dut model with test register and required jtag/swd pins
    #
    # @example
    #   $dut = OrigenARMDebugDev::DUT.new
    #
    def initialize(options = {})
      add_reg :test, 0

      reg :test2, 0 do |reg|
        reg.bit 31, :msb
        reg.bit 30..1, :data
        reg.bit 0, :lsb
      end
    end

    # Add any custom startup business here.
    #
    # @param [Hash] options Options to customize the operation
    def startup(options)
      tester.set_timeset('arm_debug', 40)
    end

    # Read data from a register
    #
    # @param [Register] reg Register name or address value
    # @param [Hash] options Options to customize the operation
    def read_register(reg, options = {})
      arm_debug.mem_ap.read_register(reg, options)
    end

    # Write data to a register
    #
    # @param [Register] reg Register name or address value
    # @param [Hash] options Options to customize the operation
    def write_register(reg, options = {})
      arm_debug.mem_ap.write_register(reg, options)
    end
  end
end
