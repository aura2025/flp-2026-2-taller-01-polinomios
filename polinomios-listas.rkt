#lang eopl
;Autores: Valentina Valencia Lopez  2459626, Aura Maria Pelaez Luna 2459422

;; Taller 1 — Polinomios dispersos.
;; Parte 1: representación basada en listas.
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio


;; CONSTRUCTORES, PREDICADOS Y EXTRACTORES (REPRESENTACIÓN BASADA EN LISTAS)

;;-----------------------------------------------------------

;;poli(var, terms)

;;Constructor

;; poli : variable x terminos -> polinomio
;; Propósito: Construye un polinomio a partir de una variable y su estructura de términos.


(define poli
  (lambda (var terms)
    (list 'poli var terms)
    )
  )
;;Predicado

;; poli? : valor -> boolean
;; Propósito: Indica si un valor dado es un polinomio (construido con el constructor poli).


(define poli?
  (lambda (x)
    ( and (pair? x) (eq? (car x) 'poli))
    )
  )

;;Extractor

;; poli->var : polinomio -> variable
;; Propósito: Extrae la variable de un polinomio.

(define poli->var
  (lambda (p)
    (cadr p)
    )
  )

;; poli->terms : polinomio -> terminos
;; Propósito: Extrae la lista/estructura de términos de un polinomio.

(define poli->terms
  (lambda (p)
    (caddr p)
    )
  )

;;-----------------------------------------------------------

;;nombre-var(s)

;;Constructor

;; nombre-var : symbol -> variable
;; Propósito: Construye una variable a partir de un símbolo.

(define nombre-var
  (lambda (s)
    (list 'nombre-var s)
    )
  )

;;Predicado

;; nombre-var? : valor -> boolean
;; Propósito: Indica si un valor dado es una variable (construida con nombre-var).

(define nombre-var?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'nombre-var))
    )
  )

;;Extractor

;; nombre-var->s : variable -> symbol
;; Propósito: Extrae el símbolo asociado a una variable.

(define nombre-var->s
  (lambda (nom)
    (cadr nom)
    )
  )

;;-----------------------------------------------------------

;;sin-terminos()


;;Constructor

;; sin-terminos : () -> terminos
;; Propósito: Construye la representación de una lista vacía de términos.

(define sin-terminos
  (lambda ()
    (list 'sin-terminos)
    )
  )

;;Predicado

;; sin-terminos? : valor -> boolean
;; Propósito: Indica si un valor representa la ausencia de términos (sin-terminos).

(define sin-terminos?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'sin-terminos))
    )
  )


;;-----------------------------------------------------------

;;mas-terminos(term, resto)


;;Constructor

;; mas-terminos : termino x terminos -> terminos
;; Propósito: Agrega un término al inicio de una estructura de términos.

(define mas-terminos
  (lambda (term resto)
  (list 'mas-terminos term resto)
    )
  )

;;Predicado

;; mas-terminos? : valor -> boolean
;; Propósito: Indica si un valor representa una estructura con uno o más términos (mas-terminos).

(define mas-terminos?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'mas-terminos))
    )
  )

;;Extractor

;; mas-terminos->term : terminos -> termino
;; Propósito: Extrae el primer término de una estructura mas-terminos.

(define mas-terminos->term
  (lambda (m-term)
    (cadr m-term)
    )
  )

;; mas-terminos->resto : terminos -> terminos
;; Propósito: Extrae el resto de los términos de una estructura mas-terminos.

(define mas-terminos->resto
  (lambda (m-term)
    (caddr m-term)
    )
  )

;;-----------------------------------------------------------

;;termino(coef, expo)

;;Constructor

;; termino : coeficiente x exponente -> termino
;; Propósito: Construye un término a partir de un coeficiente y un exponente.

(define termino
  (lambda (coef expo)
    (list 'termino coef expo)
    )
  )

;;Predicado

;; termino? : valor -> boolean
;; Propósito: Indica si un valor dado es un término.

(define termino?
  (lambda (x)
    (and (pair? x) (eq?(car x) 'termino))
    )
  )

;;Extractor

;; termino->coef : termino -> coeficiente
;; Propósito: Extrae el coeficiente de un término.

(define termino->coef
  (lambda (term)
    (cadr term)
    )
  )

;; termino->expo : termino -> exponente
;; Propósito: Extrae el exponente de un término.

(define termino->expo
  (lambda (term)
    (caddr term)
    )
  )

;;-----------------------------------------------------------

;;coef-ent(n)

;;Constructor

;; coef-ent : integer -> coeficiente
;; Propósito: Construye un coeficiente a partir de un número entero.

(define coef-ent
  (lambda (n)
    (list 'coef-ent n)
     )
  )

;; Predicado

;; coef-ent? : valor -> boolean
;; Propósito: Indica si un valor es un coeficiente entero (coef-ent).

(define coef-ent?
  (lambda (x)
    (and(pair? x)(eq? (car x) 'coef-ent))
    )
  )

;;Extractor

;; coef-ent->n : coeficiente -> integer
;; Propósito: Extrae el valor entero de un coeficiente entero.

(define coef-ent->n
  (lambda (coef-e)
    (cadr coef-e)
    )
  )


;;-----------------------------------------------------------

;;coef-rac(num,dem)

;;Constructor

;; coef-rac : integer x integer -> coeficiente
;; Propósito: Construye un coeficiente racional a partir de un numerador y un denominador.

(define coef-rac
  (lambda (num den)
    (list 'coef-rac num den)
    )
  )

;;Predicado

;; coef-rac? : valor -> boolean
;; Propósito: Indica si un valor es un coeficiente racional (coef-rac).

(define coef-rac?
  (lambda(x)
    (and(pair? x)(eq? (car x)'coef-rac))
    )
  )


;;Extractor

;; coef-rac->num : coeficiente -> integer
;; Propósito: Extrae el numerador de un coeficiente racional.

(define coef-rac->num
  (lambda (coef-r)
      (cadr coef-r)
      )
  )

;; coef-rac->den : coeficiente -> integer
;; Propósito: Extrae el denominador de un coeficiente racional.

(define coef-rac->den
  (lambda (coef-r)
      (caddr coef-r)
      )
  )

;;-----------------------------------------------------------

;;expo-nat(k)

;;Constructor

;; expo-nat : integer -> exponente
;; Propósito: Construye un exponente natural a partir de un entero no negativo.

(define expo-nat
  (lambda (k)
    (list 'expo-nat k)
    )
  )

;;Predicado

;; expo-nat? : valor -> boolean
;; Propósito: Indica si un valor es un exponente natural (expo-nat).

(define expo-nat?
  (lambda (x)
    (and (pair? x) (eq? (car x) 'expo-nat))
    )
  )

;;Extractor

;; expo-nat->k : exponente -> integer
;; Propósito: Extrae el número entero no negativo de un exponente natural.

(define expo-nat->k
  (lambda (expo-n)
    (cadr expo-n)
    )
  )









