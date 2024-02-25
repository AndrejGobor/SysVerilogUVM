/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

class random;

   rand int operations_done;
   constraint c1 { (operations_done inside {[100000:200000]}) ;}

endclass


class tester;

   virtual tinyalu_bfm bfm;
   random randOperation = new;
   rand int num;
   int op_cnt = 0;
   int op_choice_indicator = 1;
   bit [2:0] op_choice_sel;

   constraint c1 {num >= 1000; num <= 1000;}

   function new (virtual tinyalu_bfm b);
       bfm = b;
   endfunction : new


   protected function operation_t get_op();
      bit [2:0] op_choice;
      if (op_cnt == 3) begin
         op_choice_indicator = 1;
         op_cnt = 0;
      end
      if (op_choice_indicator == 1) begin
         op_choice = $random;
         op_choice_indicator = 0;
         op_choice_sel = op_choice;
      end

      case (op_choice_sel)
        3'b000 : begin 
            op_cnt++; 
            return not_op;
        end
        3'b001 : begin
            op_cnt++; 
            return add_op;
        end
        3'b010 : begin 
            op_cnt++; 
            return and_op;
        end
        3'b011 : begin
            op_cnt++; 
            return xor_op;
         end
        3'b100 : begin
            op_cnt++; 
            return mul_op;
        end
        3'b101 : begin 
            op_cnt++; 
            return no_op;
        end
        3'b110 : begin
            op_cnt++; 
            return rst_op;
        end
        3'b111 : begin
            op_cnt++; 
            return rst_op;
        end
      endcase // case (op_choice)

   endfunction : get_op

   protected function byte get_data();
      bit [1:0] zero_ones;
      zero_ones = $random;
      if (zero_ones == 2'b00)
        return 12'h000;
      else if (zero_ones == 2'b11)
        return 12'hFFF;
      else if (zero_ones == 2'b10)
         return 12'h06D;
      else 
         return 12'h001;
      /*else
        return $random;
        */
   endfunction : get_data
   
   task execute();
      shortint     unsigned        iA;
      shortint     unsigned        iB;
      shortint     unsigned        result;
      operation_t                  op_set;

      bfm.reset_alu();
      op_set = rst_op;
      iA = get_data();
      iB = get_data();
      bfm.send_op(iA, iB, op_set, result);
      op_set = mul_op;
      bfm.send_op(iA, iB, op_set, result);
      bfm.send_op(iA, iB, op_set, result);
      op_set = rst_op;
      bfm.send_op(iA, iB, op_set, result);

      void'(randOperation.randomize());

      repeat (randOperation.operations_done) begin : random_loop
         //$display("Getting op %6s", op_set.name());
         op_set = get_op();
         //$display("Getting dataA");
         iA = get_data();
         //$display("Getting dataB");
         iB = get_data();
         //$display("Sending data");
         bfm.send_op(iA, iB, op_set, result);
         $display("%2h %6s %2h = %4h",iA, op_set.name(), iB, result);
      end : random_loop
      $display("Operations done: %d", randOperation.operations_done);
      void'(randOperation.randomize());
      $display("Operations done: %d", randOperation.operations_done);

      $stop;
   endtask : execute
   
endclass : tester






