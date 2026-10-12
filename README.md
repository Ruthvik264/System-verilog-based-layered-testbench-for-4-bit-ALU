# 4-bit ALU: Layered SystemVerilog Testbench

A class-based, layered verification environment for a 4-bit Arithmetic Logic Unit (ALU), written in SystemVerilog. The testbench uses constrained-random stimulus, a self-checking scoreboard with a reference model, and functional coverage to verify the ALU's operations and output flags.

**Live demo:** [Run on EDA Playground](https://edaplayground.com/x/nmBp)

## Verification Results

| Metric | Result |
|---|---:|
| Total test cases | 104 |
| Passed | 104 |
| Failed | 0 |
| Functional coverage | 100.00% |

The testbench combines randomized transactions with directed test cases to exercise operation–zero-flag combinations that were initially uncovered.

## ALU Operations

| `op_code` | Operation | Result |
|---|---|---|
| `000` | ADD | `a + b`, including carry out |
| `001` | SUB | `a - b` |
| `010` | AND | `a & b` |
| `011` | OR | `a \| b` |
| `100` | XOR | `a ^ b` |
| `101` | NOT | `~a` (4-bit result) |
| `110` | LEFT SHIFT | `a << 1` |
| `111` | RIGHT SHIFT | `a >> 1` |

- `y`: 4-bit ALU result.
- `zero`: Asserted when `y == 0`.
- `carry`: Indicates carry out for addition; otherwise, it is expected to remain 0.

## Features

- Constrained-random stimulus for operands and operation codes.
- Layered, class-based testbench architecture using SystemVerilog mailboxes.
- Virtual interface for communication between the driver, DUT, and monitor.
- Self-checking scoreboard with a reference model.
- Verification of `y`, `carry`, and `zero`.
- Functional coverage using coverpoints and cross coverage.
- Directed tests for previously uncovered operation–zero-flag combinations.
- Pass/fail counters and a functional coverage summary.

## Testbench Architecture

```text
generator --> driver --> [ ALU (DUT) ] --> monitor --> scoreboard
   (mailbox)  (virtual interface)  (virtual interface)   (mailbox)
                                                             |
                                                          coverage
```

| Component | Responsibility |
|---|---|
| `transaction` | Stores randomized inputs and output fields |
| `generator` | Creates transactions and sends them to the driver |
| `driver` | Drives the DUT inputs through a virtual interface |
| `monitor` | Samples DUT inputs and outputs and forwards them to the scoreboard |
| `scoreboard` | Uses a reference model to check outputs and count passes/failures |
| `coverage` | Samples functional coverage for each transaction |
| `environment` | Instantiates and connects testbench components |
| `test` | Creates and runs the verification environment |
| `testbench` | Top-level module instantiating the interface, DUT, and test |

## Functional Coverage

| Coverpoint / Cross | What It Measures |
|---|---|
| `cp_op` | All eight operation codes |
| `cp_a`, `cp_b` | Operand categories: 0, 1–7, 8–14, and 15 |
| `cp_carry` | Carry flag values 0 and 1 |
| `cp_zero` | Zero flag values 0 and 1 |
| `cross_op_zero` | Operation code crossed with the zero flag |
| `cross_op_carry` | Operation code crossed with carry, with invalid carry combinations excluded according to the coverage model |

The final simulation achieved **100.00% coverage of the bins defined in the coverage model**. This indicates that all modeled coverage bins were exercised; it does not guarantee exhaustive testing of every possible input combination.

## Project Structure

```text
ALU/
├── rtl/
│   └── design.sv
└── tb/
    ├── interface.sv
    ├── transaction.sv
    ├── coverage.sv
    ├── generator.sv
    ├── driver.sv
    ├── monitor.sv
    ├── scoreboard.sv
    ├── environment.sv
    ├── test.sv
    └── testbench.sv
```

## How to Run

### QuestaSim

Only `design.sv` and `testbench.sv` are compiled directly. The remaining testbench files are included using SystemVerilog `` `include `` directives.

```bash
vlog -mfcu +incdir+tb rtl/design.sv tb/testbench.sv
vsim -c top -do "run -all; exit"
```

### EDA Playground

1. Open the [ALU project](https://edaplayground.com/x/nmBp).
2. Place `design.sv` in the design pane.
3. Place the testbench code in the testbench pane.
4. Select QuestaSim as the simulator.
5. Run the simulation and inspect the scoreboard and coverage summary.

**Note:** The generator, driver, monitor, and scoreboard must use consistent transaction counts and termination conditions. The final run uses 104 transactions, including the additional directed tests.

## Sample Simulation Output

```text
[SCO][PASS] SUB | a=5 b=5 | y=0 carry=0 zero=1
[SCO][PASS] OR | a=0 b=0 | y=0 carry=0 zero=1
[SCO][PASS] NOT | a=15 b=0 | y=0 carry=0 zero=1
[SCO][PASS] RIGHT SHIFT | a=1 b=1 | y=0 carry=0 zero=1
--------------------------------------
Total=104  PASS=104  FAIL=0
Functional coverage = 100.00%
--------------------------------------
```

The four directed tests target zero-result cases that were missing from the initial simulation. Together with the randomized stimulus, they increased the measured functional coverage from **96.43% to 100.00%**, while maintaining zero scoreboard failures.
