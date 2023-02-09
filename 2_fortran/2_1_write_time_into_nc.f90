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
