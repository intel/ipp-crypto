/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
* All Rights Reserved.
*
* If this  software was obtained  under the  Intel Simplified  Software License,
* the following terms apply:
*
* The source code,  information  and material  ("Material") contained  herein is
* owned by Intel Corporation or its  suppliers or licensors,  and  title to such
* Material remains with Intel  Corporation or its  suppliers or  licensors.  The
* Material  contains  proprietary  information  of  Intel or  its suppliers  and
* licensors.  The Material is protected by  worldwide copyright  laws and treaty
* provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
* modified, published,  uploaded, posted, transmitted,  distributed or disclosed
* in any way without Intel's prior express written permission.  No license under
* any patent,  copyright or other  intellectual property rights  in the Material
* is granted to  or  conferred  upon  you,  either   expressly,  by implication,
* inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
* property rights must be express and approved by Intel in writing.
*
* Unless otherwise agreed by Intel in writing,  you may not remove or alter this
* notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
* suppliers or licensors in any way.
*
*
* If this  software  was obtained  under the  Apache License,  Version  2.0 (the
* "License"), the following terms apply:
*
* You may  not use this  file except  in compliance  with  the License.  You may
* obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
*
*
* Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
* distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*
* See the   License  for the   specific  language   governing   permissions  and
* limitations under the License.
*******************************************************************************/

/* 
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
// 
//   Created: Tue Feb  5 17:02:02 2002
// 
// 
*/


#include "pcpname.h"

#ifdef _PCS

#if !defined( _WIN32 ) && !defined( _WIN64 ) && !defined( _WIN32E ) && !defined( linux32 ) && !defined( linux64 ) && !defined( linux32e ) && !defined( OSX32 ) && !defined( OSXEM64T )
  #error The target platform is unknown
#endif

#if !defined (_UNICODE)
  #define _UNICODE
  #define UNICODE
#endif


#if !defined(IPP_INC_NAME) || !defined(IPP_LIB_PREFIX) || !defined(IPP_LIB_SHORTNAME)
  #error The symbols: IPP_INC_NAME, IPP_LIB_PREFIX, IPP_LIB_SHORTNAME must be defined
#endif


#if defined( _WIN32 ) || defined( _WIN64 ) || defined( _WIN32E )
  #define STRICT
  #define WIN32_LEAN_AND_MEAN
  #include <windows.h>
  #include <stdio.h>
  #include <tchar.h>
#elif defined( linux ) || defined( OSX32 ) || defined( OSXEM64T )
  typedef int (*FARPROC)();
  #define _T(str) str
  #define _TCHAR char
  #include <stdio.h>
  #include <stdlib.h>                  /* Included for getenv */
  #include <string.h>
  #include <dlfcn.h>                   /* Programming intrface to dynamic
                                          linking loader deined here */
#endif


#include "ippcpdefs.h"
#include "dispatcher.h"

#define IPP_MSG_SIZE (256)
static _TCHAR LOAD_DLL_ERR[ IPP_MSG_SIZE ] = _T("Error at loading of ") _T(IPP_LIB_SHORTNAME()) _T(" library");

#if defined( _WIN32 ) || defined( _WIN64 ) || defined( _WIN32E )
static BOOL DescribeLastError( _TCHAR** szBuffer )
{
    return FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
        NULL,
        GetLastError(),
        MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ),
        (_TCHAR*)szBuffer,
        0,
        NULL);
}

static void DisplayLastError( _TCHAR* msg )
{
    LPTSTR szBuf;
    if( DescribeLastError( &szBuf ) )
    {
        _TCHAR szDesc[400];
        int len;
        len = _stprintf_s( (_TCHAR*)szDesc, 400, _T("%s%s\n"), msg, szBuf);
        MessageBeep( MB_ICONSTOP );
        MessageBox( 0, szDesc, LOAD_DLL_ERR, MB_ICONSTOP | MB_OK );
        LocalFree( szBuf );
    }
}
#endif

/* /////////////////////////////////////////////////////////////////////////////
   ----- Create static library to hold function pointer and patch funcs -----
///////////////////////////////////////////////////////////////////////////// */

