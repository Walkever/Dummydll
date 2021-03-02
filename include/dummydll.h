#pragma once

#if defined (BUILD_SHARED_LIBS)
#if defined (_MSC_VER)
#pragma warning(disable: 4251)
#endif
#if defined(DUMMYDLL_EXPORTS)
#define  DUMMYDLL_API __declspec(dllexport)
#else
#define  DUMMYDLL_API __declspec(dllimport)
#endif
#else
#define DUMMYDLL_API
#endif

extern "C"
{
	DUMMYDLL_API float add(float a, float b);
	DUMMYDLL_API float subtract(float a, float b);
}