module testbench();

    logic [127:0] data_to_cipher [11];
    logic [127:0] ciphered_data  [11];
    logic clk, resetn, request, ack, valid, busy;
    logic [127:0] data_i, data_o;

    initial clk <= 0;

    always #5ns clk <= ~clk;

    integer i = 0;
    logic [128*11-1:0] print_str;


    kuznechik_cipher DUT(
        .clk_i      (clk),
        .resetn_i   (resetn),
        .data_i     (data_i),
        .request_i  (request),
        .ack_i      (ack),
        .data_o     (data_o),
        .valid_o    (valid),
        .busy_o     (busy)
    );

    initial begin
        data_to_cipher[00] <= 128'h3ee5c99f9a41c389ac17b4fe99c72ae4;
        data_to_cipher[01] <= 128'h79cfed3c39fa7677b970bb42a5631ccd;
        data_to_cipher[02] <= 128'h63a148b3d9774cede1c54673c68dcd03;
        data_to_cipher[03] <= 128'h2ed02c74160391fd9e8bd4ba21e79a9d;
        data_to_cipher[04] <= 128'h74f245305909226922ac9d24b9ed3b20;
        data_to_cipher[05] <= 128'h03dde21c095413db093bb8636d8fc082;
        data_to_cipher[06] <= 128'hbdeb379c9326a275c58c756885c40d47;
        data_to_cipher[07] <= 128'h2dcabdf6b6488f5f3d56c2fd3d2357b0;
        data_to_cipher[08] <= 128'h887adf8b545c4334e0070c63d2f344a3;
        data_to_cipher[09] <= 128'h23feeb9115fab3e4f9739578010f212c;
        data_to_cipher[10] <= 128'h53e0ebee97b0c1b8377ac5bce14cb4e8;
        $display("Testbench has been started.\nResetting");
        resetn <= 1'b0;
        ack <= 0;
        request <= 0;
        repeat(2) begin
            @(posedge clk);
        end
        resetn <= 1'b1;
        for(i=0; i < 11; i++) begin
            $display("Trying to cipher %d chunk of data", i);
            @(posedge clk);
            data_i <= data_to_cipher[i];
            while(busy) begin
                @(posedge clk);
            end
            request <= 1'b1;
            @(posedge clk);
            request <= 1'b0;
            while(~valid) begin
                @(posedge clk);
            end
            ciphered_data[i] <= data_o;
            ack <= 1'b1;
            @(posedge clk);
            ack <= 1'b0;
        end
        $display("Ciphering has been finished.");
        $display("============================");
        $display("===== Ciphered message =====");
        $display("============================");
        print_str = {ciphered_data[0],
                        ciphered_data[1],
                        ciphered_data[2],
                        ciphered_data[3],
                        ciphered_data[4],
                        ciphered_data[5],
                        ciphered_data[6],
                        ciphered_data[7],
                        ciphered_data[8],
                        ciphered_data[9],
                        ciphered_data[10]
                    };
        $display("%s", print_str);
        $display("============================");
        $finish();
    end

endmodule
