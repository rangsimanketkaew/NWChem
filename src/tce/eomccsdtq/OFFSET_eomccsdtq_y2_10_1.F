      SUBROUTINE OFFSET_eomccsdtq_y2_10_1(l_a_offset,k_a_offset,size)
C     $Id$
C     This is a Fortran77 program generated by Tensor Contraction Engine v.1.0
C     Copyright (c) Battelle & Pacific Northwest National Laboratory (2002)
C     i1 ( h3 p13 h11 h14 )_v
      IMPLICIT NONE
#include "global.fh"
#include "mafdecls.fh"
#include "sym.fh"
#include "errquit.fh"
#include "tce.fh"
      INTEGER l_a_offset
      INTEGER k_a_offset
      INTEGER size
      INTEGER length
      INTEGER addr
      INTEGER h3b
      INTEGER p13b
      INTEGER h11b
      INTEGER h14b
      length = 0
      DO h3b = 1,noab
      DO p13b = noab+1,noab+nvab
      DO h11b = 1,noab
      DO h14b = h11b,noab
      IF (int_mb(k_spin+h3b-1)+int_mb(k_spin+p13b-1) .eq. int_mb(k_spin+
     &h11b-1)+int_mb(k_spin+h14b-1)) THEN
      IF (ieor(int_mb(k_sym+h3b-1),ieor(int_mb(k_sym+p13b-1),ieor(int_mb
     &(k_sym+h11b-1),int_mb(k_sym+h14b-1)))) .eq. irrep_v) THEN
      IF ((.not.restricted).or.(int_mb(k_spin+h3b-1)+int_mb(k_spin+p13b-
     &1)+int_mb(k_spin+h11b-1)+int_mb(k_spin+h14b-1).ne.8)) THEN
      length = length + 1
      END IF
      END IF
      END IF
      END DO
      END DO
      END DO
      END DO
      IF (.not.MA_PUSH_GET(mt_int,2*length+1,'noname',l_a_offset,k_a_off
     &set)) CALL ERRQUIT('eomccsdtq_y2_10_1',0,MA_ERR)
      int_mb(k_a_offset) = length
      addr = 0
      size = 0
      DO h3b = 1,noab
      DO p13b = noab+1,noab+nvab
      DO h11b = 1,noab
      DO h14b = h11b,noab
      IF (int_mb(k_spin+h3b-1)+int_mb(k_spin+p13b-1) .eq. int_mb(k_spin+
     &h11b-1)+int_mb(k_spin+h14b-1)) THEN
      IF (ieor(int_mb(k_sym+h3b-1),ieor(int_mb(k_sym+p13b-1),ieor(int_mb
     &(k_sym+h11b-1),int_mb(k_sym+h14b-1)))) .eq. irrep_v) THEN
      IF ((.not.restricted).or.(int_mb(k_spin+h3b-1)+int_mb(k_spin+p13b-
     &1)+int_mb(k_spin+h11b-1)+int_mb(k_spin+h14b-1).ne.8)) THEN
      addr = addr + 1
      int_mb(k_a_offset+addr) = h14b - 1 + noab * (h11b - 1 + noab * (p1
     &3b - noab - 1 + nvab * (h3b - 1)))
      int_mb(k_a_offset+length+addr) = size
      size = size + int_mb(k_range+h3b-1) * int_mb(k_range+p13b-1) * int
     &_mb(k_range+h11b-1) * int_mb(k_range+h14b-1)
      END IF
      END IF
      END IF
      END DO
      END DO
      END DO
      END DO
      RETURN
      END
