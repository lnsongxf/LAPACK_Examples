    Program ztftri_example

!     ZTFTRI Example Program Text

!     Copyright 2017, Numerical Algorithms Group Ltd. http://www.nag.com

!     .. Use Statements ..
      Use lapack_example_aux, Only: nagf_file_print_matrix_complex_gen_comp
      Use lapack_interfaces, Only: ztftri, ztfttr
      Use lapack_precision, Only: dp
!     .. Implicit None Statement ..
      Implicit None
!     .. Parameters ..
      Integer, Parameter :: nin = 5, nout = 6
!     .. Local Scalars ..
      Integer :: i, ifail, info, k, lar1, lda, lenar, n, q
      Character (1) :: diag, transr, uplo
!     .. Local Arrays ..
      Complex (Kind=dp), Allocatable :: a(:, :), ar(:)
      Character (1) :: clabs(1), rlabs(1)
!     .. Executable Statements ..
      Write (nout, *) 'ZTFTRI Example Program Results'
!     Skip heading in data file
      Read (nin, *)
      Read (nin, *) n, uplo, transr, diag

      lenar = n*(n+1)/2
      lda = n
      Allocate (ar(1:lenar), a(lda,n))

!     Setup notional dimensions of RFP matrix AR
      k = n/2
      q = n - k
      If (transr=='N' .Or. transr=='n') Then
        lar1 = 2*k + 1
      Else
        lar1 = q
      End If

!     Read an RFP matrix into array AR
      Do i = 1, lar1
        Read (nin, *) ar(i:lenar:lar1)
      End Do

!     Compute inverse of A
      Call ztftri(transr, uplo, diag, n, ar, info)

      Write (nout, *)
      Flush (nout)
      If (info==0) Then

!       Convert and print inverse
        Call ztfttr(transr, uplo, n, ar, a, lda, info)
        ifail = 0

        Call nagf_file_print_matrix_complex_gen_comp(uplo, 'Nonunit', n, n, a, &
          lda, 'Bracketed', 'F7.4', 'Inverse', 'Integer', rlabs, 'Integer', &
          clabs, 80, 0, ifail)
      Else
        Write (nout, *) 'A is singular'
      End If

    End Program