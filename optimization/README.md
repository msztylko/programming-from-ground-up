# Optimization

## Local Optimizations

1. **Precomputing Calculations** - if a function has limited number of possible inputs and outputs you can precompute all of the possible answers beforehand, and simply look up the answer when the function is called.

2. **Remembering Calculation Results** - similar to previous method, but instead of computing answers beforehand, store the result of each calculation. This has the advantage of requiring less storage space because you aren’t precomputing all results. Also known as **caching** or **memoizing**.

3. **Locality of Reference** - accessing and processing items that are located in the same region of memory. Try to operate on small sections of memory at a time, rather than bouncing all over the place.

4. **Register Usage** - registers are the fastest memory locations on the computer, so you may try to make good use of them.

5. **Inline Functions** - functions help with the code organization, but they have the overhead of pushing arguments onto the stack and doing the jumps. Instead of calling function we can directly plug the code in exactly where the function was called.

6. **Optimized Instructions** - there are many ways to accomplish the same result, but some instructions are faster than others, e.g. XORing register with itself instead of loading zero.

7. **Addressing Modes** - Different addressing modes work at different speeds. The fastest are the immediate and register addressing modes. Direct is the next fastest, indirect is next, and base pointer and indexed indirect are the slowest. Try to use the faster addressing modes, when possible. 

8. **Data Alignment** - Some processors can access data on word-aligned memory boundaries (i.e. - addresses divisible by the word size) faster than non-aligned data. 
