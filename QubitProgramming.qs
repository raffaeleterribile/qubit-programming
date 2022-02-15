namespace NamespaceQFT {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arithmetic;

    // Performs a Quantum Fourier Transformation (QFT) on qubits
    @EntryPoint()
    operation Perform3QubitQFT() : Result[] {
        mutable resultArray = new Result[3];
        
        using (qs = Qubit[3]) {

            Message("Initial state |000>:");
            DumpMachine();

            H(qs[0]);

            // R1(π/2) and R1(π/4) are equivalent to the S and T operations (also in Microsoft.Quantum.Intrinsic)
            //QFT:
            // first qubit:
            Controlled R1([qs[1]], (PI()/2.0, qs[0]));
            Controlled R1([qs[2]], (PI()/4.0, qs[0]));

            //second qubit:
            H(qs[1]);
            Controlled R1([qs[2]], (PI()/2.0, qs[1]));

            //third qubit:
            H(qs[2]);

            // This is necessary because the nature of the quantum Fourier transform outputs the qubits in reverse order, 
            // so the swaps allow for seamless integration of the subroutine into larger algorithms.
            SWAP(qs[2], qs[0]);

            Message("Before measurement: ");
            DumpMachine();

            // Measure qubits
            for(i in IndexRange(qs)) {
                set resultArray w/= i <- M(qs[i]);

                let iString = IntAsString(i);
                Message("After measurement of qubit " + iString + ":");
                DumpMachine();
            }

            // Deallocate qubits
            Message("After measurement: ");
            DumpMachine();

            ResetAll(qs);
        }

        Message("Post-QFT measurement results [qubit0, qubit1, qubit2]: ");
        return resultArray;
    }

    operation PerformIntrinsicQFT() : Result[] {
        mutable resultArray = new Result[4];
        
        using (qs = Qubit[4]) {

            Message("Initial state |000>:");
            DumpMachine();

            let register = BigEndian(qs);    //from Microsoft.Quantum.Arithmetic
            QFT(register);                   //from Microsoft.Quantum.Canon

            Message("Before measurement: ");
            DumpMachine();

            // Measure qubits
            for(i in IndexRange(qs)) {
                set resultArray w/= i <- M(qs[i]);

                let iString = IntAsString(i);
                Message("After measurement of qubit " + iString + ":");
                DumpMachine();
            }

            // Deallocate qubits
            Message("After measurement: ");
            DumpMachine();

            ResetAll(qs);
        }

        Message("Post-QFT measurement results [qubit0, qubit1, qubit2]: ");
        return resultArray;
    }
}