static char* ippcpSetCpuFeaturesName        = "ippcpSetCpuFeatures";
static char* ippcpSetNumThreadsName         = "ippcpSetNumThreads";
static char* ippcpGetNumThreadsName         = "ippcpGetNumThreads";
extern IppStatus (IPP_STDCALL *pcpSetCpuFeatures)( Ipp64u cpuFeatures ) = 0;
extern IppStatus (IPP_STDCALL *pcpSetNumThreads)( int numThr ) = 0;
extern IppStatus (IPP_STDCALL *pcpGetNumThreads)( int* pNumThr ) = 0;

IppStatus IPP_STDCALL ippcpGetCpuFeatures( Ipp64u* pFeaturesMask );
IppStatus IPP_STDCALL ippcpSetCpuFeatures( Ipp64u features );
IppStatus owncpSetCpuFeaturesAndIdx( Ipp64u cpuFeatures, int* index );
#define MSG_LOAD_DLL_ERR (-9700) /* Error at loading of %s library */
#define MSG_NO_DLL       (-9701) /* No DLLs were found in the Waterfall procedure */
#define MSG_NO_SHARED    (-9702) /* No shared libraries were found in the Waterfall procedure */
typedef IppStatus (IPP_STDCALL *DYN_RELOAD)( int );

void owncpRegisterLib( DYN_RELOAD reload );
void owncpUnregisterLib( void );

#ifdef IPPAPI
#undef IPPAPI
#endif


