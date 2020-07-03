# simple_rv32i_cpu
🖥 计组课设：rv32i 指令集的简单实现

## 流水线分割
- IF：取指
- ID：译码
- EX & MEM：alu 计算，sw、lw 指令访存
- WB：写回寄存器

## 指令
| 指令 | 类型 |    功能    |
| :--: | :--: | :--------: |
| jal  |  J   |  跳转指令  |
| beq  |  B   |  比较跳转  |
|  lw  |  I   |    load    |
|  sw  |  S   |   store    |
| addi |  I   | 立即数加法 |
| add  |  R   |    加法    |
| sub  |  R   |    减法    |
| and  |  R   |    and     |
|  or  |  R   |     or     |
| xor  |  R   |    xor     |
| sll  |  R   |    左移    |
| srl  |  R   |    右移    |

## 参考
- 教你写一个简单的CPU
- The RV32I Processor / Altera Quartus Tutorial
- https://github.com/nobotro/fpga_riscv_cpu
- https://github.com/Yuandiaodiaodiao/a-sample-cpu
- https://github.com/Michaelvll/RISCV_CPU
- https://github.com/VenciFreeman/RISC-V
- 介绍 RV32I：
  - RV32I 基础整数指令集：https://www.cnblogs.com/mikewolf2002/p/11196680.html
  - RISC-V 手册：http://crva.ict.ac.cn/documents/RISC-V-Reader-Chinese-v2p1.pdf.11.3