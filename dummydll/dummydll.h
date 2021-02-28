#pragma once

#ifdef DUMMYDLL_EXPORTS
#define DUMMYDLL_API __declspec(dllexport)
#else
#define DUMMYDLL_API __declspec(dllimport)
#endif

extern "C"
{
	DUMMYDLL_API float add(float a, float b);
	DUMMYDLL_API float subtract(float a, float b);
}