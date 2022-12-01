library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity memoria is

	port (
		
		-- input ports
		address, data_in : in std_logic_vector(7 downto 0);
		w, reset, clock : in std_logic;
		port_in_0,
		port_in_1,
		port_in_2,
		port_in_3,
		port_in_4,
		port_in_5,
		port_in_6,
		port_in_7,
		port_in_8,
		port_in_9,
		port_in_10,
		port_in_11,
		port_in_12,
		port_in_13,
		port_in_14,
		port_in_15 : in std_logic_vector(7 downto 0);
		
		-- output ports
		port_out_0,
		port_out_1,
		port_out_2,
		port_out_3,
		port_out_4,
		port_out_5,
		port_out_6,
		port_out_7,
		port_out_8,
		port_out_9,
		port_out_10,
		port_out_11,
		port_out_12,
		port_out_13,
		port_out_14,
		port_out_15 : out std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0)
		
	);
	
end memoria;


-- rom 
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity rom is 
	
	port (
	
		-- input ports
		address : in std_logic_vector(7 downto 0);
		clock : in std_logic;
		rom_data_out : out std_logic_vector(7 downto 0)
	
	);

end rom;

architecture structure of rom is 

		constant LDA_IMM : std_logic_vector (7 downto 0) := x"86";
		constant LDA_DIR : std_logic_vector (7 downto 0) := x"87";
		constant LDB_IMM : std_logic_vector (7 downto 0) := x"88";
		constant LDB_DIR : std_logic_vector (7 downto 0) := x"89";
		constant STA_DIR : std_logic_vector (7 downto 0) := x"96";
		constant STB_DIR : std_logic_vector (7 downto 0) := x"97";
		constant ADD_AB : std_logic_vector (7 downto 0) := x"42";
		constant BRA : std_logic_vector (7 downto 0) := x"20";
		constant BEQ : std_logic_vector (7 downto 0) := x"23";
		
		type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);
		constant ROM : rom_type := (0 => LDA_IMM,
			1 => x"AA",
			2 => STA_DIR,
			3 => x"E0",
			4 => BRA,
			5 => x"00",
		others => x"00");

		signal EN : std_logic; 
		
	begin
		
		enable : process (address)
		begin
			if ((to_integer(unsigned(address)) >= 0) and (to_integer(unsigned(address)) <= 127)) then
				EN <= '1';
			else
				EN <= '0';
			end if;
		end process;
		
		memory : process (clock)
		begin
			if (clock'event and clock='1') then
				if (EN='1') then
					rom_data_out <= ROM(to_integer(unsigned(address)));
				end if;
			end if;
		end process;
	
end structure;


-- rw 
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity rw is 
	
	port (
	
		
		w, clock : in std_logic;
		rw_data_out : out std_logic_vector(7 downto 0);
		address, data_in : in std_logic_vector(7 downto 0)
	
	);

end rw;

architecture structure of rw is

	type rw_type is array (128 to 223) of std_logic_vector(7 downto 0);
	signal RW : rw_type;
	signal EN : std_logic;

	begin
	
		enable : process (address)
		begin
			if ((to_integer(unsigned(address)) >= 128) and (to_integer(unsigned(address)) <= 223)) then
				EN <= '1';
			else
				EN <= '0';
			end if;
		end process;
		
		memory : process (clock)
		begin
			if (clock'event and clock='1') then
				if (EN='1' and w='1') then
					RW(to_integer(unsigned(address))) <= data_in;
				elsif (EN='1' and w 	='0') then
					rw_data_out <= RW(to_integer(unsigned(address)));
				end if;
			end if;
		end process;

end structure;

		
-- output ports
library IEEE;
use IEEE.std_logic_1164.all;

entity output_ports is

	port (
		
		-- input ports
		address, data_in : in std_logic_vector(7 downto 0);
		w, reset, clock : in std_logic;
		
		-- output ports
		port_out_0,
		port_out_1,
		port_out_2,
		port_out_3,
		port_out_4,
		port_out_5,
		port_out_6,
		port_out_7,
		port_out_8,
		port_out_9,
		port_out_10,
		port_out_11,
		port_out_12,
		port_out_13,
		port_out_14,
		port_out_15 : out std_logic_vector(7 downto 0)
		
	);
	
end output_ports;

architecture structure of output_ports is

	begin
	
		-- port_out_0 description : ADDRESS x"E0"
		 U3 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_0 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E0" and w = '1') then
				port_out_0 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_1 description : ADDRESS x"E1"
		 U4 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_1 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E1" and w = '1') then
				port_out_1 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_2 description : ADDRESS x"E2"
		 U5 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_2 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E2" and w = '1') then
				port_out_2 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_3 description : ADDRESS x"E3"
		 U6 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_3 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E3" and w = '1') then
				port_out_3 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_4 description : ADDRESS x"E4"
		 U7 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_4 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E4" and w = '1') then
				port_out_4 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_5 description : ADDRESS x"E5"
		 U8 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_5 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E5" and w = '1') then
				port_out_5 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_6 description : ADDRESS x"E6"
		 U9 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_6 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E6" and w = '1') then
				port_out_6 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_7 description : ADDRESS x"E7"
		 U10 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_7 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E7" and w = '1') then
				port_out_7 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_8 description : ADDRESS x"E8"
		 U11 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_8 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E8" and w = '1') then
				port_out_8 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_9 description : ADDRESS x"E9"
		 U12 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_9 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E9" and w = '1') then
				port_out_9 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_10 description : ADDRESS x"E10"
		 U13 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_10 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E10" and w = '1') then
				port_out_10 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_11 description : ADDRESS x"E11"
		 U14 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_11 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E11" and w = '1') then
				port_out_11 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_12 description : ADDRESS x"E12"
		 U15 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_12 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E12" and w = '1') then
				port_out_12 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_13 description : ADDRESS x"E13"
		 U16 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_13 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E13" and w = '1') then
				port_out_13 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_14 description : ADDRESS x"E14"
		 U17 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_14 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E14" and w = '1') then
				port_out_14 <= data_in;
			end if;
		 end if;
		 end process;
	-- port_out_15 description : ADDRESS x"E15"
		 U18 : process (clock, reset)
		 begin
		 if (reset = '0') then
			port_out_15 <= x"00";
		 elsif (clock'event and clock='1') then
			if (address = x"E15" and w = '1') then
				port_out_15 <= data_in;
			end if;
		 end if;
		 end process;

end structure;

architecture arch_memoria of memoria is

	component rom is 
		port (
		-- input ports
		address : in std_logic_vector(7 downto 0);
		clock : in std_logic;
		rom_data_out : out std_logic_vector(7 downto 0)
		);
	end component; 
	
	component rw is 
		port (
			w, clock : in std_logic;
			rw_data_out : out std_logic_vector(7 downto 0);
			address, data_in : in std_logic_vector(7 downto 0)
	
		);
	end component;
	
	component output_ports is
		port (
			-- input ports
			address, data_in : in std_logic_vector(7 downto 0);
			w, reset, clock : in std_logic;
			-- output ports
			port_out_0,
			port_out_1,
			port_out_2,
			port_out_3,
			port_out_4,
			port_out_5,
			port_out_6,
			port_out_7,
			port_out_8,
			port_out_9,
			port_out_10,
			port_out_11,
			port_out_12,
			port_out_13,
			port_out_14,
			port_out_15 : out std_logic_vector(7 downto 0)
		);
		end component;

	begin
		
		MUX1 : process (address, rom_data_out, rw_data_out,
			port_in_0, port_in_1, port_in_2, port_in_3,
			port_in_4, port_in_5, port_in_6, port_in_7,
			port_in_8, port_in_9, port_in_10, port_in_11,
			port_in_12, port_in_13, port_in_14, port_in_15)
		begin
			if ( (to_integer(unsigned(address)) >= 0) and (to_integer(unsigned(address)) <= 127)) then
				data_out <= rom_data_out;
			elsif ( (to_integer(unsigned(address)) >= 128) and (to_integer(unsigned(address)) <= 223)) then
				data_out <= rw_data_out;
			elsif (address = x"F0") then data_out <= port_in_0;
			elsif (address = x"F1") then data_out <= port_in_1;
			elsif (address = x"F2") then data_out <= port_in_2;
			elsif (address = x"F3") then data_out <= port_in_3;
			elsif (address = x"F4") then data_out <= port_in_4;
			elsif (address = x"F5") then data_out <= port_in_5;
			elsif (address = x"F6") then data_out <= port_in_6;
			elsif (address = x"F7") then data_out <= port_in_7;
			elsif (address = x"F8") then data_out <= port_in_8;
			elsif (address = x"F9") then data_out <= port_in_9;
			elsif (address = x"FA") then data_out <= port_in_10;
			elsif (address = x"FB") then data_out <= port_in_11;
			elsif (address = x"FC") then data_out <= port_in_12;
			elsif (address = x"FD") then data_out <= port_in_13;
			elsif (address = x"FE") then data_out <= port_in_14;
			elsif (address = x"FF") then data_out <= port_in_15;
			else data_out <= x"00";
			end if;
			end process;

end arch_memoria;
