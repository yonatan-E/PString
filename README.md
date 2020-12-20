# PString library
The project is about a PString library written in assembly x64-86.

**About the library functions:**  
The library contains the next functions:  
*pstrlen:* gets the length of a PString.  
*replaceChar:* replaces all of the instances of a char in a PString with another char.  
*pstrijcpy:* copies a substring of a PString to another PString.  
*swapCase:* changes the case of all of the letters in a PString.
*pstrijcmp:* compares lexicographily between substrings of two PStrings.  
All of that functions are implemented in the **pstring.s** file.  

**Another files:**  
The **func_select.s** file contains the implementation of the function *run_func*, which gets two PStrings and a number of an option,
and calls to a function from the PString library according to the option number and prints the result.
The option is selected by a switch-case on the option number, which is implemented by a jump table.  
Options details:  
*50* or *60* will call to *pstrlen*.  
*52* will get from the user two chars, and will call to *replaceChar*.  
*53* will get from the user two indices, and will call to *pstrijcpy*.  
*54* will call to *swapCase*.  
*55* will get from the user two indices, and will call to *pstrijcmp*.  
The **main.s** file contains the *main* function, which gets from the user two PStrings and a number of an option, and calls the run_func function with those arguments.  
The **pstring.h** file contains declerations about the library functions and about the PString struct.
