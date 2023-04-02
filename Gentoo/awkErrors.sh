
echo \#testing musl lto fixes\n >> /mnt/etc/portage/package.cflags/lto.conf
#awk -F "/" '/ERROR:/ {print $1 $2}' < portagereview.txt | awk -F "[ -]" '{printf $4 "/" $5 "-"  $6 " *FLAGS+=-ffat-lto-objects" "\n"}'
awk -F "/" '/ERROR:/ {print $1 $2}' < portagereview.txt | awk -F "[ -]" '{printf $4 "/" $5 "-"  $6 " *FLAGS-=-flto*" "\n"}' >> /mnt/etc/portage/package.cflags/lto.conf

