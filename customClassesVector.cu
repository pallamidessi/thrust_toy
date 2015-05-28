/**
 * @file customClassesVector.cpp
 * @author Pallamidessi Joseph
 * @version 1.0
 *
 * @section LICENSE
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details at
 * http://www.gnu.org/copyleft/gpl.html
**/

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <algorithm>
#include <cstdlib>


class CustomClass2 {
  public:
    CustomClass2 () {};

  private:
    /* data */
    int intData1;
    int intData2;
    int intData3;
    int intData4;
};

class CustomClass {
  public:
    CustomClass (int i) {
        this->id = i;
    };
  
  public:
    int id;
  private:
    /* data */
    int intData1;
    int intData2;
    int intdata3;
    char a;
    char b;
    char c;
    CustomClass2 bar;
};

struct compId_t {
   __host__ __device__ bool operator ()(const CustomClass &rhs, const CustomClass &lhs) {
    return rhs.id > lhs.id;
  } 
}; 

int main(int argc, char* argv[]) {
    int i;
    
    // generate 32M random numbers serially
    thrust::host_vector<CustomClass> h_vec;
    for (i = 0; i < 10; i++) {
        CustomClass* test = new CustomClass(i);
        h_vec.push_back(*test);
        delete test;
    }
    compId_t comp;

    // transfer data to the device
    thrust::device_vector<CustomClass> d_vec = h_vec;

    // sort data on the device (846M keys per second on GeForce GTX 480)
    thrust::sort(d_vec.begin(), d_vec.end(), comp);
    //thrust::sort(d_vec.begin(), d_vec.end());

    // transfer data back to host
    thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin());

    return 0;
}






