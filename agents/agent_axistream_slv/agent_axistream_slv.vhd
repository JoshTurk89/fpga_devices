library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.logger_pkg.all;
use xil_defaultlib.agent_axistream_slv_pkg.all;
use xil_defaultlib.agent_axistream_slv_proc_pkg.all;

entity agent_axistream_slv is    
    port (
      -- AXI4-Stream Slave interface
      clk                  	: in  std_logic;
      reset_n              	: in  std_logic;
	  	axistream_clk					: in  std_logic;
      s_axis_tdata         	: in  std_logic_vector(c_axistream_data_width - 1 downto 0);
      s_axis_tvalid        	: in  std_logic;
      s_axis_tkeep         	: in  std_logic_vector((c_axistream_data_width/8) - 1 downto 0);
      s_axis_tlast         	: in  std_logic;
      s_axis_tready        	: out std_logic;
  
      -- AXI4-Stream Slave interface seq
    	sq_axistream_slv_in  	: in  sq_axistream_slv_in;
			sq_axistream_slv_out 	: out sq_axistream_slv_out;

			-- AXI4-Stream Slave Control
			sq_busy								: out std_logic
    );
end agent_axistream_slv;

  
architecture beh of agent_axistream_slv is

  signal verbose 				: boolean;
	signal rx_tready_seq 	: boolean;
	signal rx_tready 			: std_logic;
	signal update_output	: std_logic;	
  
  begin  
    
		verbose 			<= sq_axistream_slv_in.verbose;
		rx_tready 		<= sq_axistream_slv_in.rx_tready;
		rx_tready_seq <= sq_axistream_slv_in.rx_tready_seq;
		
		-- s_axis_tready <= rx_tready when rx_tready_seq = True else '1';

		sq_axistream_slv_out.rx_tdata  <= s_axis_tdata when update_output = '1' else (others => '0');

		p_sq_busy : process
		begin
			sq_busy 			<= '0';
			update_output <= '0';
			wait until rising_edge(s_axis_tvalid); --and rising_edge(s_axis_tready);
			sq_busy 			<= '1';
			update_output <= '1';
			wait until falling_edge(s_axis_tvalid) or falling_edge(s_axis_tready);	
		end process p_sq_busy;

  end architecture beh;
  ---------------------------------------------------------------------------------