! Standalone sample; not part of the app build.
program granth_list
  implicit none
  character(len=12) :: granths(3) = [character(len=12) :: 'Gita', 'Kabir Sagar', 'Ved']
  integer :: i
  do i = 1, 3
    print '(I0, ". ", A)', i, trim(granths(i))
  end do
end program granth_list
