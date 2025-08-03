module matrix_sep #(parameter DATAWIDTH = 16, N_SIZE = 5) (
input       [2*DATAWIDTH*N_SIZE-1:0]        matrix_c_unsep                  ,
output      [2*DATAWIDTH-1:0]               matrix_c_out_sep [N_SIZE-1:0]      
);

genvar i ;
generate;
    for(i=0;i<N_SIZE;i++)
    begin
        assign matrix_c_out_sep [i] = matrix_c_unsep[i*2*DATAWIDTH+:2*DATAWIDTH] ;
    end
endgenerate 
endmodule