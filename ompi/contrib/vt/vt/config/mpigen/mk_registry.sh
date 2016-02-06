##
# config/mpigen/mk_registry.sh.  Generated from mk_registry.sh.in by configure.
#
# make vtlib/vt_mpireg.gen.[c|h]
##

# exit the script if any statement returns a non-true return value
set -e



export SRCDIR=/home/nova/OpenMPI/openmpi-1.8.1/ompi/contrib/vt/vt/config/mpigen

have_mpi2_thread=1
have_mpi2_1sided=1
have_mpi2_extcoll=1
have_mpi2_file=1
have_mpi2_proc=0 #@VT_MPIGEN_HAVE_MPI2_PROC@
have_mpi2=0
if [ $have_mpi2_thread = 1 -o $have_mpi2_1sided = 1 -o $have_mpi2_extcoll = 1 -o $have_mpi2_proc = 1 ] ; then
  have_mpi2=1
fi
mpi2_src1=""; if [ $have_mpi2 = 1 ] ; then mpi2_src1="mpi2_standard.h"; fi
mpi2_src2=""; if [ $have_mpi2_thread = 1 ] ; then mpi2_src2="mpi2_thread.h"; fi
mpi2_src3=""; if [ $have_mpi2_1sided = 1 ] ; then mpi2_src3="mpi2_1sided.h"; fi
mpi2_src4=""; if [ $have_mpi2_extcoll = 1 ] ; then mpi2_src4="mpi2_extcoll.h"; fi
mpi2_src5=""; if [ $have_mpi2_file = 1 ] ; then mpi2_src5="mpi2_file.h"; fi
mpi2_src6=""; if [ $have_mpi2_proc = 1 ] ; then mpi2_src6="mpi2_proc.h"; fi
src="mpi_standard.h $mpi2_src1 $mpi2_src2 $mpi2_src3 $mpi2_src4 $mpi2_src5 $mpi2_src6"

outprefix=/home/nova/OpenMPI/openmpi-1.8.1/ompi/contrib/vt/vt/vtlib/vt_mpireg.gen
tmp=tmp$$
trap "rm -f $tmp.*; exit" 0 1 2 3 15

rm -f $tmp.tmp $outprefix.c $outprefix.h
for s in $src; do
  if [ ! -f $SRCDIR/$s ] ; then
    echo "$0: error: $SRCDIR/$s not found!"
    exit 1
  fi

  grep ' MPI_.*(.*)' $SRCDIR/$s \
  | sed >>$tmp.tmp \
    -e '/typedef /d' \
    -e 's/( *void *)/()/' \
    -e 's/   */ /g' \
    -e 's/ /,/' \
    -e 's/(/,/' \
    -e 's/);//' \
    -e 's/, /,/g' \
    -e 's/,$//'
done

cat <<End-of-File >$tmp.h
/**
 * VampirTrace
 * http://www.tu-dresden.de/zih/vampirtrace
 *
 * Copyright (c) 2005-2013, ZIH, TU Dresden, Federal Republic of Germany
 *
 * Copyright (c) 1998-2005, Forschungszentrum Juelich, Juelich Supercomputing
 *                          Centre, Federal Republic of Germany
 *
 * See the file COPYING in the package base directory for details
 *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * ! BUILT BY mk_registry.sh; DO NOT EDIT THIS FILE        !
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 **/

End-of-File

export IDX=0

cat <<End-of-File >$tmp.awk
{
# MPI function registry
#
# \$1 is the return type
# \$2 is the call name
# \$3,\$4,... parameters
  mpicall=\$2

  idx=ENVIRON["IDX"]++

  printf "#define VT__%s %i\n", toupper(mpicall), idx++
}
End-of-File

gawk -f $tmp.awk -F, <$tmp.tmp >>$tmp.h
if test $? -ne 0; then exit $?; fi

num=`grep VT__ $tmp.h | wc -l`

cat <<End-of-File >>$tmp.h
#define VT__MPI_REGID_NUM $num

End-of-File

mv $tmp.h $outprefix.h
rm $tmp.awk

cat <<End-of-File >$tmp.c
/**
 * VampirTrace
 * http://www.tu-dresden.de/zih/vampirtrace
 *
 * Copyright (c) 2005-2013, ZIH, TU Dresden, Federal Republic of Germany
 *
 * Copyright (c) 1998-2005, Forschungszentrum Juelich, Juelich Supercomputing
 *                          Centre, Federal Republic of Germany
 *
 * See the file COPYING in the package base directory for details
 *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * ! BUILT BY mk_registry.sh; DO NOT EDIT THIS FILE        !
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 **/

End-of-File

cat <<End-of-File >$tmp.awk
{
# MPI function registry
#
# \$1 is the return type
# \$2 is the call name
# \$3, \$4,... parameters
  mpicall=\$2

  if ( index(mpicall,"MPI_Init") > 0 )
    next;

  split(\$NF,lastparam, " ")

  if ( lastparam[3] == "/*COLL_BARRIER*/" )
    type="VT_MPI_COLL_BARRIER"
  else if ( lastparam[3] == "/*COLL_ONE2ALL*/" )
    type="VT_MPI_COLL_ONE2ALL"
  else if ( lastparam[3] == "/*COLL_ALL2ONE*/" )
    type="VT_MPI_COLL_ALL2ONE"
  else if ( lastparam[3] == "/*COLL_ALL2ALL*/" )
    type="VT_MPI_COLL_ALL2ALL"
  else
    type="VT_MPI_FUNCTION"

  printf"  vt_mpi_regid[VT__%s] =\n", toupper(mpicall)
  printf"    vt_def_region(VT_CURRENT_THREAD, \\"%s\\", mpi_fid, VT_NO_LNO, VT_NO_LNO, NULL, %s);\n",
    mpicall, type
}
End-of-File

gawk -f $tmp.awk -F, <$tmp.tmp >>$tmp.c
if test $? -ne 0; then exit $?; fi

mv $tmp.c $outprefix.c
rm $tmp.awk

exit 0
