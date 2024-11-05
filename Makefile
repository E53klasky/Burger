CXX = mpicxx
CXXFLAGS = -std=c++14 -Wall -O2 -ffast-math -march=native
LDFLAGS = -L/usr/lib -lblas

default: burg

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -o main.o -c main.cpp

Burgers.o: Burgers.cpp Burgers.h
	$(CXX) $(CXXFLAGS) -o Burgers.o -c Burgers.cpp

Model.o: Model.cpp Model.h
	$(CXX) $(CXXFLAGS) -o Model.o -c Model.cpp

compile: main.o Burgers.o Model.o
	$(CXX) $(CXXFLAGS) -o BurgersProg main.o Burgers.o Model.o $(LDFLAGS)

# Test cases: Arguments are given in the order (after ./BurgersProg): Lx Ly T Nx Ny Nt ax ay b c Px Py 
# Note - must match number of processors (the number after -np) with Px * Py
diff: compile
	mpiexec -np 4 ./BurgersProg 10 10 1 1001 1001 40000 0 0 0 1 2 2
#note diffusion has convergence issues if spatial discretisation is too fine!
advx: compile
	mpiexec -np 4 ./BurgersProg 10 10 1 2001 2001 4000 1 0 0 0 2 2

advy: compile
	mpiexec -np 4 ./BurgersProg 10 10 1 2001 2001 4000 0 1 0 0 2 2

burg: compile
	mpiexec -np 4 ./BurgersProg 10 10 1 2001 2001 4000 1 0.5 1 0.02 2 2

# Rule to clean the source directory
.PHONY: clean
clean:
	-rm -f *.o BurgersProg
