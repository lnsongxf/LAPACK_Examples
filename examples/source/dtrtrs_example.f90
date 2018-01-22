    Program dtrtrs_example

!     DTRTRS Example Program Text

!     Copyright 2017, Numerical Algorithms Group Ltd. http://www.nag.com

!     .. Use Statements ..
      Use lapack_example_aux, Only: nagf_file_print_matrix_real_gen
      Use lapack_interfaces, Only: dtrtrs
      Use lapack_precision, Only: dp
!     .. Implicit None Statement ..
      Implicit None
!     .. Parameters ..
      Integer, Parameter :: nin = 5, nout = 6
      Character (1), Parameter :: diag = 'N', trans = 'N'
!     .. Local Scalars ..
      Integer :: i, ifail, info, lda, ldb, n, nrhs
      Character (1) :: uplo
!     .. Local Arrays ..
      Real (Kind=dp), Allocatable :: a(:, :), b(:, :)
!     .. Executable Statements ..
      Write (nout, *) 'DTRTRS Example Program Results'
!     Skip heading in data file
      Read (nin, *)
      Read (nin, *) n, nrhs
      lda = n
      ldb = n
      Allocate (a(lda,n), b(ldb,nrhs))

!     Read A and B from data file

      Read (nin, *) uplo
      If (uplo=='U') Then
        Read (nin, *)(a(i,i:n), i=1, n)
      Else If (uplo=='L') Then
        Read (nin, *)(a(i,1:i), i=1, n)
      End If
      Read (nin, *)(b(i,1:nrhs), i=1, n)

!     Compute solution

      Call dtrtrs(uplo, trans, diag, n, nrhs, a, lda, b, ldb, info)

!     Print solution

      Write (nout, *)
      Flush (nout)
      If (info==0) Then

!       ifail: behaviour on error exit
!              =0 for hard exit, =1 for quiet-soft, =-1 for noisy-soft
        ifail = 0
        Call nagf_file_print_matrix_real_gen('General', ' ', n, nrhs, b, ldb, &
          'Solution(s)', ifail)

      Else
        Write (nout, *) 'A is singular'
      End If

    End Program