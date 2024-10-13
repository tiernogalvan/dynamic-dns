# DNS dinámico

Este repo permite actualizar un nombre de dominio con el DNS dinámico de IONOS.

- Primero necesitas obtener la URL actualización de DNS dinámico (explicado a continuación).
- Luego lanzas un contenedor docker que hace una simple llamada a esta URL cada 5 minutos para actualizar el dominio.
- IONOS establece en el nombre de dominio la IP pública desde la que se llame a la URL, por lo que puedes ejecutar el contenedor desde cualquier equipo dentro de tu red.
- IONOS tiene un límite de 2 consultas por minuto a esta URL.

Todo el código de este repo es muy sencillo, por favor revisalo si quieres ver más detalles.

## Ejecución

IONOS funciona en dos pasos:

1. Obtener la URL de DNS dinámico.

- Entra en <https://my.ionos.es/shop/product/ionos-api> para generar una API key como se explica en [esta guia](https://developer.hosting.ionos.es/docs/getstarted).

- Copia el *public_prefix* y el *secret* y pégalo en el fichero <utils/get-ionos-url.env> junto a tu dominio:
```
IONOS_PUBLIC_PREFIX=''
IONOS_SECRET=''
DOMAIN_NAME=''
```

- Tras ello, ejecuta el script [utils/get-ionos-url.sh](utils/get-ionos-url.sh)
```
$ cd utils
$ ./get-ionos-url.sh
```

El resultado del script te proporciona un json con una **updateUrl**.

2. Copia la **updateUrl** en el fichero [.env](.env) y ejecuta el contenedor docker, que la leerá y llamará periodicamente.

```
$ docker compose up -d
```

## Monitorización

El contenedor incluye un webhook de monitorización que indica:
- Si todo va bien.
- Si no se ha ejecutado el DNS dinámico en los últimos 5 minutos.
- Si se ha recibido una respuesta de error de IONOS.

El webhook está en `/status` y el <docker-compose.yml> lo pone por defecto en el puerto 8080:
```
$ curl localhost:8080/status
{
  "status": "OK",
  "last_request": {
    "date": "2024-10-12 19:01:18",
    "return_code": "200"
  }
}
```

Para más info revisa el script <status/status.sh>.


## Referencias

- [IONOS documentation > DNS API](https://developer.hosting.ionos.es/docs/dns)
- [Getting started with IONOS API](https://developer.hosting.ionos.es/docs/getstarted)
