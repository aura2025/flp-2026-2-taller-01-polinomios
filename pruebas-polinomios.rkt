#lang eopl
;Autores: Valentina Valencia Lopez 2459626, Aura Maria Pelaez Luna 2459422

;; TALLER 1 — MÓDULO DE PRUEBAS UNITARIAS
;; Archivo: pruebas-polinomios.rkt
;; Framework: rackunit
;; -----------------------------------------------------------------------------

(require rackunit)

;; Importación con prefijos para evitar conflictos de nombres entre representaciones
(require (prefix-in listas: "polinomios-listas.rkt"))
(require (prefix-in proc: "polinomios-procedimientos.rkt"))
(require (prefix-in dt: "polinomios-datatypes.rkt"))
(require (only-in racket/base exn:fail?)) 
;; ---------------------------------------------------------------------------



;; 1. PRUEBAS: REPRESENTACIÓN BASADA EN LISTAS
;;----------------------------------------------------------------------------

(define p-listas-base
  (listas:insertar-termino
   (listas:insertar-termino
    (listas:insertar-termino (listas:polinomio-cero 'x) 7 0)
    -3/2 2)
   4 5))

;; 1.1 Casos funcionales de las 4 operaciones
(check-true (listas:poli? (listas:polinomio-cero 'x)))
(check-equal? (listas:coeficiente-de p-listas-base 5) 4)
(check-equal? (listas:coeficiente-de p-listas-base 2) -3/2)
(check-equal? (listas:coeficiente-de p-listas-base 0) 7)

;; 1.2 Polinomio nulo como caso base (insertar, consultar, eliminar)
(define p-nulo-listas (listas:polinomio-cero 'x))
(check-equal? (listas:coeficiente-de (listas:insertar-termino p-nulo-listas 3 1) 1) 3)
(check-exn exn:fail? (lambda () (listas:coeficiente-de p-nulo-listas 0)))
(check-exn exn:fail? (lambda () (listas:eliminar-termino p-nulo-listas 0)))

;; 1.3 Inserción que cancela un término existente (suma de coeficientes da 0)
(define p-listas-cancelado (listas:insertar-termino p-listas-base 3/2 2))
(check-exn exn:fail? (lambda () (listas:coeficiente-de p-listas-cancelado 2)))

;; 1.4 Inserción con coeficiente 0 (debe dejar el polinomio inalterado)
(check-equal? (listas:insertar-termino p-listas-base 0 3) p-listas-base)

;; 1.5 eliminar-termino: caso funcional
(define p-sin-2 (listas:eliminar-termino p-listas-base 2))
(check-equal? (listas:coeficiente-de p-sin-2 5) 4)
(check-equal? (listas:coeficiente-de p-sin-2 0) 7)
(check-exn exn:fail? (lambda () (listas:coeficiente-de p-sin-2 2)))

;; 1.6 insertar-termino: sumar sobre exponente existente y exponente nuevo
(check-equal? (listas:coeficiente-de (listas:insertar-termino p-listas-base 1 2) 2) -1/2)
(check-equal? (listas:coeficiente-de (listas:insertar-termino p-listas-base 2 3) 3) 2)

;; 1.7 Los casos de error
;; Error 1: Exponente negativo
(check-exn exn:fail? (lambda () (listas:insertar-termino p-listas-base 5 -1)))
(check-exn exn:fail? (lambda () (listas:coeficiente-de p-listas-base -2)))
(check-exn exn:fail? (lambda () (listas:eliminar-termino p-listas-base -3)))
(check-exn exn:fail? (lambda () (listas:insertar-termino p-listas-base 3.5 2)))

;; Error 2: Exponente no registrado en coeficiente-de
(check-exn exn:fail? (lambda () (listas:coeficiente-de p-listas-base 3)))

;; Error 3: Exponente no registrado en eliminar-termino
(check-exn exn:fail? (lambda () (listas:eliminar-termino p-listas-base 3)))
;; ----------------------------------------------------------------------------



;; 2. PRUEBAS: REPRESENTACIÓN BASADA EN PROCEDIMIENTOS
;; -----------------------------------------------------------------------------

(define p-proc-base
  (proc:insertar-termino
   (proc:insertar-termino
    (proc:insertar-termino (proc:polinomio-cero 'x) 7 0)
    -3/2 2)
   4 5))

;; 2.1 Casos funcionales de las 4 operaciones
(check-true (proc:poli? (proc:polinomio-cero 'x)))
(check-equal? (proc:coeficiente-de p-proc-base 5) 4)
(check-equal? (proc:coeficiente-de p-proc-base 2) -3/2)
(check-equal? (proc:coeficiente-de p-proc-base 0) 7)

;; 2.2 Polinomio nulo como caso base
(define p-nulo-proc (proc:polinomio-cero 'x))
(check-equal? (proc:coeficiente-de (proc:insertar-termino p-nulo-proc 3 1) 1) 3)
(check-exn exn:fail? (lambda () (proc:coeficiente-de p-nulo-proc 0)))
(check-exn exn:fail? (lambda () (proc:eliminar-termino p-nulo-proc 0)))

;; 2.3 Inserción que cancela un término existente
(define p-proc-cancelado (proc:insertar-termino p-proc-base 3/2 2))
(check-exn exn:fail? (lambda () (proc:coeficiente-de p-proc-cancelado 2)))

;; 2.4 Inserción con coeficiente 0
(check-equal? (proc:coeficiente-de (proc:insertar-termino p-proc-base 0 3) 5) 4)
(check-equal? (proc:coeficiente-de (proc:insertar-termino p-proc-base 0 3) 2) -3/2)
(check-exn exn:fail? (lambda () (proc:coeficiente-de (proc:insertar-termino p-proc-base 0 3) 3)))

;; 2.5 eliminar-termino: caso funcional
(define p-proc-sin-2 (proc:eliminar-termino p-proc-base 2))
(check-equal? (proc:coeficiente-de p-proc-sin-2 5) 4)
(check-equal? (proc:coeficiente-de p-proc-sin-2 0) 7)
(check-exn exn:fail? (lambda () (proc:coeficiente-de p-proc-sin-2 2)))

;; 2.6 insertar-termino: sumar sobre exponente existente y exponente nuevo
(check-equal? (proc:coeficiente-de (proc:insertar-termino p-proc-base 1 2) 2) -1/2)
(check-equal? (proc:coeficiente-de (proc:insertar-termino p-proc-base 2 3) 3) 2)

;; 2.7 Los casos de error
(check-exn exn:fail? (lambda () (proc:insertar-termino p-proc-base 5 -1)))
(check-exn exn:fail? (lambda () (proc:coeficiente-de p-proc-base 3)))
(check-exn exn:fail? (lambda () (proc:eliminar-termino p-proc-base 3)))
(check-exn exn:fail? (lambda () (proc:coeficiente-de p-proc-base -2)))
(check-exn exn:fail? (lambda () (proc:eliminar-termino p-proc-base -3)))
(check-exn exn:fail? (lambda () (proc:insertar-termino p-proc-base 3.5 2)))
;; -----------------------------------------------------------------------------


