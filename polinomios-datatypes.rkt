#lang eopl
;Autores: Valentina Valencia Lopez  2459626, Aura Maria Pelaez Luna 2459422

;; Taller 1 — Polinomios dispersos.
;; Parte 3: representación con datatypes.
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio
;;   sumar             : polinomio x polinomio -> polinomio



;; DEFINICIÓN DE DATATYPES (TIPOS DE DATOS ABSTRACTOS Y SUS CONSTRUCTORES)

;;-------------------------------------------------------

;;expo-nat(k)

;; entero-positivo? : valor -> boolean
;; Propósito: Predicado auxiliar que verifica si un valor es un entero mayor o igual a 0.

(define entero-positivo?
  (lambda (x)
    (and (integer? x) (>= x 0))
    )
  )

;; Datatype: exponente-tad
;; Predicado: exponente-tad? : valor -> boolean
;; Constructor:
;;   expo-nat : integer (>=0) -> exponente-tad
;; Propósito: Representa el exponente natural de un término dentro de la gramática.

(define-datatype exponente-tad exponente-tad?
  (expo-nat
   (k entero-positivo?)
   )
  )

;;--------------------------------------------------------

;;coeficiente

;; coef-ent(n)  coef-rac(num,den)

;; Datatype: coeficiente-tad
;; Predicado: coeficiente-tad? : valor -> boolean
;; Constructores:
;;   coef-ent : integer -> coeficiente-tad
;;   coef-rac : integer x integer -> coeficiente-tad
;; Propósito: Representa un coeficiente (ya sea entero o racional reducido) de un término.

(define-datatype coeficiente-tad coeficiente-tad?
  (coef-ent
   (n integer?)
   )
  (coef-rac
   (num integer?)
   (den integer?)
   )
  )

;;--------------------------------------------------------

;;termino

;;termino(coef, expo)

;; Datatype: termino-tad
;; Predicado: termino-tad? : valor -> boolean
;; Constructor:
;;   termino : coeficiente-tad x exponente-tad -> termino-tad
;; Propósito: Representa un término individual compuesto por un coeficiente y un exponente.

(define-datatype termino-tad termino-tad?
  (termino
   (coef coeficiente-tad?)
   (expo exponente-tad?)
   )
  )

;;--------------------------------------------------------

;;terminos

;;sin-terminos()  mas-terminos(term, resto)

;; Datatype: terminos
;; Predicado: terminos? : valor -> boolean
;; Constructores:
;;   sin-terminos : () -> terminos
;;   mas-terminos : termino-tad x terminos -> terminos
;; Propósito: Representa la estructura recursiva de la lista de términos de un polinomio.

(define-datatype terminos terminos?
  (sin-terminos)
  (mas-terminos
   (term termino-tad?)
   (resto terminos?)
   )
 )
;;--------------------------------------------------------

;;variable
;;nombre-var(s)

;; Datatype: variable
;; Predicado: variable? : valor -> boolean
;; Constructor:
;;   nombre-var : symbol -> variable
;; Propósito: Representa la variable algebraica asociada al polinomio.

(define-datatype variable variable?
  (nombre-var
   (s symbol?)
   )
 )

;;--------------------------------------------------------

;;polinomio
;;poli(var,terms)

;; Datatype: polinomio-tad
;; Predicado: polinomio-tad? : valor -> boolean
;; Constructor:
;;   poli : variable x terminos -> polinomio-tad
;; Propósito: Representa la estructura completa de un polinomio (variable y términos).

(define-datatype polinomio-tad polinomio-tad?
  (poli
   (var variable?)
   (terms terminos?)
   )
  )


