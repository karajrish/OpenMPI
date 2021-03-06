/* ompi/include/ompi_config.h.  Generated from ompi_config.h.in by configure.  */
/* -*- c -*-
 *
 * Copyright (c) 2004-2005 The Trustees of Indiana University and Indiana
 *                         University Research and Technology
 *                         Corporation.  All rights reserved.
 * Copyright (c) 2004-2006 The University of Tennessee and The University
 *                         of Tennessee Research Foundation.  All rights
 *                         reserved.
 * Copyright (c) 2004-2005 High Performance Computing Center Stuttgart,
 *                         University of Stuttgart.  All rights reserved.
 * Copyright (c) 2004-2005 The Regents of the University of California.
 *                         All rights reserved.
 * Copyright (c) 2007-2012 Cisco Systems, Inc.  All rights reserved.
 * Copyright (c) 2007      Sun Microsystems, Inc.  All rights reserved.
 * $COPYRIGHT$
 *
 * Additional copyrights may follow
 *
 * $HEADER$
 *
 * Function: - OS, CPU and compiler dependent configuration
 */

#ifndef OMPI_CONFIG_H
#define OMPI_CONFIG_H

#include "opal_config.h"

#define OMPI_IDENT_STRING OPAL_IDENT_STRING

/***********************************************************************
 *
 * OMPI-specific Fortran code that should be in ompi_config.h, but not
 * in the other projects.
 *
 **********************************************************************/

/* MPI_Fint is the same as ompi_fortran_INTEGER_t */
#define MPI_Fint ompi_fortran_integer_t

#if defined(__WINDOWS__)

#  if defined(_USRDLL)    /* building shared libraries (.DLL) */
#    if defined(OMPI_EXPORTS)
#      define OMPI_DECLSPEC        __declspec(dllexport)
#      define OMPI_MODULE_DECLSPEC
#    else
#      if defined(OMPI_IMPORTS)
#        define OMPI_DECLSPEC      __declspec(dllimport)
#      else
#        define OMPI_DECLSPEC
#      endif  /*defined(OMPI_IMPORTS)*/
#      if defined(OMPI_MODULE_EXPORTS)
#        define OMPI_MODULE_DECLSPEC __declspec(dllexport)
#      else
#        define OMPI_MODULE_DECLSPEC __declspec(dllimport)
#      endif  /* defined(OMPI_MODULE_EXPORTS) */
#    endif  /* defined(OMPI_EXPORTS) */
#  else          /* building static library */
#    if defined(OMPI_IMPORTS)
#      define OMPI_DECLSPEC        __declspec(dllimport)
#    else
#      define OMPI_DECLSPEC
#    endif  /* defined(OMPI_IMPORTS) */
#    define OMPI_MODULE_DECLSPEC
#  endif  /* defined(_USRDLL) */

#else

#  if OPAL_C_HAVE_VISIBILITY
#    ifndef OMPI_DECLSPEC
#      define OMPI_DECLSPEC            __opal_attribute_visibility__("default")
#    endif
#    ifndef OMPI_MODULE_DECLSPEC
#      define OMPI_MODULE_DECLSPEC     __opal_attribute_visibility__("default")
#    endif
#  else
#    ifndef OMPI_DECLSPEC
#      define OMPI_DECLSPEC
#    endif
#    ifndef OMPI_MODULE_DECLSPEC
#      define OMPI_MODULE_DECLSPEC
#    endif
#  endif
#endif  /* defined(__WINDOWS__) */

/* Convenience */
#if OMPI_BUILD_FORTRAN_MPIFH_BINDINGS || OMPI_BUILD_FORTRAN_USEMPI_BINDINGS || OMPI_BUILD_FORTRAN_USEMPIF08_BINDINGS
#define OMPI_BUILD_FORTRAN_BINDINGS 1
#else
#define OMPI_BUILD_FORTRAN_BINDINGS 0
#endif

#endif
