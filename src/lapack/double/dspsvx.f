      SUBROUTINE DSPSVX( FACT, UPLO, N, NRHS, AP, AFP, IPIV, B, LDB, X,
     $                   LDX, RCOND, FERR, BERR, WORK, IWORK, INFO )
*
*  -- LAPACK driver routine (version 1.1) --
*     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
*     Courant Institute, Argonne National Lab, and Rice University
*     March 31, 1993
*
*     .. Scalar Arguments ..
      CHARACTER          FACT, UPLO
      INTEGER            INFO, LDB, LDX, N, NRHS
      DOUBLE PRECISION   RCOND
*     ..
*     .. Array Arguments ..
      INTEGER            IPIV( * ), IWORK( * )
      DOUBLE PRECISION   AFP( * ), AP( * ), B( LDB, * ), BERR( * ),
     $                   FERR( * ), WORK( * ), X( LDX, * )
*     ..
*
*  Purpose
*  =======
*
*  DSPSVX uses the diagonal pivoting factorization A = U*D*U**T or
*  A = L*D*L**T to compute the solution to a real system of linear
*  equations A * X = B, where A is an N-by-N symmetric matrix stored
*  in packed format and X and B are N-by-NRHS matrices.
*
*  Error bounds on the solution and a condition estimate are also
*  provided.
*
*  Description
*  ===========
*
*  The following steps are performed:
*
*  1. If FACT = 'N', the diagonal pivoting method is used to factor A as
*        A = U * D * U**T,  if UPLO = 'U', or
*        A = L * D * L**T,  if UPLO = 'L',
*     where U (or L) is a product of permutation and unit upper (lower)
*     triangular matrices and D is symmetric and block diagonal with
*     1-by-1 and 2-by-2 diagonal blocks.
*
*  2. The factored form of A is used to estimate the condition number
*     of the matrix A.  If the reciprocal of the condition number is
*     less than machine precision, steps 3 and 4 are skipped.
*
*  3. The system of equations is solved for X using the factored form
*     of A.
*
*  4. Iterative refinement is applied to improve the computed solution
*     matrix and calculate error bounds and backward error estimates
*     for it.
*
*  Arguments
*  =========
*
*  FACT    (input) CHARACTER*1
*          Specifies whether or not the factored form of A has been
*          supplied on entry.
*          = 'F':  On entry, AFP and IPIV contain the factored form of
*                  A.  AP, AFP and IPIV will not be modified.
*          = 'N':  The matrix A will be copied to AFP and factored.
*
*  UPLO    (input) CHARACTER*1
*          = 'U':  Upper triangle of A is stored;
*          = 'L':  Lower triangle of A is stored.
*
*  N       (input) INTEGER
*          The number of linear equations, i.e., the order of the
*          matrix A.  N >= 0.
*
*  NRHS    (input) INTEGER
*          The number of right hand sides, i.e., the number of columns
*          of the matrices B and X.  NRHS >= 0.
*
*  AP      (input) DOUBLE PRECISION array, dimension (N*(N+1)/2)
*          The upper or lower triangle of the symmetric matrix A, packed
*          columnwise in a linear array.  The j-th column of A is stored
*          in the array AP as follows:
*          if UPLO = 'U', AP(i + (j-1)*j/2) = A(i,j) for 1<=i<=j;
*          if UPLO = 'L', AP(i + (j-1)*(2n-j)/2) = A(i,j) for j<=i<=n.
*          See below for further details.
*
*  AFP     (input or output) DOUBLE PRECISION array, dimension
*                            (N*(N+1)/2)
*          If FACT = 'F', then AFP is an input argument and on entry
*          contains the block diagonal matrix D and the multipliers used
*          to obtain the factor U or L from the factorization
*          A = U*D*U**T or A = L*D*L**T as computed by DSPTRF, stored as
*          a packed triangular matrix in the same storage format as A.
*
*          If FACT = 'N', then AFP is an output argument and on exit
*          contains the block diagonal matrix D and the multipliers used
*          to obtain the factor U or L from the factorization
*          A = U*D*U**T or A = L*D*L**T as computed by DSPTRF, stored as
*          a packed triangular matrix in the same storage format as A.
*
*  IPIV    (input or output) INTEGER array, dimension (N)
*          If FACT = 'F', then IPIV is an input argument and on entry
*          contains details of the interchanges and the block structure
*          of D, as determined by DSPTRF.
*          If IPIV(k) > 0, then rows and columns k and IPIV(k) were
*          interchanged and D(k,k) is a 1-by-1 diagonal block.
*          If UPLO = 'U' and IPIV(k) = IPIV(k-1) < 0, then rows and
*          columns k-1 and -IPIV(k) were interchanged and D(k-1:k,k-1:k)
*          is a 2-by-2 diagonal block.  If UPLO = 'L' and IPIV(k) =
*          IPIV(k+1) < 0, then rows and columns k+1 and -IPIV(k) were
*          interchanged and D(k:k+1,k:k+1) is a 2-by-2 diagonal block.
*
*          If FACT = 'N', then IPIV is an output argument and on exit
*          contains details of the interchanges and the block structure
*          of D, as determined by DSPTRF.
*
*  B       (input) DOUBLE PRECISION array, dimension (LDB,NRHS)
*          The N-by-NRHS right hand side matrix B.
*
*  LDB     (input) INTEGER
*          The leading dimension of the array B.  LDB >= max(1,N).
*
*  X       (output) DOUBLE PRECISION array, dimension (LDX,NRHS)
*          If INFO = 0, the N-by-NRHS solution matrix X.
*
*  LDX     (input) INTEGER
*          The leading dimension of the array X.  LDX >= max(1,N).
*
*  RCOND   (output) DOUBLE PRECISION
*          The estimate of the reciprocal condition number of the matrix
*          A.  If RCOND is less than the machine precision (in
*          particular, if RCOND = 0), the matrix is singular to working
*          precision.  This condition is indicated by a return code of
*          INFO > 0, and the solution and error bounds are not computed.
*
*  FERR    (output) DOUBLE PRECISION array, dimension (NRHS)
*          The estimated forward error bounds for each solution vector
*          X(j) (the j-th column of the solution matrix X).
*          If XTRUE is the true solution, FERR(j) bounds the magnitude
*          of the largest entry in (X(j) - XTRUE) divided by the
*          magnitude of the largest entry in X(j).  The quality of the
*          error bound depends on the quality of the estimate of
*          norm(inv(A)) computed in the code; if the estimate of
*          norm(inv(A)) is accurate, the error bound is guaranteed.
*
*  BERR    (output) DOUBLE PRECISION array, dimension (NRHS)
*          The componentwise relative backward error of each solution
*          vector X(j) (i.e., the smallest relative change in any
*          entry of A or B that makes X(j) an exact solution).
*
*  WORK    (workspace) DOUBLE PRECISION array, dimension (3*N)
*
*  IWORK   (workspace) INTEGER array, dimension (N)
*
*  INFO    (output) INTEGER
*          = 0: successful exit
*          < 0: if INFO = -i, the i-th argument had an illegal value
*          > 0 and <= N: if INFO = i, D(i,i) is exactly zero.  The
*               factorization has been completed, but the block diagonal
*               matrix D is exactly singular, so the solution and error
*               bounds could not be computed.
*          = N+1: the block diagonal matrix D is nonsingular, but RCOND
*               is less than machine precision.  The factorization has
*               been completed, but the matrix is singular to working
*               precision, so the solution and error bounds have not
*               been computed.
*
*  Further Details
*  ===============
*
*  The packed storage scheme is illustrated by the following example
*  when N = 4, UPLO = 'U':
*
*  Two-dimensional storage of the symmetric matrix A:
*
*     a11 a12 a13 a14
*         a22 a23 a24
*             a33 a34     (aij = aji)
*                 a44
*
*  Packed storage of the upper triangle of A:
*
*  AP = [ a11, a12, a22, a13, a23, a33, a14, a24, a34, a44 ]
*
*  =====================================================================
*
*     .. Parameters ..
      DOUBLE PRECISION   ZERO
      PARAMETER          ( ZERO = 0.0D+0 )
