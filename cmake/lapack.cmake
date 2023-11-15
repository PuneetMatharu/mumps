# Handle options for finding LAPACK

include(CheckSourceCompiles)

if(NOT DEFINED LAPACK_VENDOR AND DEFINED ENV{MKLROOT})
set(LAPACK_VENDOR MKL)
endif()

set(REQUIRED_LAPACK_COMPONENTS ${LAPACK_VENDOR})

if(find_static)
  list(APPEND REQUIRED_LAPACK_COMPONENTS STATIC)
endif()

find_package(LAPACK REQUIRED COMPONENTS ${REQUIRED_LAPACK_COMPONENTS})

# GEMMT is recommeded in MUMPS User Manual if available
if(gemmt)

set(CMAKE_REQUIRED_INCLUDES ${LAPACK_INCLUDE_DIRS})

if(find_static AND NOT WIN32 AND
  MKL IN_LIST REQUIRED_LAPACK_COMPONENTS AND
  CMAKE_VERSION VERSION_GREATER_EQUAL 3.24
  )
  set(CMAKE_REQUIRED_LIBRARIES $<LINK_GROUP:RESCAN,${LAPACK_LIBRARIES}>)
else()
  set(CMAKE_REQUIRED_LIBRARIES ${LAPACK_LIBRARIES})
endif()

if(BUILD_DOUBLE)
check_source_compiles(Fortran
"program check
use, intrinsic :: iso_fortran_env, only : real64
implicit none
external :: dgemmt
real(real64), dimension(2,2) :: A, B, C
CALL DGEMMT( 'U', 'N', 'T',  2 , 1 , 1._real64 , A , 2 , B , 2 , 1._real64 , C , 2 )
end program"
BLAS_HAVE_dGEMMT
)
endif()

if(BUILD_SINGLE)
check_source_compiles(Fortran
"program check
use, intrinsic :: iso_fortran_env, only : real32
implicit none
external :: sgemmt
real(real32), dimension(2,2) :: A, B, C
CALL SGEMMT( 'U', 'N', 'T',  2 , 1 , 1._real32 , A , 2 , B , 2 , 1._real32 , C , 2 )
end program"
BLAS_HAVE_sGEMMT
)
endif()

if(BUILD_COMPLEX)
check_source_compiles(Fortran
"program check
use, intrinsic :: iso_fortran_env, only : real32
implicit none
external :: cgemmt
complex(real32), dimension(2,2) :: A, B, C
CALL CGEMMT( 'U', 'N', 'T',  2 , 1 , 1._real32 , A , 2 , B , 2 , 1._real32 , C , 2 )
end program"
BLAS_HAVE_cGEMMT
)
endif()

if(BUILD_COMPLEX16)
check_source_compiles(Fortran
"program check
use, intrinsic :: iso_fortran_env, only : real64
implicit none
external :: zgemmt
complex(real64), dimension(2,2) :: A, B, C
CALL ZGEMMT( 'U', 'N', 'T',  2 , 1 , 1._real64 , A , 2 , B , 2 , 1._real64 , C , 2 )
end program"
BLAS_HAVE_zGEMMT
)
endif()

endif(gemmt)
