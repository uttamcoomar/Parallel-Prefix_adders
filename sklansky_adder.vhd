library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

entity sklansky_adder is

 --N corresponds to the width of the numbers to be added. 
 --Edit the line Generic ( N : integer := <desired_length>);, as you may need
 Generic ( N : integer:=8);
 Port (A,B : in std_logic_vector(N-1 downto 0); 
       Y : out std_logic_vector(N downto 0));
end sklansky_adder;

architecture schematic of sklansky_adder is

  -- The function stage2 finds the number of stages in the Kogge-Stone adder
  -- to be implemented.
  
  function stage2(N1 : integer) return integer is
      variable count : integer := 0;   
      variable temp1 : integer := N1;
    begin
      while temp1 > 1 loop
          temp1 := temp1 / 2;
          count := count + 1;
      end loop;
    return(count);
  end;
  
  constant m : integer := stage2(N);
  
  type arrays is array(m downto 0,N downto 0) of std_logic;
  signal G : arrays;
  signal P : arrays;
  
begin
  start_adder : process(G,P,A,B)
  variable cntr: integer;
  begin
    for i in 0 to N-1 loop
     	G(0,i) <= A(i) and B(i); 
     	P(0,i) <= A(i) xor B(i);
    end loop;
    
  
    for i in 1 to m loop
    cntr := 2**i;
      -- Generate and propagate signal blocks
        while cntr < N loop
              for k in integer(2**(i-1))+cntr to integer(2*(2**(i-1))-1)+cntr loop
                  G(i,k) <= G(i-1,k) or (G(i-1,2**(i-1)-1+cntr) and P(i-1,k));
                  P(i,k) <= P(i-1,k) and P(i-1,2**(i-1)-1+cntr);
              end loop;
             for k in 0+cntr to integer(2**(i-1)-1)+cntr loop
                G(i,k) <= G(i-1,k);
                P(i,k) <= P(i-1,k);
             end loop; 
             cntr := cntr + 2**i;
        end loop;
    end loop;
    
   
    for i in 1 to m loop
        -- Generate signal blocks
        for k in integer(2**(i-1)) to integer(2*(2**(i-1))-1) loop
              G(i,k) <= G(i-1,k) or (G(i-1,2**(i-1)-1) and P(i-1,k));
        end loop;
        -- "Pass the generate bits" blocks.
        for k in 0 to integer(2**(i-1)-1) loop
              G(i,k) <= G(i-1,k);
              P(i,k) <= P(i-1,k);
        end loop;   
    end loop;
    
     -- Final addition 
     Y(0) <= P(0,0);
     for q in 1 to N-1 loop
	    Y(q) <= G(m,q-1) xor P(0,q);
     end loop;
     Y(N) <= G(m,N-1);
     
  end process;
end schematic;