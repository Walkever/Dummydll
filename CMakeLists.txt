CMAKE_MINIMUM_REQUIRED (VERSION 3.0)
project(Dummydll)
Add_library(Dummydll SHARED dummydll/dllmain.cpp dummydll/dummydll.cpp dummydll/dummydll.h dummydll/pch.cpp dummydll/pch.h dummydll/targetver.h)