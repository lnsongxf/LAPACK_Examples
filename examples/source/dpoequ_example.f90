    Program dpoequ_example

!     DPOEQU Example Program Text

!     Copyright (c) 2018, Numerical Algorithms Group (NAG Ltd.)
!     For licence see
!       https://github.com/numericalalgorithmsgroup/LAPACK_Examples/blob/master/LICENCE.md

!     .. Use Statements ..
      Use blas_interfaces, Only: dscal
      Use lapack_example_aux, Only: nagf_blas_ddscl, &
        nagf_file_print_matrix_real_gen
      Use lapack_interfaces, Only: dpoequ
      Use lapack_precision, Only: dp
!     .. Implicit None Statement ..
      Implicit None
!     .. Parameters ..
      Real (Kind=dp), Parameter :: one = 1.0_dp
      Real (Kind=dp), Parameter :: thresh = 0.1_dp
      Integer, Parameter :: nin = 5, nout = 6
!     .. Local Scalars ..
      Real (Kind=dp) :: amax, big, scond, small
      Integer :: i, ifail, info, j, lda, n
!     .. Local Arrays ..
      Real (Kind=dp), Allocatable :: a(:, :), s(:)
!     .. Intrinsic Procedures ..
      Intrinsic :: epsilon, radix, real, tiny
!     .. Executable Statements ..
      Write (nout, *) 'DPOEQU Example Program Results'
      Write (nout, *)
      Flush (nout)
!     Skip heading in data file
      Read (nin, *)
      Read (nin, *) n
      lda = n
      Allocate (a(lda,n), s(n))

!     Read the upper triangular part of the matrix A from data file

      Read (nin, *)(a(i,i:n), i=1, n)

!     Print the matrix A

!     ifail: behaviour on error exit
!             =0 for hard exit, =1 for quiet-soft, =-1 for noisy-soft
      ifail = 0
      Call nagf_file_print_matrix_real_gen('Upper', 'Non-unit', n, n, a, lda, &
        'Matrix A', ifail)

      Write (nout, *)

!     Compute diagonal scaling factors
      Call dpoequ(n, a, lda, s, scond, amax, info)

      If (info>0) Then
        Write (nout, 100) 'Diagonal element', info, ' of A is non positive'
      Else

!       Print SCOND, AMAX and the scale factors

        Write (nout, 110) 'SCOND =', scond, ', AMAX =', amax
        Write (nout, *)
        Write (nout, *) 'Diagonal scaling factors'
        Write (nout, 120) s(1:n)
        Write (nout, *)
        Flush (nout)

!       Compute values close to underflow and overflow

        small = tiny(1.0E0_dp)/(epsilon(1.0E0_dp)*real(radix(1.0E0_dp),kind=dp &
          ))
        big = one/small
        If ((scond<thresh) .Or. (amax<small) .Or. (amax>big)) Then

!         Scale A
          Do j = 1, n
            Call dscal(j, s(j), a(1,j), 1)
            Call nagf_blas_ddscl(j, s, 1, a(1,j), 1)
          End Do

!         Print the scaled matrix

          ifail = 0
          Call nagf_file_print_matrix_real_gen('Upper', 'Non-unit', n, n, a, &
            lda, 'Scaled matrix', ifail)

        End If
      End If

100   Format (1X, A, I4, A)
110   Format (1X, 2(A,1P,E8.1))
120   Format ((1X,1P,7E11.1))
    End Program
