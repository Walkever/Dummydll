CMAKE_MINIMUM_REQUIRED (VERSION 3.0)
project(Dummydll)
Add_library(Dummydll SHARED dllmain.cpp dummydll.cpp dummydll.h pch.cpp pch.h targetver.h)