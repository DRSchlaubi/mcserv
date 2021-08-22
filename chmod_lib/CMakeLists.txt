cmake_minimum_required(VERSION 3.20)
project(mcserv_chmod C)

set(CMAKE_C_STANDARD 99)

add_library(mcserv_chmod SHARED library.c)
