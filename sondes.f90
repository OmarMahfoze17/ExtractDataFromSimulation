program sondes

implicit none

integer,parameter :: nt=1,nx=16
real(8),dimension(nx) :: ux1,uy1,uz1
real(8),dimension(nt,nx) :: ux1F,uy1F,uz1F
integer :: i,itime

open(10,file='sondes0000',form='unformatted')
do itime=1,nt
read(10) ux1,uy1,uz1
ux1F(itime,:)=ux1(:)
uy1F(itime,:)=uy1(:)
uz1F(itime,:)=uz1(:)
enddo
close(10)

open(774,file='signal.dat',form='formatted',status='unknown')
do i=1,nt
   write(774,*) (i-1)*0.005,ux1F(i,2),ux1F(i,4),uy1F(i,5)
enddo
close(774)

end program sondes
