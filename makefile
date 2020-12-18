a.out: main.o func_select.o pstring.o
	gcc -no-pie -g -o a.out main.o func_select.o pstring.o

main.o: main.s
	gcc -no-pie -g -c -o main.o main.s

func_select.o: func_select.s
	gcc -no-pie -g -c -o func_select.o func_select.s

pstring.o: pstring.s
	gcc -no-pie -g -c -o pstring.o pstring.s	

clean:
	rm -f *.o a.out
