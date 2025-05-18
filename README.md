# PROYEK AKHIR SSF - KELOMPOK 14 || Integrated Circuit Validator – D Flip-Flop (74LS74) Testing System

- Christian Hadiwijaya  
- Shafwan Hasyim  
- Fadhlureza Sebastian  
- Gerrardin Nabil Zulhian

---

## Introduction

IC Checker adalah sistem berbasis mikrokontroler **ATmega328P** yang dirancang untuk menguji fungsi logika **IC D Flip-Flop 74LS74**. Sistem ini dibuat menggunakan **bahasa assembly AVR** dan mengandalkan **interrupt eksternal**, **komunikasi serial UART**, serta **LCD 16x2** sebagai antarmuka pengguna. Sistem ini cocok digunakan untuk pembelajaran dasar rangkaian digital dan praktikum mikrokontroler.

---

## Fitur Utama
- Pengujian otomatis dua flip-flop dalam IC 74LS74 secara paralel
- Indikator hasil pengujian via **LCD 16x2** dan **buzzer**
- Status hasil juga dikirim ke **serial monitor** melalui UART
- Pemicu pengujian menggunakan **tombol** dengan interrupt INT0
- Logika kontrol ditulis sepenuhnya dalam **AVR Assembly**

---

## Struktur Modul
- `IC_CHECKER.S` – Prosedur utama pengujian IC
- `Interrupt.S` – Handler dan konfigurasi eksternal interrupt INT0
- `LCD.S` – Pengontrol LCD mode 4-bit
- `Serial.S` – Komunikasi UART dan pengiriman hasil ke terminal
- `Delay.S` – Fungsi delay waktu (us/ms)

---

## Komponen yang Dibutuhkan

| Nama Komponen          | Jumlah | Keterangan                         |
|------------------------|--------|-------------------------------------|
| ATmega328P             | 1      | Mikrokontroler utama               |
| IC 74LS74              | 1      | IC D Flip-Flop (dual flip-flop)    |
| LCD 16x2 (parallel)    | 1      | Antarmuka tampilan                 |
| Potensiometer 10kΩ     | 1      | Pengatur kontras LCD               |
| Push Button            | 1      | Trigger pengujian (INT0)           |
| Resistor 10kΩ          | 2      | Pull-up untuk tombol dan reset     |
| Resistor 220Ω          | 1      | Seri dengan buzzer                 |
| Buzzer aktif           | 1      | Indikator suara                    |
| Breadboard             | 1      | Perakitan rangkaian                |
| Kabel jumper           | ~20    | Koneksi antar komponen             |

---

## Konfigurasi Pin ATmega328P

| Fungsi        | Pin ATmega328P |
|---------------|----------------|
| D Input       | PB5 (Digital 13) |
| Clock         | PB4 (Digital 12) |
| Q Output 1    | PB3 (Digital 11) |
| Q Output 2    | PD3 (Digital 3)  |
| LCD RS        | PB1 (Digital 9)  |
| LCD EN        | PB0 (Digital 8)  |
| LCD D4–D7     | PD4–PD7          |
| Buzzer        | PB2 (Digital 10) |
| Tombol (INT0) | PD2 (Digital 2)  |
| UART TX       | PD1 (TX)         |
| UART RX       | PD0 (RX)         |

---

## Cara Kerja Sistem
1. User menekan tombol → interrupt INT0 dipicu
2. Sistem memberikan sinyal ke input D dan Clock
3. Output Q dari dua flip-flop dibaca
4. Jika sesuai: buzzer bunyi 2 kali, LCD tampil “OK”, UART kirim status
5. Jika tidak sesuai: buzzer berkedip, LCD tampil “FAULTY!”, UART kirim error
