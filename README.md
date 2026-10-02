# Taller 1 — Polinomios dispersos

**Fundamentos de Interpretación y Compilación de Lenguajes de Programación**
Escuela de Ingeniería de Sistemas y Computación, Universidad del Valle
Profesor: Carlos Andrés Delgado Saavedra

## Integrantes

| Nombre completo | Código | Correo institucional |
|---|---|---|
| Valentina Valencia Lopez | 2459626 | valentina.valencia.lopez@correounivalle.edu.co |
| Aura Maria Pelaez Luna | 2459422 | aura.pelaez@correounivalle.edu.co |

## ¿Qué se hizo?

Se implementó un tipo abstracto de datos (TAD) para polinomios de una variable que guarda solo los términos no nulos, en orden decreciente de exponente. El mismo TAD se construyó de tres formas, con la misma interfaz:

- **Listas:** cada dato es una lista cuyo primer elemento es una etiqueta.
- **Procedimientos:** cada dato es un procedimiento que responde a mensajes, por lo que su estructura interna no se puede inspeccionar.
- **Datatypes:** se usa `define-datatype` y `cases`, y se agrega la operación `sumar`, que recorre los dos polinomios en paralelo una sola vez.

Las funciones `polinomio-cero`, `insertar-termino`, `coeficiente-de` y `eliminar-termino` son idénticas en las versiones con listas y con procedimientos, porque solo usan constructores, predicados y extractores. Esto muestra que el cliente de un TAD no necesita conocer su representación.

Además, se escribieron pruebas con `rackunit` para las tres representaciones y dos informes: uno de corrección (demostraciones por inducción estructural) y uno de árboles de sintaxis abstracta (diagramas en Mermaid).

## Archivos

```
polinomios-listas.rkt            Parte 1: representación con listas
polinomios-procedimientos.rkt    Parte 2: representación con procedimientos
polinomios-datatypes.rkt         Parte 3: representación con datatypes, más sumar
pruebas-polinomios.rkt           Parte 4: pruebas con rackunit
docs/informe-correccion.md       Parte 5: informe de corrección
docs/informe-ast.md              Parte 6: informe de AST
```

## Interfaz del TAD

| Función | Contrato | Listas | Procedimientos | Datatypes |
|---|---|:---:|:---:|:---:|
| `polinomio-cero` | símbolo → polinomio | ✔ | ✔ | ✔ |
| `insertar-termino` | polinomio × coeficiente × exponente → polinomio | ✔ | ✔ | ✔ |
| `coeficiente-de` | polinomio × exponente → coeficiente | ✔ | ✔ | ✔ |
| `eliminar-termino` | polinomio × exponente → polinomio | ✔ | ✔ | ✔ |
| `sumar` | polinomio × polinomio → polinomio | — | — | ✔ |

## Cómo correr las pruebas

```
racket pruebas-polinomios.rkt
```

Si todas las pruebas pasan, no imprime nada.
