/*

  Copyright (c) 2003-2008 uim Project http://code.google.com/p/uim/

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
  3. Neither the name of authors nor the names of its contributors
     may be used to endorse or promote products derived from this software
     without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

*/

#ifndef UIM_REPLACE_OS_DEP_H
#define UIM_REPLACE_OS_DEP_H

/* stdint.h compatible type definitions */
#if HAVE_STDINT_H
#include <stdint.h>
#endif
#if HAVE_INTTYPES_H
#include <inttypes.h>
#endif
#if HAVE_SYS_INTTYPES_H
#include <sys/inttypes.h>
#endif
#if HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#if HAVE_STDARG_H
#include <stdarg.h>
#endif
#include <limits.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef HAVE_GETPEEREID
#include <sys/types.h>
#define getpeereid	uim_getpeereid
int getpeereid(int , uid_t *, gid_t *);
#endif

#ifndef HAVE_SETENV
#define setenv	uim_setenv
int setenv(const char *, const char *, int);
#endif

#ifndef HAVE_UNSETENV
#define unsetenv	uim_unsetenv
void unsetenv(const char *);
#endif

#ifndef HAVE_STRSEP
#define strsep	uim_strsep
char *strsep(char **stringp, const char *delim);
#endif

#ifndef HAVE_STRLCPY
#define strlcpy	uim_strlcpy
size_t strlcpy(char *dst, const char *src, size_t siz);
#endif

#ifndef HAVE_STRLCAT
#define strlcat	uim_strlcat
size_t strlcat(char *dst, const char *src, size_t siz);
#endif

#include "fake-rfc2553.h"

#ifndef HAVE_VASPRINTF
#define vasprintf	uim_vasprintf
int vasprintf(char **ret, const char *format, va_list ap);
#endif

#ifndef HAVE_ASPRINTF
#define asprintf	uim_asprintf
int asprintf(char **ret, const char *format, ...);
#endif

#if !defined(HAVE_VSNPRINTF) || defined(BROKEN_SNPRINTF)
#define vsnprintf	uim_vsnprintf
int vsnprintf(char *str, size_t size, const char *format, va_list ap);
#endif

#if !defined(HAVE_SNPRINTF) || defined(BROKEN_SNPRINTF)
#define snprintf	uim_snprintf
int snprintf(char *str, size_t size, const char *format, ...);
#endif

#ifndef HAVE_STRTOLL
#define strtoll	uim_strtoll
long long strtoll(const char *, char **, int);
#endif

#ifndef HAVE_STRTONUM
#define strtonum	uim_strtonum
long long strtonum(const char *numstr, long long minval, long long maxval, const char **errstrp);
#endif

#ifdef __cplusplus
}
#endif
#endif /* UIM_REPLACE_OS_DEP_H */