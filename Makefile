all: customVectorClass

customVectorClass: customClassesVector.cu
	nvcc $<  -o $@ 