#if defined( _WIN32 ) && !defined( _WIN64 )
  #define IPPAPI( type, name, arg )   \
    static FARPROC  d##name;          \
    __declspec( naked dllexport ) type IPP_STDCALL name arg { __asm jmp d##name }

#elif defined( _WIN32E )
  #define IPPAPI( type, name, arg )   \
    static FARPROC  d##name;          \
    __declspec( naked dllexport ) type IPP_STDCALL name arg { __asm jmp d##name }

#elif defined( OSX32 )

  #define IPPAPI( type, name, arg )   \
    static FARPROC  d##name;          \
    __declspec( naked ) type IPP_STDCALL name arg {   \
         volatile register p __asm__("eax")= d##name; \
         __asm("jmp *%eax");                          \
    };

#elif defined( OSXEM64T )

  #define IPPAPI( type, name, arg )   \
    static FARPROC  d##name;          \
    __declspec( naked ) type IPP_STDCALL name arg { __asm{ jmp d##name }};

#elif defined( linux32 )

  #define IPPAPI( type, name, arg )   \
    static FARPROC  d##name;          \
    __declspec( naked ) type IPP_STDCALL name arg {   \
         volatile register p __asm__("eax")= d##name; \
         __asm("jmp *%eax");                          \
    };

#elif defined( linux32e )
  #define IPPAPI( type, name, arg )   \
    static FARPROC  d##name;          \
    __declspec( naked ) type IPP_STDCALL name arg { __asm{ jmp d##name }};

#endif


#undef _OWN_BLDPCS                             /* Force functions decl   */

#include IPP_INC_NAME()


/* /////////////////////////////////////////////////////////////////////////////
             --- Create func descriptor array, a HUGE table ---
///////////////////////////////////////////////////////////////////////////// */

typedef struct _IPP_Desc_t {
    FARPROC* pFuncAdr;
    char*    FuncName;
} IPP_Desc_t;

#undef  IPPAPI

#define IPPAPI( type, name, arg )  { &d##name, #name },

#define _OWN_BLDPCS                             /* Force functions decl */

static IPP_Desc_t IPP_Desc[] = {
#include IPP_INC_NAME()
    { 0, 0 }                                    /* Terminate init */
};




#ifndef _IPP_VERSION
#define _IPP_VERSION ""
#endif


/* /////////////////////////////////////////////////////////////////////////////
           -------- Dispatch using waterfall mechanism ---------
///////////////////////////////////////////////////////////////////////////// */


#if defined( _WIN32 ) || defined ( _WIN64 ) || defined( _WIN32E )
static HINSTANCE s_hDispatcher = 0;
#elif defined( linux )
#endif


#if defined (linux) || defined( OSX32 ) || defined( OSXEM64T )
#define HINSTANCE void*
#define HMODULE void*
#endif /* linux || osx */


static HINSTANCE SysLoadLibrary( const _TCHAR* libname )
{
    HINSTANCE hLib = 0;

#if defined( _WIN32 ) || defined( _WIN64 ) || defined( _WIN32E )

    _TCHAR buf[MAX_PATH];
    _TCHAR* ptr;
    int len;

    len = GetModuleFileName( s_hDispatcher,  (LPTSTR)buf, MAX_PATH );
    ptr = _tcsrchr( buf, _T('\\') );
    if( ptr != NULL )
    {
        *ptr = 0;
        _tcscat( buf, _T("\\")  );
        _tcscat( buf, libname );
        hLib= LoadLibrary( buf );
        if( hLib ) return hLib;
    }
    /* commented due to security reason, to prevent dll searching thru PATH env variables
    hLib= LoadLibrary( libname );
    */
    return hLib;

#elif defined( linux ) || defined ( OSX32 ) || defined ( OSXEM64T )

    Dl_info info;
    char    buf[1024];
    char    *ptr= 0;

    if( dladdr( &dllNames, &info ) ) {
        strcpy( buf, info.dli_fname );
        ptr= strrchr( buf, '/' );
        if( ptr )
        {
            *ptr= 0;
            strcat( buf, "/" );
            strcat( buf, libname );
            hLib = dlopen( buf, RTLD_LAZY );

            if( hLib ) return hLib;

            /* This is needed for error handle. We need to call dlerror
               for emtying error message. Otherwise we will recieve error
               message during loading symbols from another library */
            dlerror();
        }
    }

    hLib = dlopen( libname, RTLD_LAZY );

    if( !hLib ) {
        /* This is needed for error handle. We need to call dlerror
           for emtying error message. Otherwise we will recieve error
           message during loading symbols from another library */
        dlerror();
    }

    return hLib;

#else
  #error Undefined arch in SysLoadLibrary function
#endif
}

static void SysFreeLibrary( HINSTANCE hLib )
{
   if( hLib ){
#if defined( _WIN32 ) || defined( _WIN64 ) || defined( _WIN32E )

      FreeLibrary( hLib );

#elif defined( linux ) || defined ( OSX32 ) || defined ( OSXEM64T )

      dlclose( hLib );

#else
  #error Undefined arch in SysFreeLibrary function
#endif
   }
   return;
}

static int firstTime = 1;

static IppStatus ipp_LoadLibrary( int index, HINSTANCE* phLib )
{
    HINSTANCE hLib = 0;
    int i;
    /* some processor could work with DLL for old cpus, get pointer to list */
    const dll_enum* dllList = dllUsage[ index ];

    (*phLib) = 0;
    /* waterfall, try to load an available DLL from the list */
    for( i = 0; dllList[i] != DLL_NOMORE; i++ ) {
        hLib = SysLoadLibrary( dllNames[ dllList[i] ] );
        if( hLib ) {
           (*phLib) = hLib;
           firstTime = 0;
           if( 0 != i ){
              return ippStsWaterfall;
           } else {
              return ippStsNoErr;
           }
        }
    }

    if( firstTime ) {
        firstTime = 0;
       /* initially loading, cannot provide status to the user in this case, so error will be output */
    #if defined( _WIN32 ) || defined ( _WIN64 ) || defined( _WIN32E )
        swprintf_s( LOAD_DLL_ERR, IPP_MSG_SIZE, _T("Error at loading of %s library"), _T(IPP_LIB_SHORTNAME()) );
        MessageBeep( MB_ICONSTOP );
        MessageBox( 0, _T("No DLLs were found in the Waterfall procedure"), LOAD_DLL_ERR, MB_ICONSTOP | MB_OK );
        return MSG_NO_DLL;
    #elif defined( linux ) || defined( OSX32 ) || defined ( OSXEM64T )
        sprintf( LOAD_DLL_ERR, _T("Error at loading of %s library"), _T(IPP_LIB_SHORTNAME()) );
        fputs( _T(LOAD_DLL_ERR), stderr );
        fputs( ": ", stderr );
        fputs( _T("No shared libraries were found in the Waterfall procedure"), stderr );
        fputs( "\n", stderr );
        return MSG_NO_SHARED;
    #endif
    } else {
    #if defined( _WIN32 ) || defined ( _WIN64 ) || defined( _WIN32E )
        return MSG_NO_DLL;
    #elif defined( linux ) || defined( OSX32 ) || defined ( OSXEM64T )
        return MSG_NO_SHARED;
    #endif 
    } 
}


    static int ipp_LoadFunctions( HMODULE hLibModule, int index );

    static HMODULE  hLibModule = 0;
    static HMODULE  hLibTemp = 0;

static IppStatus IPP_STDCALL DynReload( int index )          /* library index from LIB_PX to LIB_AVX31 and higher... */
{
   IppStatus status;
  {
   if( hLibModule ) SysFreeLibrary( hLibModule );          /* if DLL is already loaded - free it */
   status= ipp_LoadLibrary( index, &hLibModule );          /* load DLL */

   if( (status >= ippStsNoErr) && hLibModule ) {           /* if DLL is loaded successfully */
     if( !ipp_LoadFunctions( hLibModule, index ) ) {       /* if functions are loaded unsuccessfully */
       SysFreeLibrary( hLibModule );                       /* Free DLL */
       hLibModule= 0;
       return ippStsLoadDynErr;
     }
   } else {
     SysFreeLibrary( hLibModule );
     hLibModule= 0;
   }
  }
   return status;
}



#if defined( _WIN32 ) || defined( _WIN32E )
    int WINAPI DllMain( HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved )
    {
        int       index;
        Ipp64u    cpuFeatures;

        s_hDispatcher = hinstDLL;

        switch( fdwReason ) {
        case DLL_PROCESS_ATTACH: {
            ippcpGetCpuFeatures( &cpuFeatures );
            owncpSetCpuFeaturesAndIdx( cpuFeatures, &index );
            if( DynReload( index ) < ippStsNoErr ) return 0;
            owncpRegisterLib( DynReload );
            break;}
        case DLL_THREAD_ATTACH: break;
        case DLL_THREAD_DETACH: break;
        case DLL_PROCESS_DETACH:
            owncpUnregisterLib( );
            if( hLibModule ) {
                FreeLibrary( hLibModule );
            }
            break;
        default:
            break;
        }
        return 1;
    }

    static int ipp_LoadFunction( HMODULE hLibModule,const void* func, char* funcname, int index )
    {
        FARPROC* funcadr=(FARPROC*)func;

        /* assign function pointers to static variable */
        (*funcadr)=GetProcAddress( hLibModule, funcname );

        if( !(*funcadr) ) {
            _TCHAR msg[128];
        #if defined( _UNICODE ) || defined( UNICODE )
            swprintf_s( msg, 128, _T("%S: "), funcname );
        #else
            sprintf_s( msg, 128, _T("%s: "), funcname );
        #endif
            DisplayLastError( msg );
           return 0;
        }
        return 1;
    }
#elif defined( linux )

//    __attribute__ ((constructor)) void my_init( void ){
    int _init( void ){
        int       index;
        Ipp64u    cpuFeatures;

        ippcpGetCpuFeatures( &cpuFeatures );
        owncpSetCpuFeaturesAndIdx( cpuFeatures, &index );
        if( DynReload( index ) < ippStsNoErr ) exit ( 1 );
        owncpRegisterLib( DynReload );
    #if defined ( linux64 )
        ippSetFlushToZero( 1, 0 );
    #endif
        return 1;
    }

//    __attribute__ ((destructor)) void my_fini( void )
    void _fini( void )
    {
        owncpUnregisterLib( );
        if( hLibModule ) {
            dlclose( hLibModule );
        }
    }

    static int ipp_LoadFunction( void* hLibModule, const void* func, char* funcname, int index )
    {
        FARPROC *funcadr=(FARPROC*)func;
        const char* error;
        /* assign function pointers to static variable */
        (*funcadr)=(FARPROC)dlsym( hLibModule, funcname );

        if( (error = dlerror()) != 0 ) {
            fputs( "dlsym: ", stderr );
            fputs( error, stderr );
            fputs( "\n", stderr );
           return 0;
        }

        return 1;
    }

#elif defined( OSX32 ) || defined (OSXEM64T )

    __attribute__((constructor)) void initializer( void )
    {
        int       index;
        Ipp64u    cpuFeatures;

        ippcpGetCpuFeatures( &cpuFeatures );
        owncpSetCpuFeaturesAndIdx( cpuFeatures, &index );
        if( DynReload( index ) < ippStsNoErr ) exit ( 1 );
        owncpRegisterLib( DynReload );
    }

    __attribute__((destructor)) void destructor()
    {
        owncpUnregisterLib( );
        if( hLibModule ) {
            dlclose( hLibModule );
        }
    }


    static int ipp_LoadFunction( void* hLibModule, const void* func, char* funcname, int index )
    {
        FARPROC *funcadr=(FARPROC*)func;
        const char* error;
        /* assign function pointers to static variable */
        (*funcadr)=(FARPROC)dlsym( hLibModule, funcname );

        if( (error = dlerror()) != 0 ) {
            fputs( "dlsym: ", stderr );
            fputs( error, stderr );
            fputs( "\n", stderr );
            return 0;
        }

        return 1;
    }

#endif


static int ipp_LoadFunctions( HMODULE hLibModule, int index )
{
    int i = 0;
    while(( IPP_Desc[i].pFuncAdr )&&( IPP_Desc[i].FuncName ))
    {
        if( !ipp_LoadFunction( hLibModule, IPP_Desc[i].pFuncAdr, IPP_Desc[i].FuncName, index ))
        {
            return 0;
        }
        i = i + 1;
    }

    if( !ipp_LoadFunction( hLibModule, (const void*)&pcpSetCpuFeatures,       ippcpSetCpuFeaturesName,       index )  ||
        !ipp_LoadFunction( hLibModule, (const void*)&pcpSetNumThreads,        ippcpSetNumThreadsName,        index )  ||
        !ipp_LoadFunction( hLibModule, (const void*)&pcpGetNumThreads,        ippcpGetNumThreadsName,        index ))
    {
        pcpSetCpuFeatures        = 0;
        pcpSetNumThreads         = 0;
        pcpGetNumThreads         = 0;
        return 0;
    }
    return 1;
}

#elif defined( _PCS_GENSTUBS )
#else
/* stub for avoiding of warning linker */


/* Include DllMain function to all Windows Intel(R) Integrated Performance Primitives (Intel(R) IPP) dll's for i_malloc initialization */
#if defined( _IPP_DYNAMIC )

#include "ippcpdefs.h"
#include "ippcp.h"

/* int ippJumpIndexForMergedDLL= 0; */   /* index for merged DLL (SSSE3+Atome) */

#if defined( _WIN32 ) || defined( _WIN32E ) 

#include <windows.h>

int WINAPI DllMain( HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved )
{
   Ipp64u     pFeaturesMask;

   switch( fdwReason ) {
    case DLL_PROCESS_ATTACH:
        break;
    case DLL_THREAD_ATTACH: break;
    case DLL_THREAD_DETACH: break;
    case DLL_PROCESS_DETACH: break;
    default: break;
   }
   return 1;
   UNREFERENCED_PARAMETER(hinstDLL);
   UNREFERENCED_PARAMETER(lpvReserved);
}
#elif defined( linux )
// __attribute__ ((constructor)) void my_init(void)
int _init(void)
{
   return 1;
}

//__attribute__ ((destructor)) void my_fini(void)
void _fini(void)
{
}

#elif defined( OSX32 ) || defined (OSXEM64T )
__attribute__((constructor)) void initializer( void )
{
    return;
}

__attribute__((destructor)) void destructor() 
{
}

#endif
#endif  /* WIN32 && IMALLOC */
#endif


/* ////////////////////////////// End of file /////////////////////////////// */

