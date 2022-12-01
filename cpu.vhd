---------------------------
---------- CPU ------------ 190
---------------------------

-- FSM
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity FSM is
	port (
			
		-- inputs
		IR : in std_logic_vector(7 downto 0); 
		CCR_result : in std_logic_vector(3 downto 0);
		Clock, reset : in std_logic;
		
		-- outputs
		w, IR_load, MAR_load, PC_load, PC_inc, A_load, B_load, CCR_load : out std_logic;
		alu_sel : out std_logic_vector(2 downto 0);
		bus2_sel, bus1_sel : out std_logic_vector(1 downto 0)
		
	);
	
end FSM;


-- DATA_PATH

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity cpu is
		port (
		
		-- inputs
		data_out : in std_logic_vector(7 downto 0);
		IR_load, MAR_load, PC_load, PC_inc, A_load, B_load, CCR_load : in std_logic;
		alu_sel : in std_logic_vector(2 downto 0);
		bus2_Sel, bus1_Sel : in std_logic_vector(1 downto 0);
		
		-- outputs
		to_memory, address, IR : out std_logic_vector(7 downto 0); 
		CCR_result : out std_logic_vector(3 downto 0);
		Clock, Reset : in std_logic
		
	);
	
end cpu;
	
architecture structure of cpu is
	--signal IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load  : std_logic;
	--signal MAR, address, B_out, B, Bus1, Bus2, PC, A, from_memory, to_memory : std_logic_vector(7 downto 0);
	--signal Bus2_Sel, Bus1_Sel   : std_logic_vector(1 downto 0);
	--signal ALU_Sel: std_logic_vector(2 downto 0);
	--signal CCR_Result: std_logic_vector(3 downto 0);
	signal NZVC : std_logic_vector (3 downto 0);
	signal PC_uns, from_memory, ALU_Result, Bus1, PC, A,B, Bus2, MAR, Result : std_logic_vector(7 downto 0);

	begin
	
	MUX_BUS1 : process (Bus1_Sel, PC, A, B)
	begin
		 case (Bus1_Sel) is
			  when "00" => Bus1 <= PC;
			  when "01" => Bus1 <= A;
			  when "10" => Bus1 <= B;
			  when others => Bus1 <= x"00";
		 end case;
	end process;

	MUX_BUS2 : process (Bus2_Sel, ALU_Result, Bus1, from_memory)
	begin
		 case (Bus2_Sel) is
			  when "00" => Bus2 <= ALU_Result;
			  when "01" => Bus2 <= Bus1;
			  when "10" => Bus2 <= from_memory;
			  when others => Bus2 <= x"00";
		 end case;
	end process;

	address <= MAR;
	to_memory <= Bus1;
	
	INSTRUCTION_REGISTER : process (Clock, Reset)
	begin
		 if (Reset = '0') then
			  IR <= x"00";
		 elsif (Clock'event and Clock = '1') then
			  if (IR_Load = '1') then
					IR <= Bus2;
			  end if;
		 end if;
	end process;

	MEMORY_ADDRESS_REGISTER : process (Clock, Reset)
	begin
		 if (Reset = '0') then
			  MAR <= x"00";
		 elsif (Clock'event and Clock = '1') then
			  if (MAR_Load = '1') then
					MAR <= Bus2;
			  end if;
		 end if;
	end process;

	PROGRAM_COUNTER : process (Clock, Reset)
	begin
		 if (Reset = '0') then
			  PC_uns <= x"00";
		 elsif (Clock'event and Clock = '1') then
			  if (PC_Load = '1') then
					PC_uns <= std_logic_vector(unsigned(Bus2));
			  elsif (PC_Inc = '1') then
					PC_uns <= PC_uns + 1;
			  end if;
		 end if;
	end process;

	PC <= std_logic_vector(PC_uns);

	A_REGISTER : process (Clock, Reset)
	begin
		 if (Reset = '0') then
			  A <= x"00";
		 elsif (Clock'event and Clock = '1') then
			  if (A_Load = '1') then
					A <= Bus2;
			  end if;
		 end if;
	end process;

	B_REGISTER : process (Clock, Reset)
	begin
		 if (Reset = '0') then
			  B <= x"00";
		 elsif (Clock'event and Clock = '1') then
			  if (B_Load = '1') then
					B <= Bus2;
			  end if;
		 end if;
	end process;

	CONDITION_CODE_REGISTER : process (Clock, Reset)
	begin
		 if (Reset = '0') then
			  CCR_Result <= x"0";
		 elsif (Clock'event and Clock = '1') then
			  if (CCR_Load = '1') then
					CCR_Result <= NZVC;
			  end if;
		 end if;
	end process;

	ALU_PROCESS : process (A, B, ALU_Sel)
	variable Sum_uns : unsigned(8 downto 0);
	variable Sub_uns : unsigned(8 downto 0);
	begin
		 if (ALU_Sel = "000") then -- ADDITION
			  --- Sum Calculation ----------------------------------
			  Sum_uns := unsigned('0' & A) + unsigned('0' & B);
			  Result <= std_logic_vector(Sum_uns(7 downto 0));
			  --- Negative Flag (N) -------------------------------
			  NZVC(3) <= Sum_uns(7);
			  --- Zero Flag (Z) ----------------------------------
			  if (Sum_uns(7 downto 0) = x"00") then
			  NZVC(2) <= '1';
			  else
			  NZVC(2) <= '0';
			  end if;
			  --- Overflow Flag (V) -------------------------------
			  if ((A(7)='0' and B(7)='0' and Sum_uns(7)='1') or
			  (A(7)='1' and B(7)='1' and Sum_uns(7)='0')) then
			  NZVC(1) <= '1';
			  else
			  NZVC(1) <= '0';
			  end if;
			  --- Carry Flag (C) ------------------------------------
			  NZVC(0) <= Sum_uns(8);

		 elsif (ALU_Sel = "001") then -- SUBTRACTION
			  --- Subtraction Calculation ----------------------------------
			  Sub_uns := unsigned('0' & A) - unsigned('0' & B);
			  Result <= std_logic_vector(Sub_uns(7 downto 0));
			  --- Negative Flag (N) -------------------------------
			  NZVC(3) <= Sub_uns(7);
			  --- Zero Flag (Z) ----------------------------------
			  if (Sub_uns(7 downto 0) = x"00") then
			  NZVC(2) <= '1';
			  else
			  NZVC(2) <= '0';
			  end if;
			  --- Overflow Flag (V) -------------------------------
			  if ((A(7)='0' and B(7)='0' and Sub_uns(7)='1') or
			  (A(7)='1' and B(7)='1' and Sub_uns(7)='0')) then
			  NZVC(1) <= '1';
			  else
			  NZVC(1) <= '0';
			  end if;
			  --- Carry Flag (C) ------------------------------------
			  NZVC(0) <= Sub_uns(8);
		 end if;
	end process;


end structure;
