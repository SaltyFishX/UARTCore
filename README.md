# Simple UART Core

## 1.Introduction
  This Simple UART Core is capable of simple serial port communication and can be used for FPGA beginners to develop the serial port driver on the development board. This Core, which is modified based on UART to Bus Core in OpenCores(https://opencores.org/projects/uart2bus), is better suited for driver development with novices. The core is based on Quartus II 17.1 release. If you need to do driver development, you only need to compile the files in the folder which is named Compiling file.
  
## 2.Notice For Use
###  2.1 How to Use This Core
  The way to use this kernel is very simple!You only need to change the parameter: D_BAUD_FREQ and D_BAUD_FREQ depending on your baud rate(such as 9600,115200) and clock freq(such as 50M).And then map the clock,reset,ser_in(uart_rx),ser_out(uart_tx) to the corresponding pin.That is all!
###  2.2 Calculation For Baud Rate
    D_BAUD_FREQ =16*baud_rate/gcd(global_clock_freq,16 * baud_rate)
    D_BAUD_FREQ = (global_clock_freq / gcd(global_clock_freq, 16*baud_rate)) - baud_freq
    If you can’t understand it,you can go to my blog:https://blog.csdn.net/a792544191/article/details/108016377.
###  2.3 Simulation and Test
####  (1) Test Uart Receiving
    In the folder named simulation, there are two testbench.You can use them to test Uart receiving based on Modelsim.And pay attention to the file name,one is for uart_top and another is for uart2bus_top.
####  (2) Test Uart Sending
    In the folder which is named Compiling file,the file named uart2bus_top contains the serial port send test.Pay attention to the annotation.
####  (3) Test Uart Sending and Receiving
    In the folder which is named Compiling file,the file named uart2bus_top contains the serial port send and receive test.Pay attention to the annotation.
 
## 3.Result
 If you want to make sure that your simulation results are correct, please come to my blog: https://blog.csdn.net/a792544191/article/details/108016377.
