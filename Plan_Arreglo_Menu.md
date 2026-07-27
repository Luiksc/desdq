# Plan de Arreglo de Bugs en `menu_cinema`

Este documento describe la estrategia para solucionar los 8 bugs identificados en la escena del menú, garantizando que el juego no tenga crasheos, bloqueos de animación o comportamientos extraños al seleccionar un nivel.

## Cambios Propuestos

### Componente Script (`menu_cinema.gd`)
1. **Evitar bucle de animación "oho" (Bug 3)**: 
   En `_process`, se añadirá la verificación `if anima_don.current_animation != "oho":` para evitar que la animación de Don Menú se reinicie en cada frame y pueda completarse.
2. **Prevenir Race Conditions de `await` en `_process` (Bug 2 y Bug 7)**: 
   Se agregará una variable `procesando_click = false`. Si está en `true`, `_process` ignorará nuevos clics. Esto evitará que se abran múltiples corrutinas y que el juego intente cargar dos niveles al mismo tiempo.
3. **Corregir bugs de `mouse_entered`/`mouse_exited` (Bug 4)**: 
   Se eliminarán los `await animation_finished` de estas funciones. Las variables booleanas (`clicki1`, `clicki2`, `clicki3`) se actualizarán inmediatamente al entrar o salir el mouse. Así, aunque el jugador mueva el mouse muy rápido, la lógica nunca se quedará trabada.
4. **Prevenir clics prematuros en los libros (Bug 5)**: 
   Se agregarán referencias a los `StaticBody3D` de los 3 libros. En la función `_ready`, se desactivará su interacción (`input_ray_pickable = false`). Solo se activará cuando la cámara termine de acercarse a ellos tras presionar el botón "Iniciar".
5. **Botón de regreso (Bug 6)**: 
   Se implementará la opción de presionar "Escape" (acción `ui_cancel`) para regresar a la vista principal si el jugador se arrepiente y quiere volver a ver al personaje, revirtiendo la animación de la cámara.
6. **Unificar nombre de animación (Bug 1)**: 
   Cambiaremos el código `anima_libro2.play("desselccion")` a `"desseleccion"` para que coincida con la corrección que haremos en el archivo `.tscn`.

### Componente Escena (`menu_cinema.tscn`)
1. **Corrección de Typo (Bug 1)**: Buscaré la cadena `"desselccion"` (typo actual) en el archivo `.tscn` y la reemplazaré por `"desseleccion"` en la definición de la animación y en el diccionario del `AnimationLibrary`.

## Plan de Verificación

Una vez aplicados los cambios, será necesario realizar las siguientes pruebas manuales ejecutando el juego:
- **Prueba Visual**: Comprobar que la animación de "Don Menú" se reproduce correctamente y no se queda congelada.
- **Prueba de Interacción Prematura**: Intentar pasar el mouse sobre los libros antes de dar click en iniciar (no deberían iluminarse ni reaccionar).
- **Prueba de Estrés (Mouse)**: Dar click en iniciar, esperar a que la cámara llegue a los libros, y pasar el mouse rápidamente entrando y saliendo de los libros. La selección no debería romperse.
- **Prueba de Regreso**: Presionar "Escape" para asegurar que la cámara vuelve a la vista original.
- **Prueba de Transición**: Hacer click en un libro y comprobar que carga el nivel sin problemas, sin dobles cargas.
