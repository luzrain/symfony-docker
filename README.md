# Базовое symfony приложение для запуска в docker

symfony version: `6.0.*`  
php version: `8.1`  

Для запуска приложения на компьютере должны быть установлены docker и docker-compose.  

 ### Makefile

```bash
  make help
```
Показать справку  

```bash
  make start
```
Сборка и запуск докер контейнеров (для dev окружения)  

```bash
  make start-prod
```
Сборка и запуск докер контейнеров (для production окружения)  

```bash
  make stop
```
Остановка докер контейнеров  

```bash
  make clean
```
Удалить образы и очистить директории  

```bash
  make logs
```
Показать логи  

```bash
  make sh
```
Войти в консоль контейнера с приложением  
