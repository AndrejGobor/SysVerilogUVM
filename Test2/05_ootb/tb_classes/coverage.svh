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
class coverage;

   virtual tinyalu_bfm bfm;


   shortint     unsigned        A;
   shortint     unsigned        B;
   operation_t  op_set;
   operation_t  task_more_operation_coverage;

   covergroup op_cov;

      coverpoint op_set {
         bins single_cycle[] = {[add_op : xor_op], rst_op,no_op};
         bins multi_cycle = {mul_op};

         bins opn_rst[] = ([add_op:mul_op] => rst_op);
         bins rst_opn[] = (rst_op => [add_op:mul_op]);

         bins sngl_mul[] = ([add_op:xor_op],no_op => mul_op);
         bins mul_sngl[] = (mul_op => [add_op:xor_op], no_op);

         bins twoops[] = ([add_op:mul_op] [* 2]);
         bins manymult = (mul_op [* 3:5]);

      }

   endgroup

// 2nd Way
/*
   covergroup task_more_op_cov;

      coverpoint task_more_operation_coverage {

         bins threeopsall[] = ([not_op:rst_op] [* 3]);
         bins xorthenall[] = (xor_op => [not_op:rst_op]);
         bins addthenall[] = ([not_op:rst_op] => add_op); 

      }

   endgroup
*/

   covergroup task_more_value_cov;

      coverpoint task_more_operation_coverage {

         bins threeopsall[] = ([not_op:rst_op] [* 3]);
         bins xorthenall[] = (xor_op => [not_op:rst_op]);
         bins addthenall[] = ([not_op:rst_op] => add_op); 

      }

      a_leg: coverpoint A {
         bins val1 = {9'h06D};
         bins val2 = {9'h001};
      }

      b_leg: coverpoint B {
         bins val1 = {9'h06D};
         bins val2 = {9'h001};
      }

      value_coverage: cross a_leg, b_leg {
         bins val1Aval1B = binsof (a_leg.val1) && binsof(b_leg.val1);
         bins val2Aval2B = binsof (a_leg.val2) && binsof(b_leg.val2);
      }

   endgroup

   covergroup zeros_or_ones_on_ops;

      all_ops : coverpoint op_set {
         ignore_bins null_ops = {rst_op, no_op};}

      a_leg: coverpoint A {
         bins zeros = {9'h000};
         bins others= {[9'h001:9'hFFE]};
         bins ones  = {9'hFFF};
      }

      b_leg: coverpoint B {
         bins zeros = {9'h000};
         bins others= {[9'h001:9'hFFE]};
         bins ones  = {9'hFFF};
      }

      op_00_FF:  cross a_leg, b_leg, all_ops {
         bins add_00 = binsof (all_ops) intersect {add_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins add_FF = binsof (all_ops) intersect {add_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins and_00 = binsof (all_ops) intersect {and_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins and_FF = binsof (all_ops) intersect {and_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins xor_00 = binsof (all_ops) intersect {xor_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins xor_FF = binsof (all_ops) intersect {xor_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_00 = binsof (all_ops) intersect {mul_op} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins mul_FF = binsof (all_ops) intersect {mul_op} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_max = binsof (all_ops) intersect {mul_op} &&
                        (binsof (a_leg.ones) && binsof (b_leg.ones));

         ignore_bins others_only =
                                  binsof(a_leg.others) && binsof(b_leg.others);

      }

endgroup

   function new (virtual tinyalu_bfm b);
     op_cov = new();
     zeros_or_ones_on_ops = new();
     task_more_value_cov = new();
     //task_more_op_cov = new();
     bfm = b;
   endfunction : new



   task execute();
      forever begin  : sampling_block
         @(negedge bfm.clk);
         A = bfm.A;
         B = bfm.B;
         task_more_operation_coverage = bfm.op_set;
         op_set = bfm.op_set;
         task_more_value_cov.sample();
         //task_more_op_cov.sample();
         op_cov.sample();
         zeros_or_ones_on_ops.sample();
      end : sampling_block
   endtask : execute

endclass : coverage






