# ResolverStyle
ROSA Linux: Selecting a resolver style (ROSA/Mageia)  
  
![](https://github.com/AKotov-dev/ResolverStyle/blob/main/Screenshot1.png)
  
Мотивация:
--
Недавно искал причину, почему выставляемые в `/etc/resolv.conf` от vpn dns принудительно перезаписываются на `127.0.0.53`. Виновником торжества оказался неуёмный `systemd-resolved`. Остановить (stop) и отключить (disable) его оказалось мало. Некоторые vpn-клиенты, например тот же `warp-cl`i ищут сервис systemd-resolved и если находят - пытаются его использовать.

Чтобы навсегда отключить в ROSA `systemd-resolved` его потребовалось маскировать (mask). Иначе либо он сам поднимется (после обновления?), либо его поднимут извне. `ResolverStyle` контролирует состояние `systemd-resolved` & `systemd-networkd`. В нём используется 2 варианта на выбор: "Стиль резольвера ROSA" (по умолчанию) и "Стиль резольвера Mageia" (отключение systemd-resolved с маскировкой и замещением файлов `/etc/NetworkManager/NetworkManager.conf` и `/etc/nsswitch.conf`).

Однострочные скрипты процессов (из рабочей директории):
```
# Стиль резольвера ROSA
cp -fv ./rosa/etc/nsswitch.conf /etc/nsswitch.conf; cp -fv ./rosa/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf; rm -f /etc/resolv.conf; ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf; systemctl unmask systemd-resolved systemd-networkd; systemctl enable systemd-resolved; systemctl restart systemd-resolved networkmanager
```
```
# Стиль резольвера Mageia
cp -fv ./mageia/etc/nsswitch.conf /etc/nsswitch.conf; cp -fv ./mageia/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf; systemctl stop systemd-resolved systemd-networkd; systemctl disable systemd-networkd systemd-resolved; systemctl mask systemd-resolved systemd-networkd; rm -f /etc/resolv.conf; echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf; systemctl restart networkmanager
```

Как показали тесты, вариант "Cтиль резольвера Mageia" решает большинство проблем, связанных с `systemd-resolved` в ROSA + делает её управляемой, предсказуемой и более безопасной.

