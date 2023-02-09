program write_time
   use netcdf
   implicit none

   integer :: ncid, time_varid, status
   integer :: dimids(1)
   real, dimension(8760) :: time
   integer :: i

   ! Define the time data
   do i = 1, 8760
      time(i) = (i - 0.5) / 24.0
   end do

   ! Create the netCDF file
   status = nf90_create("time_data.nc", NF90_CLOBBER, ncid)
   if (status /= NF90_NOERR) then
      write(*,*) "Error opening netCDF file!"
      stop
   end if

   ! Define the time dimension
   status = nf90_def_dim(ncid, "time", 8760, dimids(1))
   if (status /= NF90_NOERR) then
      write(*,*) "Error defining time dimension!"
      stop
   end if

   ! Define the time variable
   status = nf90_def_var(ncid, "time", NF90_REAL, 1, dimids, time_varid)
   if (status /= NF90_NOERR) then
      write(*,*) "Error defining time variable!"
      stop
   end if

   ! Set the units attribute for the time variable
   status = nf90_put_att(ncid, time_varid, "units", "days since 1850-01-01 00:00:00")
   if (status /= NF90_NOERR) then
      write(*,*) "Error setting units attribute for time variable!"
      stop
   end if

   ! End the definition phase
   status = nf90_enddef(ncid)
   if (status /= NF90_NOERR) then
      write(*,*) "Error ending definition phase!"
      stop
   end if

   ! Write the time data to the netCDF file
   status = nf90_put_var(ncid, time_varid, time)
   if (status /= NF90_NOERR) then
      write(*,*) "Error writing time data!"
      stop
   end if

   ! Close the netCDF file
   status = nf90_close(ncid)
   if (status /= NF90_NOERR) then
      write(*,*) "Error closing netCDF file!"
      stop
   end if

end program write_time

program write_netcdf
    use netcdf
    implicit none
    
    integer :: ncid, time_dimid, time_varid, data_varid
    integer :: start(1), count(1)
    integer :: i, j, status
    real, dimension(24) :: data
    real :: time(24)
 
    call check( nf90_create('test.nc', NF90_CLOBBER, ncid) )
 
    ! Define the time dimension
    call check( nf90_def_dim(ncid, 'time', 24, time_dimid) )
 
    ! Define the time variable
    call check( nf90_def_var(ncid, 'time', NF90_DOUBLE, 1, &
                             time_dimid, time_varid) )
    call check( nf90_put_att(ncid, time_varid, 'units', &
                             'hours since 2000-01-01 00:00:00') )
    call check( nf90_enddef(ncid) )
 
    ! Write the time data
    do i = 1, 24
       time(i) = (i-1)/24.0
    end do
 
    start = 1
    count = 24
    call check( nf90_put_var(ncid, time_varid, time, start, count) )
 
    ! Define the data variable
    call check( nf90_redef(ncid) )
    call check( nf90_def_var(ncid, 'data', NF90_FLOAT, 1, &
                             time_dimid, data_varid) )
    call check( nf90_put_att(ncid, data_varid, 'units', &
                             'units of data') )
    call check( nf90_enddef(ncid) )
 
    ! Write the data
    do i = 1, 24
       data(i) = i*i
    end do
 
    start = 1
    count = 24
    call check( nf90_put_var(ncid, data_varid, data, start, count) )
 
    call check( nf90_close(ncid) )
 
    contain
 
    subroutine check(status)
       if (status /= NF90_NOERR) then
          print *, nf90_strerror(status)
          stop
       end if
    end subroutine check
 
 end program write_netcdf
 
