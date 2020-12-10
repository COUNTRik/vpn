# VPN

Примеры работы OpenVPN

## Сравнение tap и tun режимов в VPN

Запустим стенд *vagrant up* с двумя виртуальными машинами *server* и *client*, после нужно запустить *openvpn.yml*, который установит все пакеты и произведет первоначальную настройку сервера и клиента VPN в режим *tap*.

Замерим скорость на сервере и клиенте. На openvpn сервере запускаем iperf3 в режиме сервера

	iperf3 -s

На openvpn клиенте запускаем iperf3 в режиме клиента и замеряем скорость в туннеле

	iperf3 -c 10.10.10.1 -t 40 -i 5

Результаты:

	[root@client vagrant]# ip route
	default via 10.0.2.2 dev eth0 proto dhcp metric 100 
	10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
	10.10.10.0/24 dev tap0 proto kernel scope link src 10.10.10.2 
	192.168.10.0/24 dev eth1 proto kernel scope link src 192.168.10.20 metric 101 

	[root@client vagrant]# iperf3 -c 10.10.10.1 -t 40 -i 5
	Connecting to host 10.10.10.1, port 5201
	[  4] local 10.10.10.2 port 44946 connected to 10.10.10.1 port 5201
	[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
	[  4]   0.00-5.00   sec  81.9 MBytes   137 Mbits/sec  107    756 KBytes       
	[  4]   5.00-10.00  sec  84.8 MBytes   142 Mbits/sec    0    886 KBytes       
	[  4]  10.00-15.01  sec  85.9 MBytes   144 Mbits/sec    0    912 KBytes       
	[  4]  15.01-20.00  sec  84.8 MBytes   142 Mbits/sec   75    569 KBytes       
	[  4]  20.00-25.00  sec  86.0 MBytes   144 Mbits/sec    0    649 KBytes       
	[  4]  25.00-30.00  sec  84.7 MBytes   142 Mbits/sec    0    774 KBytes       
	[  4]  30.00-35.00  sec  83.5 MBytes   140 Mbits/sec    5   1002 KBytes       
	[  4]  35.00-40.00  sec  84.6 MBytes   142 Mbits/sec    0   1.25 MBytes       
	- - - - - - - - - - - - - - - - - - - - - - - - -
	[ ID] Interval           Transfer     Bandwidth       Retr
	[  4]   0.00-40.00  sec   676 MBytes   142 Mbits/sec  187             sender
	[  4]   0.00-40.00  sec   674 MBytes   141 Mbits/sec                  receiver

Для переключения в режим *tun* достаточно запустить *configure.yml*

Аналогично запускаем *iperf3*

Результаты:

	[root@client openvpn]# ip route
	default via 10.0.2.2 dev eth0 proto dhcp metric 100 
	10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
	10.10.10.0/24 dev tun0 proto kernel scope link src 10.10.10.2 
	192.168.10.0/24 dev eth1 proto kernel scope link src 192.168.10.20 metric 101 

	[root@client openvpn]# iperf3 -c 10.10.10.1 -t 40 -i 5
	Connecting to host 10.10.10.1, port 5201
	[  4] local 10.10.10.2 port 44950 connected to 10.10.10.1 port 5201
	[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
	[  4]   0.00-5.00   sec  81.6 MBytes   137 Mbits/sec   27    464 KBytes       
	[  4]   5.00-10.00  sec  84.9 MBytes   142 Mbits/sec  188    284 KBytes       
	[  4]  10.00-15.00  sec  86.1 MBytes   144 Mbits/sec    8    369 KBytes       
	[  4]  15.00-20.00  sec  84.5 MBytes   142 Mbits/sec    0    506 KBytes       
	[  4]  20.00-25.01  sec  84.5 MBytes   142 Mbits/sec   49    506 KBytes       
	[  4]  25.01-30.01  sec  85.8 MBytes   144 Mbits/sec    0    601 KBytes       
	[  4]  30.01-35.00  sec  83.9 MBytes   141 Mbits/sec    4    592 KBytes       
	[  4]  35.00-40.00  sec  83.5 MBytes   140 Mbits/sec    1    530 KBytes       
	- - - - - - - - - - - - - - - - - - - - - - - - -
	[ ID] Interval           Transfer     Bandwidth       Retr
	[  4]   0.00-40.00  sec   675 MBytes   141 Mbits/sec  277             sender
	[  4]   0.00-40.00  sec   673 MBytes   141 Mbits/sec                  receiver

Если сравнить результаты, то видно что ощутимо различаются только *Retr* количество повторно отправленных сегментов и *Cwnd* объем одновременно переданных данных. Из определений мы знаем, что *tap* оперирует кадрами ethernet, *tun* оперирует ip пакетами. Если я правильно понимаю, то маршрутизировать трафик лучше через *tun*, в то время как *tap* использовать для создания сетевого моста.

## RAS на базе OpenVPN

Основано на вот этой [стетье](https://serveradmin.ru/nastroyka-openvpn-na-centos-7/).

