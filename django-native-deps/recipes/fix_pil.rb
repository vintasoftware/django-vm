execute 'fix PIL dependencies libraries' do
    command 'sudo ln -f -s /usr/lib/`ls /usr/lib/ | grep linux-gnu | head -n 1`/libfreetype.so /usr/lib/'
    command 'sudo ln -f -s /usr/lib/`ls /usr/lib/ | grep linux-gnu | head -n 1`/libjpeg.so /usr/lib/'
    command 'sudo ln -f -s /usr/lib/`ls /usr/lib/ | grep linux-gnu | head -n 1`/libz.so /usr/lib/'
end
