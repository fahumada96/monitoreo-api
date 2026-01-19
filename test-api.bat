@echo off
setlocal EnableDelayedExpansion
set "API_HOST=lxhndmonitor"
set "API_PORT=5000"
echo ============================================
echo Script de prueba para PruebaPrometheus API
echo ============================================
echo.

echo Generando 10 operaciones rapidas...
for /L %%i in (1,1,10) do (
    curl -X POST http://%API_HOST%:%API_PORT%/example/process ^
         -H "Content-Type: application/json" ^
         -d "{\"operationType\":\"fast\"}" ^
         --silent --show-error
    echo Operacion rapida %%i completada
    timeout /t 1 /nobreak >nul
)

echo.
echo Generando 5 operaciones lentas...
for /L %%i in (1,1,5) do (
    curl -X POST http://%API_HOST%:%API_PORT%/example/process ^
         -H "Content-Type: application/json" ^
         -d "{\"operationType\":\"slow\"}" ^
         --silent --show-error
    echo Operacion lenta %%i completada
    timeout /t 2 /nobreak >nul
)

echo.
echo Generando 8 transacciones premium...
set amounts=1200 800 1500 300 2000 450 1100 600
set /a counter=0
for %%a in (%amounts%) do (
    set /a counter+=1
    curl -X POST http://%API_HOST%:%API_PORT%/example/transaction ^
         -H "Content-Type: application/json" ^
         -d "{\"amount\":%%a,\"accountType\":\"premium\"}" ^
         --silent --show-error
    echo Transaccion premium !counter! completada: $%%a
    timeout /t 1 /nobreak >nul
)

echo.
echo Generando 12 transacciones standard...
for /L %%i in (1,1,12) do (
    set /a amount=50 + !RANDOM! * 1450 / 32768
    curl -X POST http://%API_HOST%:%API_PORT%/example/transaction ^
         -H "Content-Type: application/json" ^
         -d "{\"amount\":!amount!,\"accountType\":\"standard\"}" ^
         --silent --show-error
    echo Transaccion standard %%i completada: $!amount!
    timeout /t 1 /nobreak >nul
)

echo.
echo ============================================
echo Obteniendo metricas finales...
echo ============================================
curl http://%API_HOST%:%API_PORT%/metrics --silent

echo.
echo ============================================
echo Script completado exitosamente
echo ============================================
pause