*     ..
*     .. Local Scalars ..
      LOGICAL            NOFACT
      DOUBLE PRECISION   ANORM
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      DOUBLE PRECISION   DLAMCH, DLANSP
      EXTERNAL           LSAME, DLAMCH, DLANSP
*     ..
*     .. External Subroutines ..
      EXTERNAL           DCOPY, DLACPY, DSPCON, DSPRFS, DSPTRF, DSPTRS,
     $                   XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX
*     ..
*     .. Executable Statements ..
*
*     Test the input parameters.
*
      INFO = 0
      NOFACT = LSAME( FACT, 'N' )
      IF( .NOT.NOFACT .AND. .NOT.LSAME( FACT, 'F' ) ) THEN
         INFO = -1
      ELSE IF( .NOT.LSAME( UPLO, 'U' ) .AND. .NOT.LSAME( UPLO, 'L' ) )
     $          THEN
         INFO = -2
      ELSE IF( N.LT.0 ) THEN
         INFO = -3
      ELSE IF( NRHS.LT.0 ) THEN
         INFO = -4
      ELSE IF( LDB.LT.MAX( 1, N ) ) THEN
         INFO = -9
      ELSE IF( LDX.LT.MAX( 1, N ) ) THEN
         INFO = -11
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'DSPSVX', -INFO )
         RETURN
      END IF
*
      IF( NOFACT ) THEN
*
*        Compute the factorization A = U*D*U' or A = L*D*L'.
*
         CALL DCOPY( N*( N+1 ) / 2, AP, 1, AFP, 1 )
         CALL DSPTRF( UPLO, N, AFP, IPIV, INFO )
*
*        Return if INFO is non-zero.
*
         IF( INFO.NE.0 ) THEN
            IF( INFO.GT.0 )
     $         RCOND = ZERO
            RETURN
         END IF
      END IF
*
*     Compute the norm of the matrix A.
*
      ANORM = DLANSP( 'I', UPLO, N, AP, WORK )
*
*     Compute the reciprocal of the condition number of A.
*
      CALL DSPCON( UPLO, N, AFP, IPIV, ANORM, RCOND, WORK, IWORK, INFO )
*
*     Return if the matrix is singular to working precision.
*
      IF( RCOND.LT.DLAMCH( 'Epsilon' ) ) THEN
         INFO = N + 1
         RETURN
      END IF
*
*     Compute the solution vectors X.
*
      CALL DLACPY( 'Full', N, NRHS, B, LDB, X, LDX )
      CALL DSPTRS( UPLO, N, NRHS, AFP, IPIV, X, LDX, INFO )
*
*     Use iterative refinement to improve the computed solutions and
*     compute error bounds and backward error estimates for them.
*
      CALL DSPRFS( UPLO, N, NRHS, AP, AFP, IPIV, B, LDB, X, LDX, FERR,
     $             BERR, WORK, IWORK, INFO )
*
      RETURN
*
*     End of DSPSVX
*
      END
